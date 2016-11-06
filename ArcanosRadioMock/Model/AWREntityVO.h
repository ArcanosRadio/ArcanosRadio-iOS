#import <Foundation/Foundation.h>
#import "AWREntity.h"

@interface AWREntityVO : NSObject<AWREntity>

@property (nullable, nonatomic, strong) NSString *objectId;
@property (nullable, nonatomic, strong) NSDate *updatedAt;
@property (nullable, nonatomic, strong) NSDate *createdAt;

@end
