#import <XCTest/XCTest.h>
#import "ScreenshotAutomation-Bridging-Header.h"
#import "ScreenshotAutomation-Swift.h"

@interface ScreenshotAutomation : XCTestCase

@end

@implementation ScreenshotAutomation

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
}

- (void)testFastlaneScreenshot {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];

    XCUIElementQuery *scrollviewChildren = [[XCUIApplication alloc] init].scrollViews.otherElements;
    XCUIElement *headerContainer = app.otherElements[@"header_container"];
    XCUIElement *artistLabel = app.otherElements[@"artist_label"];
    XCUIElement *menuButtonButton = app.buttons[@"menu_button"];

    // First screenshot: Full album, Stratovarius song
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:exists
              evaluatedWithObject:scrollviewChildren.otherElements[@"Stratovarius"]
                          handler:nil];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [Snapshot snapshot:@"01_Initial" waitForLoadingIndicator:YES];


    // Second screenshot: Lyrics, Black Sabbath song
    [self expectationForPredicate:exists
              evaluatedWithObject:scrollviewChildren.otherElements[@"Black Sabbath"]
                          handler:nil];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [artistLabel pressForDuration:0 thenDragToElement:headerContainer];

    [Snapshot snapshot:@"02_SmallHeader" waitForLoadingIndicator:YES];


    // Third screenshot: Scroll to the end, Steppenwolf song
    [self expectationForPredicate:exists
              evaluatedWithObject:scrollviewChildren.otherElements[@"Steppenwolf"]
                          handler:nil];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [headerContainer swipeUp];

    [Snapshot snapshot:@"03_FullLyrics" waitForLoadingIndicator:YES];


    // Fourth screenshot: Menu, Stratovarius song
    [[scrollviewChildren elementBoundByIndex:0] swipeDown];

    [self expectationForPredicate:exists
              evaluatedWithObject:scrollviewChildren.otherElements[@"Stratovarius"]
                          handler:nil];
    [self waitForExpectationsWithTimeout:15 handler:nil];

    [menuButtonButton tap];

    [Snapshot snapshot:@"04_Menu" waitForLoadingIndicator:YES];
}

- (void)tearDown {
    [super tearDown];
}

@end
