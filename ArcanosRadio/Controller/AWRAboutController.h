#import <UIKit/UIKit.h>
#import "AWRViewController.h"

@protocol AWRAboutControllerDelegate

- (void)userDidCloseAbout;

@end

@interface AWRAboutController : AWRViewController

@property (weak, nonatomic) id<AWRAboutControllerDelegate>delegate;

@end
