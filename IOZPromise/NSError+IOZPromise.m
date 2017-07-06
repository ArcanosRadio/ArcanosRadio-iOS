#import "NSError+IOZPromise.h"

@implementation NSError (Promise)

- (id<IOZPromise> (^) (id<IOZPromise> (^)(id<IOZSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZSuccessfulPromise>)) {
        return weakSelf;
    };
}

- (id<IOZPromise> (^) (id<IOZPromise> (^)(id<IOZBrokenPromise>)))catch {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZBrokenPromise>)) {
        return block((id<IOZBrokenPromise>)weakSelf);
    };
}

- (NSError *)error {
    return self;
}

@end
