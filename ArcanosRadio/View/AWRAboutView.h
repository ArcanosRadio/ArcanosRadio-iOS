#import <UIKit/UIKit.h>

@protocol AWRAboutViewDelegate

- (void)backButtonPressed;

@end

@interface AWRAboutView : UIView

@property (nonatomic, weak)id<AWRAboutViewDelegate> delegate;

@end
