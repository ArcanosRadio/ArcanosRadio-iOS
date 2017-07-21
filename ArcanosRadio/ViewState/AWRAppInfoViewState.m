#import "AWRAppInfoViewState.h"

@interface AWRAppInfoViewState ()

- (instancetype)initWithName:(NSString *)name details:(NSString *)details url:(NSString *)url;

@end

@implementation AWRAppInfoViewState

- (instancetype)initWithName:(NSString *)name details:(NSString *)details url:(NSString *)url {
    self = [super init];
    if (self) {
        self.name    = name;
        self.details = details;
        self.url     = [NSURL URLWithString:url];
    }
    return self;
}

+ (NSArray<AWRAppInfoViewState *> *)all {
    return @[
        [[AWRAppInfoViewState alloc] initWithName:NSLocalizedString(@"ABOUT_SOURCE_CODE_IOS", nil)
                                          details:NSLocalizedString(@"ABOUT_SOURCE_CODE_IOS_DETAILS", nil)
                                              url:NSLocalizedString(@"ABOUT_SOURCE_CODE_IOS_URL", nil)],
        [[AWRAppInfoViewState alloc] initWithName:NSLocalizedString(@"ABOUT_SOURCE_CODE_SERVER_API", nil)
                                          details:NSLocalizedString(@"ABOUT_SOURCE_CODE_SERVER_DETAILS", nil)
                                              url:NSLocalizedString(@"ABOUT_SOURCE_CODE_SERVER_URL", nil)],
        [[AWRAppInfoViewState alloc] initWithName:NSLocalizedString(@"ABOUT_ARCANOS", nil)
                                          details:NSLocalizedString(@"ABOUT_ARCANOS_DETAILS", nil)
                                              url:NSLocalizedString(@"ABOUT_ARCANOS_URL", nil)]
    ];
}

@end
