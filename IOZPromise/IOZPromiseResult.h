#import "IOZPromiseProtocol.h"
#import <Foundation/Foundation.h>

@interface IOZPromiseResult : NSObject <IOZSuccessfulPromise>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)initWithValue:(id)value NS_DESIGNATED_INITIALIZER;

@end
