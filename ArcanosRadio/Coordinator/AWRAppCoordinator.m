#import "AWRAppCoordinator.h"
#import "AWRNowPlayingCoordinator.h"
#import "AWRHelpCoordinator.h"
#import "AWRReachability.h"
#ifndef MOCK
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#define CRASHLYTICS_DELEGATE , CrashlyticsDelegate
#endif

@interface AWRAppCoordinator()<AWRNowPlayingCoordinatorDelegate, AWRHelpCoordinatorDelegate CRASHLYTICS_DELEGATE>

@property (nonatomic, strong) AWRNowPlayingCoordinator *nowPlayingCoordinator;
@property (nonatomic, strong) AWRReachability *reachability;
@property (nonatomic, strong) UIViewController * mainController;
@property (nonatomic, strong) NSObject *currentCoordinator;

@end

NSString *kKeepScreenOn = @"keep_screen_on";
NSString *kAgreeWithCrashReports = @"agree_with_crash_reports";
NSString *kStreamOverMobileData = @"mobile_data_enabled";

@implementation AWRAppCoordinator

- (instancetype)init {
    self = [super init];
    if (self) {
#ifndef MOCK
        [Crashlytics startWithAPIKey:FABRIC_API_KEY delegate:self];
        [Fabric with:@[[Crashlytics class]]];
#endif
    }
    return self;
}

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
    if ([defaults valueForKey:kAgreeWithCrashReports] == nil) {
        [defaults setBool:YES forKey:kAgreeWithCrashReports];
    }
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

- (void)runningInBackground {
    [self.nowPlayingCoordinator runningInBackground];
}

- (void)runningInForeground {
    [self.nowPlayingCoordinator runningInForeground];
}

- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler {
    [self.nowPlayingCoordinator backgroundFetchWithCompletionHandler:completionHandler];
}

#ifndef MOCK
- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler {

    BOOL reportCrash = [[NSUserDefaults standardUserDefaults] boolForKey:kAgreeWithCrashReports];

    if (reportCrash) {
        completionHandler(YES);
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"CRASHREPORT_REQUEST_TITLE", nil)
                                                                      message:NSLocalizedString(@"CRASHREPORT_REQUEST_MESSAGE", nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"CRASHREPORT_REQUEST_NEVER_SEND", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }]];

        [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"CRASHREPORT_REQUEST_ALWAYS_SEND", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAgreeWithCrashReports];
            completionHandler(YES);
        }]];

        [self.mainController presentViewController:alert animated:YES completion:NULL];
    }

}
#endif

@end
