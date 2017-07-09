#import <UIKit/UIKit.h>
#import "AWRViewController.h"
#import "AWRLicenseViewState.h"

@protocol AWRAboutControllerDelegate

- (void)userDidCloseAbout;
- (void)userDidSelectUrl:(NSURL *)url;
- (void)userDidSelectLicense:(AWRLicenseViewState *)license;

@end

@interface AWRAboutController : AWRViewController

@property (weak, nonatomic) id<AWRAboutControllerDelegate>delegate;

@end
