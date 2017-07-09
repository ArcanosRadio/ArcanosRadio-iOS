#import "AWRLicenseView.h"

@interface AWRLicenseView()<UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextView *licenseTextView;

@end

@implementation AWRLicenseView

- (void)renderModel:(AWRLicenseViewState *)model {
    [self.navigationBar.items firstObject].title = model.name;
    self.licenseTextView.text = model.text;
}

- (void)setNavigationBar:(UINavigationBar *)navigationBar {
    _navigationBar = navigationBar;
    _navigationBar.delegate = self;

    UINavigationItem *titleItem = [_navigationBar.items firstObject];
    titleItem.title = self.license.name;
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
