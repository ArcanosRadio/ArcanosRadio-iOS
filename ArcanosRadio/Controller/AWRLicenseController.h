#import <UIKit/UIKit.h>
#import "AWRViewController.h"
#import "AWRLicenseViewModel.h"

@protocol AWRLicenseControllerDelegate

- (void)userDidCloseLicense;

@end

@interface AWRLicenseController : AWRViewController

@property (weak, nonatomic) id<AWRLicenseControllerDelegate>delegate;
@property (strong, nonatomic) AWRLicenseViewModel *licenseModel;

@end
