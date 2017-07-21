#import "AWRLicenseViewState.h"
#import <UIKit/UIKit.h>

@protocol AWRLicenseViewDelegate

- (void)backButtonPressed;

@end

@interface AWRLicenseView : UIView

@property (strong, nonatomic) AWRLicenseViewState *license;
@property (nonatomic, weak) id<AWRLicenseViewDelegate> delegate;

- (void)renderModel:(AWRLicenseViewState *)model;

@end
