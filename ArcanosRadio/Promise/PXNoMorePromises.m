#import "PXNoMorePromises.h"

@implementation PXNoMorePromises

- (id<PXPromise> (^) (id<PXPromise> (^)(id<PXSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<PXPromise>(id<PXPromise> (^block)(id<PXSuccessfulPromise>)) {
        return weakSelf;
    };
}

- (id<PXPromise> (^) (id<PXPromise> (^)(id<PXBrokenPromise>)))catch {
    __weak typeof(self) weakSelf = self;
    return ^id<PXPromise>(id<PXPromise> (^block)(id<PXBrokenPromise>)) {
        return weakSelf;
    };
}

@end
