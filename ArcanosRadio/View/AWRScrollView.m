#import "AWRScrollView.h"

@implementation AWRScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.panGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.scrollViewDelegate) {
        CGPoint point = [touch locationInView:self.window];
        return [self.scrollViewDelegate scrollView:self isAllowedToHandleTouchAt:point];
    }

    return YES;
}

@end
