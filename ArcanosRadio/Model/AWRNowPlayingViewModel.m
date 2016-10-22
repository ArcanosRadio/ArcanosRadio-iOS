#import "AWRNowPlayingViewModel.h"

@implementation AWRNowPlayingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.songName = @"";
        self.artistName = @"";
        self.lyrics = @"";
        self.albumArt = nil;
    }
    return self;
}

@end
