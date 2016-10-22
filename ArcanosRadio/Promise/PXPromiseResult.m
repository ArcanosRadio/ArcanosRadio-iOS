#import "PXPromiseResult.h"

@interface PXPromiseResult()

@property(nonatomic, strong)id result;

@end

@implementation PXPromiseResult

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.result = value;
    }
    return self;
}

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

@end
