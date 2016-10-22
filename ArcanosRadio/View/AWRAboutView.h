#import <UIKit/UIKit.h>

@protocol AWRAboutViewDelegate

@end

@interface AWRAboutView : UIView

@property (nonatomic, weak)id<AWRAboutViewDelegate> delegate;

@end
