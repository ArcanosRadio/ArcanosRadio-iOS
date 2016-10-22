#import "NSObject+PXPromise.h"

@implementation NSObject (Promise)

- (id<PXPromise> (^) (id<PXPromise> (^)(id<PXSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<PXPromise>(id<PXPromise> (^block)(id<PXSuccessfulPromise>)) {
        return block((id<PXSuccessfulPromise>)weakSelf);
    };
}

- (id<PXPromise> (^) (id<PXPromise> (^)(id<PXBrokenPromise>)))catch {
    __weak typeof(self) weakSelf = self;
    return ^id<PXPromise>(id<PXPromise> (^block)(id<PXBrokenPromise>)) {
        return weakSelf;
    };
}

- (id)result {
    return self;
}

@end
