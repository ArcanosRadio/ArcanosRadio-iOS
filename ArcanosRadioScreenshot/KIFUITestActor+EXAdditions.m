#import "KIFUITestActor+EXAdditions.h"

@implementation KIFUITestActor (EXAdditions)

- (void)waitForMusic {
    [tester waitForTappableViewWithAccessibilityLabel:NSLocalizedString(@"NOW_PLAYING_PAUSE", nil)];
}

@end
