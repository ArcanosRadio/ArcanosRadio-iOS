#import "AWRShareViewController.h"
#import "AWRAnalytics.h"
#import "AWRMetadataFactory.h"

@implementation AWRShareViewController

- (nonnull instancetype)initWithCurrentSong:(nonnull id<AWRSong>)currentSong parentView:(nonnull UIView *)parentView {
    NSMutableArray *sharingItems = [NSMutableArray new];

    NSString *songName   = currentSong.songName ?: @"";
    NSString *artistName = currentSong.artist.artistName ?: @"";
    NSString *shareUrl   = [[AWRMetadataFactory createMetadataStore] readConfig:REMOTE_CONFIG_SHARE_URL_KEY];

    NSString *text = [[[NSLocalizedString(@"SHARE_TEXT", nil) stringByReplacingOccurrencesOfString:@"${song}" withString:songName]
        stringByReplacingOccurrencesOfString:@"${artist}"
                                  withString:artistName] stringByReplacingOccurrencesOfString:@"${shareUrl}"
                                                                                   withString:shareUrl];

    [sharingItems addObject:text];

    self = [super initWithActivityItems:sharingItems applicationActivities:nil];

    [self
        setCompletionWithItemsHandler:^(
            UIActivityType __nullable activityType, BOOL completed, NSArray *__nullable returnedItems, NSError *__nullable activityError) {
            if (activityError || !completed || activityType == nil) {
                return;
            }

            [[AWRAnalytics sharedAnalytics] trackShareSong:songName artist:artistName on:activityType];
        }];

    self.popoverPresentationController.sourceView = parentView;
    self.popoverPresentationController.sourceRect = parentView.bounds;

    return self;
}

@end
