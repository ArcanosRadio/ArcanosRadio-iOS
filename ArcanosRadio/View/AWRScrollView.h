#import <UIKit/UIKit.h>

@class AWRScrollView;

@protocol AWRScrollViewDelegate

- (BOOL)scrollView:(AWRScrollView *)scrollView isAllowedToHandleTouchAt:(CGPoint)point;

@end

@interface AWRScrollView : UIScrollView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<AWRScrollViewDelegate> scrollViewDelegate;

@end
