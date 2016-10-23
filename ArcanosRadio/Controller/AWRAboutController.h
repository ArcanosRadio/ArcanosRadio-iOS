#import <UIKit/UIKit.h>
#import "AWRViewController.h"
#import "AWRLicenseViewModel.h"

@protocol AWRAboutControllerDelegate

- (void)userDidCloseAbout;
- (void)userDidSelectUrl:(NSURL *)url;
- (void)userDidSelectLicense:(AWRLicenseViewModel *)license;

@end

@interface AWRAboutController : AWRViewController

@property (weak, nonatomic) id<AWRAboutControllerDelegate>delegate;

@end
