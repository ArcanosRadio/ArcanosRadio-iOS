#import "AWRLicenseViewState.h"
#import "AWRViewController.h"
#import <UIKit/UIKit.h>

@protocol AWRLicenseControllerDelegate

- (void)userDidCloseLicense;

@end

@interface AWRLicenseController : AWRViewController

@property (weak, nonatomic) id<AWRLicenseControllerDelegate> delegate;
@property (strong, nonatomic) AWRLicenseViewState *licenseModel;

@end
