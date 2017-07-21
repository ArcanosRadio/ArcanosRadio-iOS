#import "AWRMetadataStore.h"
#import <Bolts/BFTask.h>
#import <Foundation/Foundation.h>
#import <IOZPromise/IOZPromise.h>

@interface AWRParseMetadataStore : NSObject <AWRMetadataStore>

+ (void)configure;

@end
