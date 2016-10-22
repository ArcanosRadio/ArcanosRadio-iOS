#import "LQRequestId.h"

@implementation LQRequestId

- (instancetype)initWithValue:(NSInteger)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[LQRequestId class]]) {
        return NO;
    }
    return self.value == ((LQRequestId *)object).value;
}

@end
