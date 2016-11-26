#import <Foundation/Foundation.h>
#import "AWRMetadataStore.h"
#import "AWRMetadataService.h"

@interface AWRMetadataFactory : NSObject

+ (Class<AWRMetadataStore>)metadataStoreClass;
+ (id<AWRMetadataStore>)createMetadataStore;
+ (id<AWRMetadataService>)createMetadataService;

@end
