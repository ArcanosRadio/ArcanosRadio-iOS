#import "NSObject+IOZPromise.h"

@implementation NSObject (Promise)

- (id<IOZPromise> (^) (id<IOZPromise> (^)(id<IOZSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZSuccessfulPromise>)) {
        return block((id<IOZSuccessfulPromise>)weakSelf);
    };
}

- (id<IOZPromise> (^) (id<IOZPromise> (^)(id<IOZBrokenPromise>)))catch {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZBrokenPromise>)) {
        return weakSelf;
    };
}

- (id)result {
    return self;
}

@end
