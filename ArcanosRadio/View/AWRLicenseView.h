#import <UIKit/UIKit.h>
#import "AWRLicenseViewModel.h"

@protocol AWRLicenseViewDelegate

- (void)backButtonPressed;

@end

@interface AWRLicenseView : UIView

@property (strong, nonatomic) AWRLicenseViewModel *license;
@property (nonatomic, weak)id<AWRLicenseViewDelegate> delegate;

- (void)renderModel:(AWRLicenseViewModel *)model;

@end
