#import <XCTest/XCTest.h>
#import "ScreenshotAutomation-Bridging-Header.h"
#import "ScreenshotAutomation-Swift.h"

@interface ScreenshotAutomation : XCTestCase

@end

@implementation ScreenshotAutomation

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)testFastlaneScreenshot {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    NSDictionary *testEnvironment = @{@"mock": @(YES)};
    app.launchEnvironment = testEnvironment;

    [app launch];
    [Snapshot setupSnapshot:app];

    XCUIElementQuery *scrollviewChildren = [[XCUIApplication alloc] init].scrollViews.otherElements;
    XCUIElement *headerContainer = app.otherElements[@"header_container"];
    XCUIElement *artistLabel = app.otherElements[@"artist_label"];
    XCUIElement *menuButtonButton = app.buttons[@"menu_button"];

    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:exists
              evaluatedWithObject:scrollviewChildren.otherElements[@"Steppenwolf"]
                          handler:nil];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [Snapshot snapshot:@"01_Initial" waitForLoadingIndicator:YES];

    [self expectationForPredicate:exists
              evaluatedWithObject:scrollviewChildren.otherElements[@"Black Sabbath"]
                          handler:nil];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [artistLabel pressForDuration:0 thenDragToElement:headerContainer];

    [Snapshot snapshot:@"02_SmallHeader" waitForLoadingIndicator:YES];

    [artistLabel pressForDuration:0 thenDragToElement:headerContainer];

    [Snapshot snapshot:@"03_FullLyrics" waitForLoadingIndicator:YES];

    [menuButtonButton tap];

    [Snapshot snapshot:@"04_Menu" waitForLoadingIndicator:YES];
}

- (void)tearDown {
    [super tearDown];
}

@end
