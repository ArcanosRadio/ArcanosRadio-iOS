#import <Foundation/Foundation.h>

@protocol IOZSuccessfulPromise;
@protocol IOZBrokenPromise;

@protocol IOZPromise <NSObject>

- (id<IOZPromise> (^)(id<IOZPromise> (^)(id<IOZSuccessfulPromise>)))then;
- (id<IOZPromise> (^)(id<IOZPromise> (^)(id<IOZBrokenPromise>))) catch;

@end

@protocol IOZSuccessfulPromise <IOZPromise>

- (id)result;

@end

@protocol IOZBrokenPromise <IOZPromise>

- (NSError *)error;

@end
