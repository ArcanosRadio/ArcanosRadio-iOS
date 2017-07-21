#import <Crashlytics/Crashlytics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AWRCrashReportController : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)initWithParent:(UIViewController *)parent NS_DESIGNATED_INITIALIZER;
- (void)sendReport:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler;

@end
