#import "NSArray+Functional.h"

@implementation NSArray (Functional)

- (instancetype (^)(void (^)(id)))each {
    __weak typeof(self) weakSelf = self;
    return ^id(void (^block)(id)) {
        for (id item in weakSelf) {
            block(item);
        }
        return weakSelf;
    };
}

@end
