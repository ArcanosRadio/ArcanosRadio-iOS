#import "AWRMetadataFactory.h"
#import "AWRFakeStore.h"
#import "AWRMetadataPoolingService.h"


@implementation AWRMetadataFactory

+ (id<AWRMetadataStore>)createMetadataStore {
    return [[AWRFakeStore alloc] init];
}

+ (id<AWRMetadataService>)createMetadataService {
    return [[AWRMetadataPoolingService alloc] initWithStore:[self createMetadataStore]];
}

@end
