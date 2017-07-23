#import "AWRScreenshotAutomation.h"
#import <SimulatorStatusMagiciOS/SimulatorStatusMagiciOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRScreenshotAutomation ()

@end

@implementation AWRScreenshotAutomation

- (void)beforeAll {
    [[SDStatusBarManager sharedInstance] enableOverrides];
    [KIFTestActor setDefaultAnimationWaitingTimeout:5.0f];
    [KIFTestActor setDefaultTimeout:10.0f];
}

- (void)testScreenshotAutomation {
    [self wolfenbachMetadata];
    [tester waitForMusic];
    [tester screenshotWithIdentifier:@"01_lyrics_wolfenbach"];
    [tester scrollToBottom];
    [tester screenshotWithIdentifier:@"02_full_lyrics_wolfenbach"];
    [self steveVaiMetadata];
    [tester scrollToTop];
    [tester screenshotWithIdentifier:@"03_lyrics_steve_vai"];
    [self angraMetadata];
    [tester scrollToBottom];
    [tester goToTwitterTab];
    [tester screenshotWithIdentifier:@"04_twitter_angra"];
    [self deepPurpleMetadata];
    [tester goToWebsiteTab];
    [tester screenshotWithIdentifier:@"05_website_deep_purple"];
}

- (void)wolfenbachMetadata {
    [tester setSongName:@"Forbidden Light"
             artistName:@"Wolfenbach"
                twitter:@"@_wolfenbach"
                website:@"https://www.wolfenbach.com"
                 lyrics:@"For all that I've seen in this world of madness.\n"
                         "Sorrow fills my heart.\n"
                         "Dead petals in their youth.\n"
                         "But I stand it, just to see what I left behind.\n\n"

                         "As they pass like shadows. Cruel reality freezes my heart.\n"
                         "I stare into my doomed soul. And I fall on my knees.\n\n"

                         "There's dark in my mind, fake illusion is my crime.\n"
                         "Now I have to pay this price, in a search for my peace.\n"
                         "I succumb to my demons, I feel weak before my dreams.\n"
                         "Forbidden light.\n\n"

                         "There's nowhere to run.\n"
                         "There's nowhere to hide.\n"
                         "Darkness is everywhere.\n"
                         "But I'll face it, we shall bring the dawn again.\n\n"

                         "As they pass like shadows. Cruel reality freezes my heart.\n"
                         "I stare into my doomed soul. And I fall on my knees.\n\n"

                         "There's dark in my mind, fake illusion is my crime.\n"
                         "Now I have to pay this price, in a search for my peace.\n"
                         "I succumb to my demons, I feel weak before my dreams.\n"
                         "Forbidden light.\n\n"
                    art:[self imageWithName:@"Wolfenbach" ofType:@"png"]];
    [tester waitForViewWithAccessibilityLabel:@"Wolfenbach"];
}

- (void)steveVaiMetadata {
    [tester setSongName:@"For The Love Of God"
             artistName:@"Steve Vai"
                twitter:@"@stevevai"
                website:@""
                 lyrics:@"Instrumental"
                    art:[self imageWithName:@"SteveVai" ofType:@"jpg"]];
    [tester waitForViewWithAccessibilityLabel:@"Steve Vai"];
}

- (void)angraMetadata {
    [tester setSongName:@"Holy Land"
             artistName:@"Angra"
                twitter:@"@angraofficial"
                website:@"https://www.angra.net"
                 lyrics:@"No rights for these lyrics"
                    art:[self imageWithName:@"Angra" ofType:@"jpg"]];
    [tester waitForViewWithAccessibilityLabel:@"Angra"];
}

- (void)deepPurpleMetadata {
    [tester setSongName:@"Burn"
             artistName:@"Deep Purple"
                twitter:@"@_DeepPurple"
                website:@"http://www.deeppurple.com/"
                 lyrics:@"No rights for these lyrics"
                    art:[self imageWithName:@"DeepPurple" ofType:@"jpg"]];
    [tester waitForViewWithAccessibilityLabel:@"Deep Purple"];
}

- (UIImage *)imageWithName:(NSString *)name ofType:(NSString *)type {
    NSBundle *bundle   = [NSBundle bundleForClass:[AWRScreenshotAutomation class]];
    NSString *fileName = [bundle pathForResource:name ofType:type];

    return [UIImage imageWithContentsOfFile:fileName];
}

@end

NS_ASSUME_NONNULL_END
