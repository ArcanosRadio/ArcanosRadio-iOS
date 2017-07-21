#import "AWRMetadataFactory.h"
#import "AWRMetadataPoolingService.h"
#import "AWRParseMetadataStore.h"

@implementation AWRMetadataFactory

static NSDictionary *_settings;
+ (NSDictionary<NSString *, NSString *> *)settings {
    return _settings;
}

+ (void)setSettings:(NSDictionary<NSString *, NSString *> *)settings {
    _settings = settings;
}

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
