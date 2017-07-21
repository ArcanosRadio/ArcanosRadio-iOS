#import "IOZPromiseResult.h"

@interface IOZPromiseResult ()

@property (nonatomic, strong) id result;

@end

@implementation IOZPromiseResult

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.result = value;
    }
    return self;
}

- (id<IOZPromise> (^)(id<IOZPromise> (^)(id<IOZSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZSuccessfulPromise>)) {
        return block((id<IOZSuccessfulPromise>)weakSelf);
    };
}

- (id<IOZPromise> (^)(id<IOZPromise> (^)(id<IOZBrokenPromise>))) catch {
    __weak typeof(self) weakSelf = self;
    return ^id<IOZPromise>(id<IOZPromise> (^block)(id<IOZBrokenPromise>)) {
        return weakSelf;
    };
}

@end
