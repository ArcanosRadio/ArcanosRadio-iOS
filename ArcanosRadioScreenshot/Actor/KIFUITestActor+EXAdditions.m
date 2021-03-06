#import "AWRMockMetadataService.h"
#import "KIFUITestActor+EXAdditions.h"
#import <ArcanosMetadataAPI/ArcanosMetadataAPI.h>

@implementation KIFUITestActor (EXAdditions)

- (void)waitForMusic {
    [tester waitForTappableViewWithAccessibilityLabel:NSLocalizedString(@"NOW_PLAYING_PAUSE", nil)];
}

- (void)setSongName:(NSString *)songName
         artistName:(NSString *)artistName
            twitter:(NSString *)twitter
            website:(NSString *)website
             lyrics:(NSString *)lyrics
                art:(UIImage *)art {
    AWRArtistParse *artist = [[AWRArtistParse alloc] init];
    artist.artistName      = artistName;
    artist.twitterTimeline = twitter;
    artist.url             = website;

    AWRSongParse *song = [[AWRSongParse alloc] init];
    song.artist        = artist;
    song.songName      = songName;

    [[AWRMockMetadataService sharedInstance] setSong:song lyrics:lyrics art:art];
}

- (void)screenshotWithIdentifier:(nonnull NSString *)identifier {
    UIView *screen = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    UIGraphicsBeginImageContextWithOptions(screen.bounds.size, NO, 0);
    [screen layoutIfNeeded];
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
    NSAssert(error == nil, @"Error exporting screenshot as PNG");
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
    NSAssert(error == nil, @"Error creating screenshot folder");
    return languagePath;
}

- (void)goToLyricsTab {
    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"TOOLBAR_LYRICS", nil)];
}

- (void)goToTwitterTab {
    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"TOOLBAR_TWITTER", nil)];
}

- (void)goToWebsiteTab {
    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"TOOLBAR_WEBSITE", nil)];
}

- (void)scrollToTop {
    [tester scrollViewWithAccessibilityIdentifier:@"Main ScrollView" byFractionOfSizeHorizontal:0.0 vertical:0.9];
    [tester scrollViewWithAccessibilityIdentifier:@"Main ScrollView" byFractionOfSizeHorizontal:0.0 vertical:0.05];
    [tester waitForAnimationsToFinish];
}

- (void)scrollToBottom {
    [tester scrollViewWithAccessibilityIdentifier:@"Main ScrollView" byFractionOfSizeHorizontal:0.0 vertical:-0.9];
    [tester scrollViewWithAccessibilityIdentifier:@"Main ScrollView" byFractionOfSizeHorizontal:0.0 vertical:-0.05];
    [tester waitForAnimationsToFinish];
}
@end
