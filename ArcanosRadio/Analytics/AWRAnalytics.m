#import "AWRAnalytics.h"
#import "AWRFabricAnswers.h"

@implementation AWRAnalytics

+ (id<AWRAnalyticsService>)sharedAnalytics {
    static AWRFabricAnswers *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[AWRFabricAnswers alloc] init];
    }
    return sharedInstance;
}

@end
