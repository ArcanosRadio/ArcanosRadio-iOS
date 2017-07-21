#import "AWRNowPlayingViewState.h"

@implementation AWRNowPlayingViewState

- (instancetype)init {
    self = [super init];
    if (self) {
        self.songName   = @"";
        self.artistName = @"";
        self.lyrics     = @"";
        self.albumArt   = nil;
    }
    return self;
}

@end
