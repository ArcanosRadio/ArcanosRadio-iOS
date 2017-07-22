#import "AWRScreenshotAutomation.h"
#import <SimulatorStatusMagiciOS/SimulatorStatusMagiciOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRScreenshotAutomation ()

@end

@implementation AWRScreenshotAutomation

- (void)beforeAll {
    [[SDStatusBarManager sharedInstance] enableOverrides];
    [UIView setAnimationsEnabled:NO];
    [KIFTestActor setDefaultAnimationWaitingTimeout:0.05f];
    [KIFTestActor setDefaultTimeout:10.0f];
}

- (void)testScreenshotAutomation {
    [tester waitForMusic];
    [tester screenshotWithIdentifier:@"main_screen"];
}

@end

NS_ASSUME_NONNULL_END
