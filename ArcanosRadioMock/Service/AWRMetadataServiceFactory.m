#import "AWRMetadataFactory.h"
#import "AWRFakeService.h"
#import "AWRMetadataPoolingService.h"


@implementation AWRMetadataFactory

+ (id<AWRMetadataStore>)createMetadataStore {
    return [[AWRFakeService alloc] init];
}

+ (id<AWRMetadataService>)createMetadataService {
    return [[AWRMetadataPoolingService alloc] initWithStore:[self createMetadataStore]];
}

@end
