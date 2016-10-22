#import "AWRMetadataPoolingService.h"
#import "AWRMetadataStore.h"
#import "AWRMetadataFactory.h"

@interface AWRMetadataPoolingService()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, nullable, strong) id<AWRPlaylist>currentPlaylist;
@property (nonatomic, strong) id<AWRMetadataStore> metadataStore;

@end

@implementation AWRMetadataPoolingService

- (instancetype)initWithStore:(id<AWRMetadataStore>)store {
    self = [super init];
    if (self) {
        self.metadataStore = store;
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:weakSelf selector:@selector(downloadCurrentSong:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)downloadCurrentSong:(NSTimer *)timer {
    __weak typeof(self) weakSelf = self;

    [self.metadataStore currentSong]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            id<AWRPlaylist>result = finishedPromise.result;

            if (!result) {
                if (!weakSelf.currentPlaylist) return [PXNoMorePromises new];
                weakSelf.currentPlaylist = nil;
                if (weakSelf.delegate) [weakSelf.delegate didFetchSongMetadata:nil];
                return [PXNoMorePromises new];
            }

            double diff = [result.updatedAt timeIntervalSinceReferenceDate] - [weakSelf.currentPlaylist.updatedAt timeIntervalSinceReferenceDate];

            if (diff < 2) {
                return [[NSError alloc] initWithDomain:@"Song hasn't changed since last time we've checked" code:-200 userInfo:nil];
            }

            weakSelf.currentPlaylist = result;

            if (weakSelf.delegate) [weakSelf.delegate didFetchSongMetadata:weakSelf.currentPlaylist];

            if (!weakSelf.currentPlaylist.song) return [PXNoMorePromises new];

            [weakSelf downloadAlbumArtAsync];

            [weakSelf downloadAlbumLyricsAsync];

            return [PXNoMorePromises new];
        }).catch(^id<PXPromise>(id<PXBrokenPromise> finishedPromise) {
            NSLog(@"Error pooling for new song: %@", finishedPromise.error);
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

@end
