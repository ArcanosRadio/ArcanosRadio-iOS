#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *kKeepScreenOn;
extern NSString *kStreamOverMobileData;

@interface AWRAppCoordinator : NSObject

- (UIViewController *)start;

@end
