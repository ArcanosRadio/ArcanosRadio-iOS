#import <Foundation/Foundation.h>
#import "AWRMetadataStore.h"
#import "AWRMetadataService.h"

@interface AWRMetadataFactory : NSObject

+ (id<AWRMetadataStore>)createMetadataStore;
+ (id<AWRMetadataService>)createMetadataService;

@end
