#import "AWRAppInfoViewModel.h"

@interface AWRAppInfoViewModel()

- (instancetype) initWithName:(NSString *)name details:(NSString *)details url:(NSString *)url;

@end

@implementation AWRAppInfoViewModel

- (instancetype)initWithName:(NSString *)name details:(NSString *)details url:(NSString *)url {
    self = [super init];
    if (self) {
        self.name = name;
        self.details = details;
        self.url = [NSURL URLWithString:url];
    }
    return self;
}

+ (NSArray<AWRAppInfoViewModel *> *)all {
    return @[ [[AWRAppInfoViewModel alloc] initWithName:@"Código-fonte iOS"
                                                 details:@"https://github.com/luizmb/ArcanosRadio-iOS"
                                                     url:@"https://github.com/luizmb/ArcanosRadio-iOS"],
              [[AWRAppInfoViewModel alloc] initWithName:@"Código-fonte da Server API"
                                                 details:@"https://github.com/luizmb/ArcanosRadio-Backend"
                                                     url:@"https://github.com/luizmb/ArcanosRadio-Backend"],
              [[AWRAppInfoViewModel alloc] initWithName:@"Arcanos Web Radio"
                                                 details:@"http://www.arcanosmc.com.br"
                                                     url:@"http://www.arcanosmc.com.br"]
              ];
}

@end
