#import <UIKit/UIKit.h>
#import "AWRViewController.h"
#import "AWRSong.h"
#import "AWRMetadataServiceDelegate.h"
@class AWRNowPlayingViewState;

@protocol AWRNowPlayingControllerDelegate

- (void)userDidSelectShare;
- (void)userDidSelectAbout;
- (void)userDidSelectSettings;

@end

@interface AWRNowPlayingController : AWRViewController<AWRMetadataServiceDelegate>

@property (weak, nonatomic) id<AWRNowPlayingControllerDelegate>delegate;

@end
