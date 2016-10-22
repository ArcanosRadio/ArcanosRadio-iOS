#import "BFTask+PXPromise.h"

@implementation BFTask (PXPromise)

- (id<PXPromise> (^) (id<PXPromise> (^)(id<PXSuccessfulPromise>)))then {
    __weak typeof(self) weakSelf = self;
    return ^id<PXPromise>(id<PXPromise> (^block)(id<PXSuccessfulPromise>)) {
        if (self.error) {
            // Current task is already in "error" state
            // That means we should ignore this "then" block
            // until something catches the error.
            return weakSelf;
        }

        // Execute BFTask pending tasks
        return [weakSelf continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {

            // All pending tasks were executed, let's check the status

            if (t.error) {
                // Last task found an error, so let's skip this block
                // as it is waiting for success and we got error.
                // Instead, return the task itself
                return t;
            }

            // Good, task was successful, let's call user's block
            return block((id<PXSuccessfulPromise>)t);
        }];
    };
}

- (id<PXPromise> (^) (id<PXPromise> (^)(id<PXBrokenPromise>)))catch {
    __weak typeof(self) weakSelf = self;
    return ^id<PXPromise>(id<PXPromise> (^block)(id<PXBrokenPromise>)) {
        // Execute BFTask and set the callback for the result
        return [weakSelf continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
            if (weakSelf.error) {
                return block((id<PXBrokenPromise>)t);
            } else {
                return weakSelf;
            }
        }];
    };
}

@end
