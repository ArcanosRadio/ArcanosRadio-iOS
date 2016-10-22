#import <UIKit/UIKit.h>

@protocol AWRAboutControllerDelegate

@end

@interface AWRAboutController : UIViewController

@property (weak, nonatomic) id<AWRAboutControllerDelegate>delegate;

@end
