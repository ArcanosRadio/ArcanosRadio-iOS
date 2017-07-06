#import "IOZNoMorePromises.h"

@implementation IOZNoMorePromises

- (id<IOZPromise> (^) (id<IOZPromise> (^)(id<IOZSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZSuccessfulPromise>)) {
        return weakSelf;
    };
}

- (id<IOZPromise> (^) (id<IOZPromise> (^)(id<IOZBrokenPromise>)))catch {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZBrokenPromise>)) {
        return weakSelf;
    };
}

@end
