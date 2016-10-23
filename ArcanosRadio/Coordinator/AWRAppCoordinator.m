#import "AWRAppCoordinator.h"
#import "AWRNowPlayingCoordinator.h"
#import "AWRReachability.h"
#import "AWRAboutController.h"
#import "AWRLicenseController.h"
#import "AWRLicenseViewModel.h"

@interface AWRAppCoordinator()<AWRNowPlayingCoordinatorDelegate, AWRAboutControllerDelegate, AWRLicenseControllerDelegate>

@property (nonatomic, strong) AWRNowPlayingCoordinator *nowPlayingCoordinator;
@property (nonatomic, strong) AWRReachability *reachability;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *controllerStack;

@end

NSString *kKeepScreenOn = @"keep_screen_on";
NSString *kStreamOverMobileData = @"mobile_data_enabled";

@implementation AWRAppCoordinator

- (AWRNowPlayingCoordinator *)nowPlayingCoordinator {
    if (!_nowPlayingCoordinator) {
        _nowPlayingCoordinator = [[AWRNowPlayingCoordinator alloc] init];
        _nowPlayingCoordinator.delegate = self;
    }
    return _nowPlayingCoordinator;
}

- (AWRReachability *)reachability {
    if (!_reachability) {
        _reachability = [AWRReachability reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedReachability:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return _reachability;
}

- (void)receivedReachability:(NSNotification *)note {
    NetworkStatus status = [self.reachability currentReachabilityStatus];

    if(status == NotReachable) {
        NSLog(@"Sorry, bro! No internet for you");
    }
    else if (status == ReachableViaWiFi) {
        NSLog(@"Wi-fi");
    }
    else if (status == ReachableViaWWAN) {
        NSLog(@"3g");
    }
}

- (NSMutableArray<UIViewController *> *)controllerStack {
    if (!_controllerStack) {
        _controllerStack = [[NSMutableArray alloc] init];
    }
    return _controllerStack;
}

- (UIViewController *)start {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:kKeepScreenOn options:NSKeyValueObservingOptionNew context:NULL];
    [defaults addObserver:self forKeyPath:kStreamOverMobileData options:NSKeyValueObservingOptionNew context:NULL];
    [self evaluateSettings:defaults];

    [self.reachability startNotifier];
    [self.controllerStack addObject:[self.nowPlayingCoordinator start]];
    return self.currentController;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self evaluateSettings:[NSUserDefaults standardUserDefaults]];
}

- (void)evaluateSettings:(NSUserDefaults *)defaults {
    [[UIApplication sharedApplication] setIdleTimerDisabled:[defaults boolForKey:kKeepScreenOn]];
}

- (void)userDidSelectAbout {
    AWRAboutController *aboutController = [[AWRAboutController alloc] init];
//    aboutController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    aboutController.delegate = self;

    [self.currentController presentViewController:aboutController animated:YES completion:^{
        [self.controllerStack addObject:aboutController];
    }];
}

- (UIViewController *)currentController {
    return [self.controllerStack lastObject];
}

- (void)userDidCloseAbout {
    [self.currentController dismissViewControllerAnimated:YES completion:^{
        [self.controllerStack removeLastObject];
    }];
}

- (void)userDidSelectUrl:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)userDidSelectLicense:(AWRLicenseViewModel *)license {
    AWRLicenseController *licenseController = [[AWRLicenseController alloc] init];
    licenseController.delegate = self;
    [licenseController setLicenseModel:license];
    [self.currentController presentViewController:licenseController animated:YES completion:^{
        [self.controllerStack addObject:licenseController];
    }];
}

- (void)userDidSelectSettings {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)userDidCloseLicense {
    [self.currentController dismissViewControllerAnimated:YES completion:^{
        [self.controllerStack removeLastObject];
    }];
}

@end
