#import "AWRMetadataPoolingService.h"
#import "AWRMetadataFactory.h"
#import "AWRMetadataStore.h"
#import <IOZPromise/IOZPromise.h>

@interface AWRMetadataPoolingService ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id<AWRMetadataStore> metadataStore;
@property (nonatomic, getter=isForegroundExecution) BOOL foregroundExecution;
@property (nonatomic) NSTimeInterval timerInterval;
@property (nonatomic) double timerIntervalActive;
@property (nonatomic) double timerIntervalBackground;
@property (nonatomic) BOOL serverRightsFlag;
@property (nonatomic) BOOL localRightsFlag;

@end

@implementation AWRMetadataPoolingService
NSString *const CONFIG_RIGHTS_FLAG_KEY                    = @"rights_flag";
NSString *const REMOTE_CONFIG_RIGHTS_FLAG_KEY             = @"iphoneRightsFlag";
NSString *const REMOTE_CONFIG_POOLING_TIME_ACTIVE_KEY     = @"iphonePoolingTimeActive";
NSString *const REMOTE_CONFIG_POOLING_TIME_BACKGROUND_KEY = @"iphonePoolingTimeBackground";

- (instancetype)initWithStore:(id<AWRMetadataStore>)store {
    self = [super init];
    if (self) {
        self.metadataStore           = store;
        id<AWRMetadataStore> store   = [AWRMetadataFactory createMetadataStore];
        self.timerIntervalActive     = [[store readConfig:REMOTE_CONFIG_POOLING_TIME_ACTIVE_KEY] doubleValue];
        self.timerIntervalBackground = [[store readConfig:REMOTE_CONFIG_POOLING_TIME_BACKGROUND_KEY] doubleValue];
        self.serverRightsFlag        = [[store readConfig:REMOTE_CONFIG_RIGHTS_FLAG_KEY] boolValue];
        self.localRightsFlag         = [[NSUserDefaults standardUserDefaults] boolForKey:CONFIG_RIGHTS_FLAG_KEY];

        _foregroundExecution = YES;
        self.timerInterval   = self.timerIntervalActive;
    }
    return self;
}

- (void)startScheduledFetch {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)cancelScheduledFetch {
    [self.timer invalidate];
    self.timer = nil;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)tick:(NSTimer *)timer {
    [self fetchCurrentSong].catch(^id<IOZPromise>(id<IOZBrokenPromise> finishedPromise) {
        return [IOZNoMorePromises new];
    });
}

- (id<IOZPromise>)fetchCurrentSong {
    __weak typeof(self) weakSelf = self;
    return [self.metadataStore currentSong].then(^id<IOZPromise>(id<IOZSuccessfulPromise> finishedPromise) {
        id<AWRPlaylist> result = finishedPromise.result;

        if (!result) {
            if (!weakSelf.currentPlaylist) return [IOZNoMorePromises new];
            weakSelf.currentPlaylist = nil;
            if (weakSelf.delegate) [weakSelf.delegate metadataDidChangeTheSong:nil];
            return [IOZNoMorePromises new];
        }

        double diff =
            [result.updatedAt timeIntervalSinceReferenceDate] - [weakSelf.currentPlaylist.updatedAt timeIntervalSinceReferenceDate];

        if (diff < 2) {
            return [[NSError alloc] initWithDomain:@"Song hasn't changed since last time we've checked" code:-200 userInfo:nil];
        }

        weakSelf.currentPlaylist = result;

        if (weakSelf.delegate) [weakSelf.delegate metadataDidChangeTheSong:weakSelf.currentPlaylist.song];

        if (!weakSelf.currentPlaylist.song) return [IOZNoMorePromises new];

        [weakSelf fetchArtistDescriptionAsync];

        [weakSelf fetchSongDescriptionAsync];

        [weakSelf fetchAlbumArtAsync];

        [weakSelf fetchAlbumLyricsAsync];

        return [IOZNoMorePromises new];
    });
}

- (NSString *)locale {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

- (void)fetchArtistDescriptionAsync {
    __weak typeof(self) weakSelf = self;

    [self.metadataStore descriptionForArtist:self.currentPlaylist.song.artist locale:self.locale].then(^id<IOZPromise>(
        id<IOZSuccessfulPromise> finishedPromise) {
        if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingArtistDescription:forSong:)]) {
            [weakSelf.delegate metadataDidFinishDownloadingArtistDescription:finishedPromise.result forSong:weakSelf.currentPlaylist.song];
        }
        return [IOZNoMorePromises new];
    });
}

- (void)fetchSongDescriptionAsync {
    __weak typeof(self) weakSelf = self;

    [self.metadataStore descriptionForSong:self.currentPlaylist.song locale:self.locale].then(^id<IOZPromise>(
        id<IOZSuccessfulPromise> finishedPromise) {
        if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingSongDescription:forSong:)]) {
            [weakSelf.delegate metadataDidFinishDownloadingSongDescription:finishedPromise.result forSong:weakSelf.currentPlaylist.song];
        }
        return [IOZNoMorePromises new];
    });
}

- (void)fetchAlbumArtAsync {
    if (!self.currentPlaylist.song.albumArt) {
        return;
    }

    __weak typeof(self) weakSelf = self;

    [self.metadataStore albumArtBySong:self.currentPlaylist.song].then(^id<IOZPromise>(id<IOZSuccessfulPromise> finishedPromise) {
        NSData *data      = finishedPromise.result;
        UIImage *albumArt = [UIImage imageWithData:data];
        [weakSelf.delegate metadataDidFinishDownloadingAlbumArt:albumArt forSong:weakSelf.currentPlaylist.song];
        return [IOZNoMorePromises new];
    });
}

- (void)fetchAlbumLyricsAsync {
    BOOL hasRights = self.currentPlaylist.song.hasRightsContract || self.serverRightsFlag || self.localRightsFlag;

    if (!hasRights || !self.currentPlaylist.song.lyrics) {
        NSString *noLyrics = NSLocalizedString(@"LYRICS_UNAVAILABLE", nil);

        if ([self.delegate respondsToSelector:@selector(metadataDidFinishDownloadingLyrics:forSong:)]) {
            [self.delegate metadataDidFinishDownloadingLyrics:noLyrics forSong:self.currentPlaylist.song];
        }

        return;
    }

    __weak typeof(self) weakSelf = self;

    [self.metadataStore lyricsBySong:self.currentPlaylist.song].then(^id<IOZPromise>(id<IOZSuccessfulPromise> finishedPromise) {
        if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingLyrics:forSong:)]) {
            [weakSelf.delegate metadataDidFinishDownloadingLyrics:finishedPromise.result forSong:weakSelf.currentPlaylist.song];
        }
        return [IOZNoMorePromises new];
    });
}

- (void)setForegroundExecution:(BOOL)foregroundExecution {
    if (_foregroundExecution == foregroundExecution) return;
    _foregroundExecution = foregroundExecution;
    if (_foregroundExecution) {
        [self cancelScheduledFetch];
        self.timerInterval = self.timerIntervalActive;
        [self startScheduledFetch];
    } else {
        [self cancelScheduledFetch];
        self.timerInterval = self.timerIntervalBackground;
        [self startScheduledFetch];
    }
}

- (void)foregroundMode {
    self.foregroundExecution = YES;
}

- (void)backgroundMode {
    self.foregroundExecution = NO;
}

- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler {
    NSString *songBefore = self.currentPlaylist.song.songName;

    [self fetchCurrentSong]
        .then(^id<IOZPromise>(id<IOZSuccessfulPromise> finishedPromise) {
            NSString *songNow = self.currentPlaylist.song.songName;
            if ([songBefore isEqualToString:songNow]) {
                completionHandler(NO);
            } else {
                completionHandler(YES);
            }
            return [IOZNoMorePromises new];
        })
        .catch(^id<IOZPromise>(id<IOZBrokenPromise> finishedPromise) {
            completionHandler(NO);
            return [IOZNoMorePromises new];
        });
}

@end
