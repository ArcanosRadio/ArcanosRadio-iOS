#import "AWRShareViewController.h"
#import "AWRMetadataFactory.h"

@implementation AWRShareViewController

- (nonnull instancetype)initWithCurrentSong:(nonnull id<AWRSong>)currentSong parentView:(nonnull UIView *)parentView {
    NSMutableArray *sharingItems = [NSMutableArray new];

    NSString *songName   = currentSong.songName;
    NSString *artistName = currentSong.artist.artistName;
    NSString *shareUrl   = [[AWRMetadataFactory createMetadataStore] readConfig:REMOTE_CONFIG_SHARE_URL_KEY];

    NSString *text = [[[NSLocalizedString(@"SHARE_TEXT", nil) stringByReplacingOccurrencesOfString:@"${song}" withString:songName]
        stringByReplacingOccurrencesOfString:@"${artist}"
                                  withString:artistName] stringByReplacingOccurrencesOfString:@"${shareUrl}"
                                                                                   withString:shareUrl];

    [sharingItems addObject:text];

    self = [super initWithActivityItems:sharingItems applicationActivities:nil];

    self.popoverPresentationController.sourceView = parentView;
    self.popoverPresentationController.sourceRect = parentView.bounds;

    return self;
}

@end
