#import <Foundation/Foundation.h>
#import "AWRFile.h"

@interface AWRFileVO : NSObject<AWRFile>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end
