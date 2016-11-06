#import <Foundation/Foundation.h>
#import "AWRMetadataStore.h"
#import "PXPromise.h"

@interface AWRFakeStore : NSObject<AWRMetadataStore>

+ (void)configure;

@end
