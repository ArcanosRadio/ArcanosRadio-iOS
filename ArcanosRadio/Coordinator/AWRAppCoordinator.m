#import "AWRAppCoordinator.h"
#import "AWRCrashReportController.h"
#import "AWRHelpCoordinator.h"
#import "AWRMetadataFactory.h"
#import "AWRNowPlayingCoordinator.h"
#import "AWRReachability.h"
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

@interface AWRAppCoordinator () <AWRNowPlayingCoordinatorDelegate, AWRHelpCoordinatorDelegate, CrashlyticsDelegate>

@property (nonatomic, strong) AWRNowPlayingCoordinator *nowPlayingCoordinator;
@property (nonatomic, strong) AWRReachability *reachability;
@property (nonatomic, strong) UIViewController *mainController;
@property (nonatomic, strong) NSObject *currentCoordinator;

@end

@implementation AWRAppCoordinator

- (instancetype)initWithOptions:(NSDictionary *)launchOptions {
    self = [super init];
    if (self) {
        [Crashlytics startWithAPIKey:FABRIC_API_KEY delegate:self];
        [[Twitter sharedInstance] startWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
        [Fabric with:@[ [Crashlytics class], [Twitter class] ]];
    }
    return self;
}

- (AWRNowPlayingCoordinator *)nowPlayingCoordinator {
    if (!_nowPlayingCoordinator) {
        _nowPlayingCoordinator          = [[AWRNowPlayingCoordinator alloc] init];
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
}

- (UIViewController *)start {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:CONFIG_KEEP_SCREEN_ON_KEY options:NSKeyValueObservingOptionNew context:NULL];
    [defaults addObserver:self forKeyPath:CONFIG_STREAM_OVER_MOBILE_DATA_KEY options:NSKeyValueObservingOptionNew context:NULL];
    [self evaluateSettings:defaults];

    AWRMetadataFactory.settings =
        @{ @"PARSE_APPLICATION_ID" : PARSE_APP,
           @"PARSE_CLIENT_KEY" : PARSE_CLIENT_KEY,
           @"PARSE_SERVER_URL" : PARSE_URL };
    [[AWRMetadataFactory createMetadataStore] refreshConfig];
    [self.reachability startNotifier];
    self.currentCoordinator    = self.nowPlayingCoordinator;
    return self.mainController = [self.nowPlayingCoordinator start];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self evaluateSettings:[NSUserDefaults standardUserDefaults]];
}

- (void)evaluateSettings:(NSUserDefaults *)defaults {
    [[UIApplication sharedApplication] setIdleTimerDisabled:[defaults boolForKey:CONFIG_KEEP_SCREEN_ON_KEY]];
    if ([defaults valueForKey:CONFIG_AGREE_WITH_CRASH_REPORTS_KEY] == nil) {
        [defaults setBool:YES forKey:CONFIG_AGREE_WITH_CRASH_REPORTS_KEY];
    }
}

- (void)userDidSelectAbout {
    AWRHelpCoordinator *helpCoordinator = [[AWRHelpCoordinator alloc] init];
    self.currentCoordinator             = helpCoordinator;
    helpCoordinator.delegate            = self;
    [self.mainController presentViewController:[helpCoordinator start] animated:YES completion:NULL];
}

- (void)coordinator:(AWRHelpCoordinator *)coordinator didFinishExecutingItsMainController:(UIViewController *)controller {
    __weak typeof(self) weakSelf = self;
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
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

- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler {
    AWRCrashReportController *crashReportController = [[AWRCrashReportController alloc] initWithParent:self.mainController];
    [crashReportController sendReport:report completionHandler:completionHandler];
}

@end
