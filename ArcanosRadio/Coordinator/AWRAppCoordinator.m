#import "AWRAppCoordinator.h"
#import "AWRNowPlayingCoordinator.h"
#import "AWRHelpCoordinator.h"
#import "AWRReachability.h"

@interface AWRAppCoordinator()<AWRNowPlayingCoordinatorDelegate, AWRHelpCoordinatorDelegate>

@property (nonatomic, strong) AWRNowPlayingCoordinator *nowPlayingCoordinator;
@property (nonatomic, strong) AWRReachability *reachability;
@property (nonatomic, strong) UIViewController * mainController;
@property (nonatomic, strong) NSObject *currentCoordinator;

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
//    NetworkStatus status = [self.reachability currentReachabilityStatus];
//
//    if(status == NotReachable) {
//        NSLog(@"Sorry, bro! No internet for you");
//    }
//    else if (status == ReachableViaWiFi) {
//        NSLog(@"Wi-fi");
//    }
//    else if (status == ReachableViaWWAN) {
//        NSLog(@"3g");
//    }
}

- (UIViewController *)start {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:kKeepScreenOn options:NSKeyValueObservingOptionNew context:NULL];
    [defaults addObserver:self forKeyPath:kStreamOverMobileData options:NSKeyValueObservingOptionNew context:NULL];
    [self evaluateSettings:defaults];

    [self.reachability startNotifier];
    self.currentCoordinator = self.nowPlayingCoordinator;
    return self.mainController = [self.nowPlayingCoordinator start];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self evaluateSettings:[NSUserDefaults standardUserDefaults]];
}

- (void)evaluateSettings:(NSUserDefaults *)defaults {
    [[UIApplication sharedApplication] setIdleTimerDisabled:[defaults boolForKey:kKeepScreenOn]];
}

- (void)userDidSelectAbout {
    AWRHelpCoordinator *helpCoordinator = [[AWRHelpCoordinator alloc] init];
    self.currentCoordinator = helpCoordinator;
    helpCoordinator.delegate = self;
    [self.mainController presentViewController:[helpCoordinator start] animated:YES completion:NULL];
}

- (void)coordinator:(AWRHelpCoordinator *)coordinator didFinishExecutingItsMainController:(UIViewController *)controller {
    __weak typeof(self) weakSelf = self;
    [controller dismissViewControllerAnimated:YES completion:^{
        weakSelf.currentCoordinator = weakSelf.nowPlayingCoordinator;
    }];
}

- (void)userDidSelectSettings {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
