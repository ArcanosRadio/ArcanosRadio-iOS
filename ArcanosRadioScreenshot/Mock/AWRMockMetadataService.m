#import "AWRMockMetadataService.h"

@implementation AWRMockMetadataService

- (instancetype)initWithStore:(id<AWRMetadataStore>)store {
    return nil;
}

- (void)startScheduledFetch {
}

- (void)cancelScheduledFetch {
}

- (void)backgroundMode {
}

- (void)foregroundMode {
}

- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler {
}

+ (AWRMockMetadataService *)sharedInstance {
    static AWRMockMetadataService *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[AWRMockMetadataService alloc] init];
    }
    return sharedInstance;
}

- (void)setSong:(id<AWRSong>)song lyrics:(NSString *)lyrics art:(UIImage *)art {
    if (self.delegate) {
        [self.delegate metadataDidChangeTheSong:song];
        [self.delegate metadataDidFinishDownloadingLyrics:lyrics forSong:song];
        [self.delegate metadataDidFinishDownloadingAlbumArt:art forSong:song];
    }
}

@end
