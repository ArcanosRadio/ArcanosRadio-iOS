#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AWRAppCoordinator : NSObject

- (UIViewController *)start;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary *)launchOptions NS_DESIGNATED_INITIALIZER;
- (void)runningInBackground;
- (void)runningInForeground;
- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler;

@end
