#import <Foundation/Foundation.h>
#import "AWRMetadataStore.h"
#import <Bolts/BFTask.h>
#import <IOZPromise/IOZPromise.h>

@interface AWRParseMetadataStore : NSObject<AWRMetadataStore>

+ (void)configure;

@end
