#import <Foundation/Foundation.h>

@protocol AWRFile <NSObject>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *url;

@end
