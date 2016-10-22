#import "AWRAboutView.h"

@interface AWRAboutView()<UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation AWRAboutView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
}

- (void)setNavigationBar:(UINavigationBar *)navigationBar {
    _navigationBar = navigationBar;
    _navigationBar.delegate = self;

    UINavigationItem *titleItem = [_navigationBar.items firstObject];
    titleItem.title = NSLocalizedString(@"ABOUT_TITLE_TEXT", nil);
    UIBarButtonItem *backButton = [titleItem.leftBarButtonItems firstObject];
    backButton.title = NSLocalizedString(@"BACK_BUTTON_TEXT", nil);
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    CGRect frame = self.navigationBar.frame;
    frame.origin = CGPointMake(0, [UIApplication sharedApplication].statusBarFrame.size.height);
    self.navigationBar.frame = frame;

    return UIBarPositionTopAttached;
}

- (IBAction)backButtonPressed:(id)sender {
    if (!self.delegate) return;

    [self.delegate backButtonPressed];
}

@end
