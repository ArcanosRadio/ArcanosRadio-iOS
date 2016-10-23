#import <Foundation/Foundation.h>

@interface AWRAppDeveloperViewModel : NSObject

+ (NSArray<AWRAppDeveloperViewModel *> *)all;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *moreDetails;
@property (nonatomic, strong) NSURL *url;

@end
