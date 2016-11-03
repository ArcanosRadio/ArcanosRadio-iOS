#import "AppDelegate.h"
#import "AWRAppCoordinator.h"

@interface AppDelegate ()

@property (nonatomic, strong) AWRAppCoordinator *coordinator;

@end

@implementation AppDelegate

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteControlEventReceived" object:event];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    self.coordinator = [[AWRAppCoordinator alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self.coordinator start];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.coordinator runningInBackground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.coordinator runningInForeground];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    DLog(@"Background fetch");
    [self.coordinator backgroundFetchWithCompletionHandler:^(BOOL newSong) {
        DLog(@"Background fetch result: %@", newSong?@"new song":@"same song");
        completionHandler(newSong ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultNoData);
    }];
}

@end
