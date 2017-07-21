#import "AWRAnalyticsService.h"
#import <Foundation/Foundation.h>

@interface AWRAnalytics : NSObject

+ (id<AWRAnalyticsService>)sharedAnalytics;

@end
