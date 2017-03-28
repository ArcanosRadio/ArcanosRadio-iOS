// ScrollView behavior was adapted from Yari D'areglia's (@bitwaker) article:
// http://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
// Visit his github for more information:
// https://github.com/ariok/TB_TwitterUI

#import <UIKit/UIKit.h>
#import "AWRNowPlayingViewModel.h"
#import <MediaPlayer/MPVolumeView.h>

typedef NS_ENUM(NSInteger, AWRNowPlayingViewTab) {
    AWRNowPlayingViewTabLyrics,
    AWRNowPlayingViewTabTwitter,
    AWRNowPlayingViewTabWebsite
};

@protocol AWRNowPlayingViewDelegate

- (void)playButtonPressed;
- (void)heavyMetalButtonPressed;
- (void)muteButtonPressed;
- (void)volumeChangedTo:(float)percentage;
- (void)shareButtonPressed;
- (void)aboutButtonPressed;
- (void)settingsButtonPressed;
- (void)currentTabHasChanged:(AWRNowPlayingViewTab)newtab;

@end

@interface AWRNowPlayingView : UIView

@property (nonatomic)AWRNowPlayingViewTab currentTab;
@property (nonatomic, weak)id<AWRNowPlayingViewDelegate> delegate;
- (void)setTwitterView:(UIScrollView *)twitterView;
- (void)renderModel:(AWRNowPlayingViewModel *)model;
- (void)setVolume:(float)percentage;
- (void)setStatusPlaying;
- (void)setStatusStopped;
- (void)setStatusBuffering;

@end
