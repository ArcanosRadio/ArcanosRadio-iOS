#import <Foundation/Foundation.h>

@protocol AWREntity <NSObject>

@property (nullable, nonatomic, strong) NSString *objectId;
@property (nullable, nonatomic, strong, readonly) NSDate *updatedAt;
@property (nullable, nonatomic, strong, readonly) NSDate *createdAt;

@end
