#import "AWRAppDeveloperViewState.h"

@interface AWRAppDeveloperViewState()

- (instancetype) initWithName:(NSString *)name details:(NSString *)details moreDetails:(NSString *)moreDetails url:(NSString *)url;

@end

@implementation AWRAppDeveloperViewState

- (instancetype)initWithName:(NSString *)name details:(NSString *)details moreDetails:(NSString *)moreDetails url:(NSString *)url {
    self = [super init];
    if (self) {
        self.name = name;
        self.details = details;
        self.moreDetails = moreDetails;
        self.url = [NSURL URLWithString:url];
    }
    return self;
}

+ (NSArray<AWRAppDeveloperViewState *> *)all {
    return @[ [[AWRAppDeveloperViewState alloc] initWithName:NSLocalizedString(@"ABOUT_LUIZ_NAME", nil)
                                                     details:NSLocalizedString(@"ABOUT_LUIZ_DETAILS_A", nil)
                                                 moreDetails:NSLocalizedString(@"ABOUT_LUIZ_DETAILS_B", nil)
                                                         url:NSLocalizedString(@"ABOUT_LUIZ_URL", nil)],
              [[AWRAppDeveloperViewState alloc] initWithName:NSLocalizedString(@"ABOUT_FILIPE_NAME", nil)
                                                     details:NSLocalizedString(@"ABOUT_FILIPE_DETAILS_A", nil)
                                                 moreDetails:NSLocalizedString(@"ABOUT_FILIPE_DETAILS_B", nil)
                                                         url:NSLocalizedString(@"ABOUT_FILIPE_URL", nil)],
              [[AWRAppDeveloperViewState alloc] initWithName:NSLocalizedString(@"ABOUT_JAIR_NAME", nil)
                                                     details:NSLocalizedString(@"ABOUT_JAIR_DETAILS_A", nil)
                                                 moreDetails:NSLocalizedString(@"ABOUT_JAIR_DETAILS_B", nil)
                                                         url:NSLocalizedString(@"ABOUT_JAIR_URL", nil)],
              [[AWRAppDeveloperViewState alloc] initWithName:NSLocalizedString(@"ABOUT_MARI_NAME", nil)
                                                     details:NSLocalizedString(@"ABOUT_MARI_DETAILS_A", nil)
                                                 moreDetails:NSLocalizedString(@"ABOUT_MARI_DETAILS_B", nil)
                                                         url:NSLocalizedString(@"ABOUT_MARI_URL", nil)]
             ];
}

@end
