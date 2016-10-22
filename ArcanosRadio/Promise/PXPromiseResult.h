#import <Foundation/Foundation.h>
#import "PXPromiseProtocol.h"

@interface PXPromiseResult : NSObject<PXSuccessfulPromise>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithValue:(id)value NS_DESIGNATED_INITIALIZER;

@end
