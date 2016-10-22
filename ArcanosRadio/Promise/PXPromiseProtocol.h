#import <Foundation/Foundation.h>

@protocol PXSuccessfulPromise;
@protocol PXBrokenPromise;

@protocol PXPromise<NSObject>

- (id<PXPromise> (^)(id<PXPromise> (^)(id<PXSuccessfulPromise>)))then;
- (id<PXPromise> (^)(id<PXPromise> (^)(id<PXBrokenPromise>)))catch;

@end

@protocol PXSuccessfulPromise <PXPromise>

- (id)result;

@end

@protocol PXBrokenPromise <PXPromise>

- (NSError *)error;

@end
