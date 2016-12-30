#import <UIKit/UIKit.h>
#import "AWRNowPlayingViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWRNowPlayingBodyView : UIView

@property (nonatomic)float titleAlpha;
- (void)renderModel:(AWRNowPlayingViewModel *)model;
- (void)setTwitterView:(UITableView *)twitterView;
@end

NS_ASSUME_NONNULL_END
