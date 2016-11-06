#import "AWRMetadataPoolingService.h"
#import "AWRMetadataStore.h"
#import "AWRMetadataFactory.h"

NSString *const kPoolingTimeActiveConfigKey = @"iphonePoolingTimeActive";
NSString *const kPoolingTimeBackgroundConfigKey = @"iphonePoolingTimeBackground";

@interface AWRMetadataPoolingService()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, nullable, strong) id<AWRPlaylist>currentPlaylist;
@property (nonatomic, strong) id<AWRMetadataStore> metadataStore;
@property (nonatomic,getter=isForegroundExecution) BOOL foregroundExecution;
@property (nonatomic)NSTimeInterval timerInterval;

@property (nonatomic)double timerIntervalActive;
@property (nonatomic)double timerIntervalBackground;

@end

@implementation AWRMetadataPoolingService

- (instancetype)initWithStore:(id<AWRMetadataStore>)store {
    self = [super init];
    if (self) {
        self.metadataStore = store;
        id<AWRMetadataStore> store = [AWRMetadataFactory createMetadataStore];
        self.timerIntervalActive = [[store readConfig:kPoolingTimeActiveConfigKey] doubleValue];
        self.timerIntervalBackground = [[store readConfig:kPoolingTimeBackgroundConfigKey] doubleValue];
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
    [self downloadCurrentSong].catch(^id<PXPromise>(id<PXBrokenPromise> finishedPromise) {
        NSLog(@"Error pooling for new song: %@", finishedPromise.error);
        return [PXNoMorePromises new];
    });
}

- (id<PXPromise>)downloadCurrentSong {
    __weak typeof(self) weakSelf = self;

    return [self.metadataStore currentSong]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            id<AWRPlaylist>result = finishedPromise.result;

            if (!result) {
                DLog(@"Current song: no result");
                if (!weakSelf.currentPlaylist) return [PXNoMorePromises new];
                weakSelf.currentPlaylist = nil;
                if (weakSelf.delegate) [weakSelf.delegate didFetchSongMetadata:nil];
                return [PXNoMorePromises new];
            }

            double diff = [result.updatedAt timeIntervalSinceReferenceDate] - [weakSelf.currentPlaylist.updatedAt timeIntervalSinceReferenceDate];

            DLog(@"Current: %@ (%@) - Before: %@ (%@) = %f",
                 result.title,
                 result.updatedAt,
                 weakSelf.currentPlaylist.title,
                 weakSelf.currentPlaylist.updatedAt,
                 diff);

            if (diff < 2) {
                DLog(@"Current song: no changes");
                return [[NSError alloc] initWithDomain:@"Song hasn't changed since last time we've checked" code:-200 userInfo:nil];
            }

            weakSelf.currentPlaylist = result;

            DLog(@"Current song: new song: %@ by %@", result.song.songName, result.song.artist.artistName);

            if (weakSelf.delegate) [weakSelf.delegate didFetchSongMetadata:weakSelf.currentPlaylist];

            if (!weakSelf.currentPlaylist.song) return [PXNoMorePromises new];

            [weakSelf downloadAlbumArtAsync];

            [weakSelf downloadAlbumLyricsAsync];

            return [PXNoMorePromises new];
        });
}

- (void)downloadAlbumArtAsync {
    __weak typeof(self) weakSelf = self;

    if (!weakSelf.currentPlaylist.song.albumArt) {
        return;
    }

    [weakSelf.metadataStore albumArtBySong:weakSelf.currentPlaylist.song]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            [weakSelf.delegate didFetchSongAlbumArt:finishedPromise.result];
            return [PXNoMorePromises new];
        });
}

- (void)downloadAlbumLyricsAsync {
    __weak typeof(self) weakSelf = self;

    if (!weakSelf.currentPlaylist.song.lyrics) {
        return;
    }

    [weakSelf.metadataStore lyricsBySong:weakSelf.currentPlaylist.song]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            [weakSelf.delegate didFetchSongLyrics:finishedPromise.result];
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

    [self downloadCurrentSong]
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
