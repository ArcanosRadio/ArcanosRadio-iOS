#import "AWRLicenseController.h"
#import "AWRLicenseView.h"

@interface AWRLicenseController () <AWRLicenseViewDelegate>

@property (readonly, nonatomic) AWRLicenseView *licenseView;

@end

@implementation AWRLicenseController

- (AWRLicenseView *)licenseView {
    return (AWRLicenseView *)self.view;
}

- (instancetype)init {
    self = [super initWithNibName:@"AWRLicenseView" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.licenseView.delegate = self;
    [self.licenseView renderModel:self.licenseModel];
}

- (void)backButtonPressed {
    if (!self.delegate) return;

    [self.delegate userDidCloseLicense];
}

@end
