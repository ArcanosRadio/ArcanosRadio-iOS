#import "AWRAppDeveloperViewModel.h"

@interface AWRAppDeveloperViewModel()

- (instancetype) initWithName:(NSString *)name details:(NSString *)details moreDetails:(NSString *)moreDetails url:(NSString *)url;

@end

@implementation AWRAppDeveloperViewModel

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

+ (NSArray<AWRAppDeveloperViewModel *> *)all {
    return @[ [[AWRAppDeveloperViewModel alloc] initWithName:@"Luiz Rodrigo Martins Barbosa"
                                                     details:@"Desenvolvimento iOS, server API e website"
                                                 moreDetails:@"https://github.com/luizmb"
                                                         url:@"https://github.com/luizmb"],
              [[AWRAppDeveloperViewModel alloc] initWithName:@"Filipe Belatti"
                                                     details:@"Desenvolvimento Android e concepção de UX"
                                                 moreDetails:@"https://github.com/fibelatti"
                                                         url:@"https://github.com/fibelatti"],
              [[AWRAppDeveloperViewModel alloc] initWithName:@"Jair Gonçalves Barbosa"
                                                     details:@"Membro do Arcanos Motoclube de São Paulo"
                                                 moreDetails:@"Criador, produtor e programador da Arcanos Web Radio"
                                                         url:@"http://www.arcanosmc.com.br"]
             ];
}

@end
