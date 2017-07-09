#import <Foundation/Foundation.h>

@interface AWRAppDeveloperViewState : NSObject

+ (NSArray<AWRAppDeveloperViewState *> *)all;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *moreDetails;
@property (nonatomic, strong) NSURL *url;

@end
