#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *kKeepScreenOn;
extern NSString *kStreamOverMobileData;

@interface AWRAppCoordinator : NSObject

- (UIViewController *)start;

- (void)runningInBackground;
- (void)runningInForeground;
- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler;

@end
