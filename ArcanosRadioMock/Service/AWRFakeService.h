#import <Foundation/Foundation.h>
#import "AWRMetadataStore.h"
#import <Bolts/BFTask.h>
#import "PXPromise.h"
#import "BFTask+PXPromise.h"

@interface AWRFakeService : NSObject<AWRMetadataStore>

+ (void)configure;

@end
