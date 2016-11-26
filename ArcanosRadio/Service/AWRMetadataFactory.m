#import "AWRMetadataFactory.h"
#import "AWRParseMetadataStore.h"
#import "AWRMetadataPoolingService.h"

@implementation AWRMetadataFactory

+ (Class<AWRMetadataStore>)metadataStoreClass {
    return [AWRParseMetadataStore class];
}

+ (id<AWRMetadataStore>)createMetadataStore {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        [AWRParseMetadataStore configure];
    });

    return [[AWRParseMetadataStore alloc] init];
}

+ (id<AWRMetadataService>)createMetadataService {
    return [[AWRMetadataPoolingService alloc] initWithStore:[self createMetadataStore]];
}

@end
