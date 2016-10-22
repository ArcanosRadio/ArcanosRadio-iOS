#import "AppDelegate.h"
#import "AWRAppCoordinator.h"
#ifndef MOCK
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#endif

@interface AppDelegate ()

@property (nonatomic, strong) AWRAppCoordinator *coordinator;

@end

@implementation AppDelegate

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteControlEventReceived" object:event];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifndef MOCK
    [Fabric with:@[[Crashlytics class]]];
#endif
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coordinator = [[AWRAppCoordinator alloc] init];
    self.window.rootViewController = [self.coordinator start];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
