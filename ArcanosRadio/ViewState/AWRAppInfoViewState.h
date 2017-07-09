#import <Foundation/Foundation.h>

@interface AWRAppInfoViewState : NSObject

+ (NSArray<AWRAppInfoViewState *> *)all;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSURL *url;

@end
