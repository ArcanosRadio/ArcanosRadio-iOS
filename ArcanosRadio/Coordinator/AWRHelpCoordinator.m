#import "AWRHelpCoordinator.h"
#import "AWRAboutController.h"
#import "AWRLicenseController.h"
#import "AWRLicenseViewState.h"

@interface AWRHelpCoordinator () <AWRAboutControllerDelegate, AWRLicenseControllerDelegate>

@property (nonatomic, strong) UIViewController *aboutController;
@property (nonatomic, strong) UIViewController *currentController;

@end

@implementation AWRHelpCoordinator

- (UIViewController *)start {
    AWRAboutController *aboutController  = [[AWRAboutController alloc] init];
    aboutController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    aboutController.delegate             = self;

    self.currentController = self.aboutController = aboutController;
    return self.aboutController;
}

- (void)userDidCloseAbout {
    if (!self.delegate) return;

    [self.delegate coordinator:self didFinishExecutingItsMainController:self.aboutController];
}

- (void)userDidSelectUrl:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)userDidSelectLicense:(AWRLicenseViewState *)license {
    AWRLicenseController *licenseController = [[AWRLicenseController alloc] init];
    licenseController.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
    licenseController.delegate              = self;
    [licenseController setLicenseModel:license];
    [self.aboutController presentViewController:licenseController
                                       animated:YES
                                     completion:^{
                                         self.currentController = licenseController;
                                     }];
}

- (void)userDidCloseLicense {
    [self.currentController dismissViewControllerAnimated:YES
                                               completion:^{
                                                   self.currentController = self.aboutController;
                                               }];
}

@end
