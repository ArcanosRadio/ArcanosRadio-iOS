#import "KIFUITestActor+EXAdditions.h"
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <KIF/KIF.h>
#import <SimulatorStatusMagiciOS/SimulatorStatusMagiciOS.h>
#import <XCTest/XCTest.h>

@interface ArcanosRadioScreenshot : KIFTestCase

@end

@implementation ArcanosRadioScreenshot

- (void)beforeAll {
    [[SDStatusBarManager sharedInstance] enableOverrides];
    [UIView setAnimationsEnabled:NO];
    [KIFTestActor setDefaultAnimationWaitingTimeout:0.05f];
    [KIFTestActor setDefaultTimeout:10.0f];
}

- (void)testScreenshot {
    [tester waitForMusic];
    [self screenshot:@"main_screen"];
}

- (void)screenshot:(nonnull NSString *)identifier {
    UIView *screen = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    UIGraphicsBeginImageContext(screen.bounds.size);
    [screen drawViewHierarchyInRect:screen.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self saveScreenshot:screenshot forIdentifier:identifier];
}

- (void)saveScreenshot:(nonnull UIImage *)screenshot forIdentifier:(nonnull NSString *)identifier {
    NSData *pngData = UIImagePNGRepresentation(screenshot);

    NSString *filePath = [[self screenshotFolder] stringByAppendingPathComponent:[self screenshotFileNameForIdentifier:identifier]];
    NSError *error;
    [pngData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    XCTAssertNil(error);
}

- (nonnull NSString *)screenshotFileNameForIdentifier:(nonnull NSString *)identifier {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@_%.0fx%.0f_%.0fx_%@.png",
                                      device.model,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [UIScreen mainScreen].bounds.size.height,
                                      [UIScreen mainScreen].scale,
                                      identifier];
}

- (nonnull NSString *)screenshotFolder {
    NSString *screenshotsPath = NSTemporaryDirectory();
    if (getenv("KIF_SCREENSHOT")) {
        screenshotsPath = @(getenv("KIF_SCREENSHOT"));
    }
    NSString *currentLocale = [NSLocale currentLocale].localeIdentifier;
    NSString *languagePath  = [screenshotsPath stringByAppendingPathComponent:currentLocale];

    NSError *error;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:languagePath]) {
        [fileManager createDirectoryAtPath:languagePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    XCTAssertNil(error);
    return languagePath;
}

@end
