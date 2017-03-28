#import <UIKit/UIKit.h>
#import "AWRNowPlayingViewModel.h"

@protocol AWRNowPlayingHeaderViewDelegate <NSObject>

- (void)didTapStatusBar;

@end

@interface AWRNowPlayingHeaderView : UIView

@property (weak, nonatomic)id<AWRNowPlayingHeaderViewDelegate> delegate;
@property (nonatomic)float metadataOffset;
@property (nonatomic)float metadataAlpha;

- (void)renderModel:(AWRNowPlayingViewModel *)model;
- (float)maximumHeight;
- (float)minimumHeight;

@end
