#import <IOZPromise/IOZPromise.h>
#import <Foundation/Foundation.h>
#import "AWRMetadataStore.h"
#import <Bolts/BFTask.h>

@interface AWRParseMetadataStore : NSObject<AWRMetadataStore>

+ (void)configure;

@end
