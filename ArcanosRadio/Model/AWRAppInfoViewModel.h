#import <Foundation/Foundation.h>

@interface AWRAppInfoViewModel : NSObject

+ (NSArray<AWRAppInfoViewModel *> *)all;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSURL *url;

@end
