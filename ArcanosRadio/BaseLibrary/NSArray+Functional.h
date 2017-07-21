#import <Foundation/Foundation.h>

@interface NSArray (Functional)

- (instancetype (^)(void (^)(id)))each;

@end
