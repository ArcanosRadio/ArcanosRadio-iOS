#import "AWRMetadataService.h"
#import "AWRMetadataStore.h"
#import <Foundation/Foundation.h>

@interface AWRMetadataFactory : NSObject

@property (nonatomic, strong, class) NSDictionary<NSString *, NSString *> *settings;
+ (Class<AWRMetadataStore>)metadataStoreClass;
+ (id<AWRMetadataStore>)createMetadataStore;
+ (id<AWRMetadataService>)createMetadataService;
@end
