#import "AWRMetadataPoolingService.h"
#import "AWRMetadataStore.h"
#import "AWRMetadataFactory.h"

@interface AWRMetadataPoolingService()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) id<AWRMetadataStore> metadataStore;
@property (nonatomic,getter=isForegroundExecution) BOOL foregroundExecution;
@property (nonatomic)NSTimeInterval timerInterval;
@property (nonatomic)double timerIntervalActive;
@property (nonatomic)double timerIntervalBackground;
@property (nonatomic) BOOL serverRightsFlag;
@property (nonatomic) BOOL localRightsFlag;

@end

@implementation AWRMetadataPoolingService

- (instancetype)initWithStore:(id<AWRMetadataStore>)store {
    self = [super init];
    if (self) {
        self.metadataStore = store;
        id<AWRMetadataStore> store = [AWRMetadataFactory createMetadataStore];
        self.timerIntervalActive = [[store readConfig:REMOTE_CONFIG_POOLING_TIME_ACTIVE_KEY] doubleValue];
        self.timerIntervalBackground = [[store readConfig:REMOTE_CONFIG_POOLING_TIME_BACKGROUND_KEY] doubleValue];
        self.serverRightsFlag = [[store readConfig:REMOTE_CONFIG_RIGHTS_FLAG_KEY] boolValue];
        self.localRightsFlag = [[NSUserDefaults standardUserDefaults] boolForKey:CONFIG_RIGHTS_FLAG_KEY];

        _foregroundExecution = YES;
        self.timerInterval = self.timerIntervalActive;
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
        __weak typeof(self) weakSelf = self;
        DLog(@"Timer: %f", self.timerInterval);
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:weakSelf selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)tick:(NSTimer *)timer {
    [self fetchCurrentSong].catch(^id<PXPromise>(id<PXBrokenPromise> finishedPromise) {
        NSLog(@"Error pooling for new song: %@", finishedPromise.error);
        return [PXNoMorePromises new];
    });
}

- (id<PXPromise>)fetchCurrentSong {
    __weak typeof(self) weakSelf = self;

    return [self.metadataStore currentSong]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            id<AWRPlaylist>result = finishedPromise.result;

            if (!result) {
                DLog(@"Current song: no result");
                if (!weakSelf.currentPlaylist) return [PXNoMorePromises new];
                weakSelf.currentPlaylist = nil;
                if (weakSelf.delegate) [weakSelf.delegate metadataDidChangeTheSong:nil];
                return [PXNoMorePromises new];
            }

            double diff = [result.updatedAt timeIntervalSinceReferenceDate] - [weakSelf.currentPlaylist.updatedAt timeIntervalSinceReferenceDate];

            if (diff < 2) {
                return [[NSError alloc] initWithDomain:@"Song hasn't changed since last time we've checked" code:-200 userInfo:nil];
            }

            weakSelf.currentPlaylist = result;

            DLog(@"New song: %@ by %@ (since %@)", result.song.songName, result.song.artist.artistName, result.updatedAt);

            if (weakSelf.delegate) [weakSelf.delegate metadataDidChangeTheSong:weakSelf.currentPlaylist.song];

            if (!weakSelf.currentPlaylist.song) return [PXNoMorePromises new];

            [weakSelf fetchArtistDescriptionAsync];

            [weakSelf fetchSongDescriptionAsync];

            [weakSelf fetchAlbumArtAsync];

            [weakSelf fetchAlbumLyricsAsync];

            return [PXNoMorePromises new];
        });
}

- (NSString *)locale {
    return @"en";
}

- (void)fetchArtistDescriptionAsync {
    __weak typeof(self) weakSelf = self;

    [weakSelf.metadataStore descriptionForArtist:weakSelf.currentPlaylist.song.artist locale:self.locale]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingArtistDescription:forSong:)]) {
                [weakSelf.delegate metadataDidFinishDownloadingArtistDescription:finishedPromise.result forSong:weakSelf.currentPlaylist.song];
            }
            return [PXNoMorePromises new];
        });
}

- (void)fetchSongDescriptionAsync {
    __weak typeof(self) weakSelf = self;

    [weakSelf.metadataStore descriptionForSong:weakSelf.currentPlaylist.song locale:self.locale]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingSongDescription:forSong:)]) {
                [weakSelf.delegate metadataDidFinishDownloadingSongDescription:finishedPromise.result forSong:weakSelf.currentPlaylist.song];
            }
            return [PXNoMorePromises new];
        });
}

- (void)fetchAlbumArtAsync {
    __weak typeof(self) weakSelf = self;

    if (!weakSelf.currentPlaylist.song.albumArt) {
        return;
    }

    [weakSelf.metadataStore albumArtBySong:weakSelf.currentPlaylist.song]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            NSData *data = finishedPromise.result;
            UIImage *albumArt = [UIImage imageWithData:data];
            [weakSelf.delegate metadataDidFinishDownloadingAlbumArt:albumArt forSong:weakSelf.currentPlaylist.song];
            return [PXNoMorePromises new];
        });
}

- (void)fetchAlbumLyricsAsync {
    __weak typeof(self) weakSelf = self;

    BOOL hasRights = weakSelf.currentPlaylist.song.hasRightsContract || self.serverRightsFlag || self.localRightsFlag;

    if (!hasRights || !weakSelf.currentPlaylist.song.lyrics) {
        NSString *noLyrics = NSLocalizedString(@"LYRICS_UNAVAILABLE", nil);

        if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingLyrics:forSong:)]) {
            [weakSelf.delegate metadataDidFinishDownloadingLyrics:noLyrics forSong:weakSelf.currentPlaylist.song];
        }

        return;
    }

    [weakSelf.metadataStore lyricsBySong:weakSelf.currentPlaylist.song]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            if ([weakSelf.delegate respondsToSelector:@selector(metadataDidFinishDownloadingLyrics:forSong:)]) {
                [weakSelf.delegate metadataDidFinishDownloadingLyrics:finishedPromise.result forSong:weakSelf.currentPlaylist.song];
            }
            return [PXNoMorePromises new];
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

- (void)foregroundMode { self.foregroundExecution = YES; }

- (void)backgroundMode { self.foregroundExecution = NO; }

- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler {
    NSString *songBefore = self.currentPlaylist.song.songName;

    [self fetchCurrentSong]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            NSString *songNow = self.currentPlaylist.song.songName;
            if ([songBefore isEqualToString:songNow]) {
                completionHandler(NO);
            } else {
                completionHandler(YES);
            }
            return [PXNoMorePromises new];
        }).catch(^id<PXPromise>(id<PXBrokenPromise> finishedPromise) {
            completionHandler(NO);
            return [PXNoMorePromises new];
        });
}

@end
