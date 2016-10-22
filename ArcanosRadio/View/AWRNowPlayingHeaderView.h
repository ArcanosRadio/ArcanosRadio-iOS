#import <UIKit/UIKit.h>
#import "AWRNowPlayingViewModel.h"

@interface AWRNowPlayingHeaderView : UIView

@property (nonatomic)float metadataOffset;
@property (nonatomic)float metadataAlpha;

- (void)renderModel:(AWRNowPlayingViewModel *)model;
- (float)maximumHeight;
- (float)minimumHeight;

@end
