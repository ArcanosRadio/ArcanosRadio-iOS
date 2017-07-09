#import <IOZPromise/IOZPromise.h>
#import "AWRNowPlayingController.h"
#import "AWRArcanosMediaPlayer.h"
#import "AWRNowPlayingView.h"
#import "AWRNowPlayingViewState.h"
#import "AWRMetadataFactory.h"
#import "AWRTwitterViewController.h"

@interface AWRNowPlayingController () <AWRArcanosMediaPlayerDelegate, AWRNowPlayingViewDelegate, AWRTwitterViewControllerDelegate>

@property(strong, nonatomic) AWRArcanosMediaPlayer *arcanosRadio;
@property(strong, nonatomic) NSString *streamingUrl;
@property(readonly, nonatomic) AWRNowPlayingView *nowPlayingView;
@property(atomic, nullable, strong) AWRNowPlayingViewState *ViewState;
@property(strong, nonatomic) AWRTwitterViewController *twitterViewController;
@end

@implementation AWRNowPlayingController

- (AWRNowPlayingView *)nowPlayingView {
    return (AWRNowPlayingView *)self.view;
}

- (instancetype)init {
    self = [super initWithNibName:@"AWRNowPlayingView" bundle:nil];
    if (self) {
        self.ViewState = [[AWRNowPlayingViewState alloc] init];
        self.streamingUrl = [[AWRMetadataFactory createMetadataStore] readConfig:REMOTE_CONFIG_STREAMING_URL_KEY];
    }
    return self;
}

- (void)twitterDidRefresh {
}

- (AWRTwitterViewController *)twitterViewController {
    if (!_twitterViewController) {
        _twitterViewController = [AWRTwitterViewController new];
        _twitterViewController.delegate = self;
    }
    return _twitterViewController;
}

- (void)setStreamingUrl:(NSString *)streamingUrl {
    _streamingUrl = streamingUrl;
    if (_streamingUrl) {
        _arcanosRadio = [[AWRArcanosMediaPlayer alloc] initWithUrl:_streamingUrl];
        _arcanosRadio.delegate = self;
        [_arcanosRadio prepare];
        [_arcanosRadio play];
    }
}

- (void)metadataDidChangeTheSong:(id<AWRSong>)song {
    self.ViewState.songName = song.songName;
    self.ViewState.artistName = song.artist.artistName;
    self.ViewState.url = song.artist.url;
    self.ViewState.hasUrl = song.artist.url.length > 0;

    if (song.artist.twitterTimeline && [song.artist.twitterTimeline characterAtIndex:0] == '#' ) {
        // Hashtag search
        [self.twitterViewController setTwitterSearch:song.artist.twitterTimeline];
    } else if (song.artist.twitterTimeline) {
        // User timeline
        [self.twitterViewController setTwitterTimeline:song.artist.twitterTimeline];
    } else {
        // General search
        [self.twitterViewController setTwitterSearch:song.artist.artistName];
    }

    UIImage *defaultImage = [[AWRMetadataFactory metadataStoreClass] defaultAlbumArt];
    self.ViewState.albumArt = defaultImage;
    self.ViewState.lyrics = @"";
    [self.nowPlayingView renderModel:self.ViewState];
}

- (void)metadataDidFinishDownloadingAlbumArt:(UIImage *)albumArt forSong:(id<AWRSong>)song {
    self.ViewState.albumArt = albumArt;
    [self.nowPlayingView renderModel:self.ViewState];
}

- (void)metadataDidFinishDownloadingLyrics:(NSString *)lyrics forSong:(id<AWRSong>)song {
    self.ViewState.lyrics = lyrics;
    [self.nowPlayingView renderModel:self.ViewState];
}

- (void)didStartPlaying {
    [self.nowPlayingView setStatusPlaying];
}

- (void)didStopPlaying {
    [self.nowPlayingView setStatusStopped];
}

- (void)didStartBuffering {
    [self.nowPlayingView setStatusBuffering];
}

- (void)beginReceivingRemoteControlEvents {
    [self becomeFirstResponder];
}

- (void)playButtonPressed {
    [self.arcanosRadio togglePlayPause];
}

- (void)muteButtonPressed {
    [self.arcanosRadio toggleMute];
    if (self.arcanosRadio.isMuted) {
        [self.nowPlayingView setVolume:0.0];
    } else {
        [self.nowPlayingView setVolume:self.arcanosRadio.currentVolume];
    }
}

- (void)shareButtonPressed {
    if (self.delegate) {
        [self.delegate userDidSelectShare];
    }
}

- (void)aboutButtonPressed {
    if (self.delegate) {
        [self.delegate userDidSelectAbout];
    }
}

- (void)currentTabHasChanged:(AWRNowPlayingViewTab)newtab {
    if (newtab == AWRNowPlayingViewTabWebsite) {
        NSString *urlString = self.ViewState.url;
        if (!urlString) {
            [self.nowPlayingView setCurrentTab:AWRNowPlayingViewTabLyrics];
            return;
        }

        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];

        [self.nowPlayingView navigate:requestObj];
    }
}

- (void)settingsButtonPressed {
    if (self.delegate) {
        [self.delegate userDidSelectSettings];
    }
}

- (void)volumeChangedTo:(float)percentage {
    [self.arcanosRadio setVolumeTo:percentage];
}

- (void)heavyMetalButtonPressed {
    float newVolume = MIN(self.arcanosRadio.currentVolume * 1.1, 1.0);
    [self.arcanosRadio setVolumeTo:newVolume];
    [self.nowPlayingView setVolume:newVolume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nowPlayingView.delegate = self;
    [self.nowPlayingView renderModel:self.ViewState];
    [self.nowPlayingView setVolume:1.0];
    [self addChildViewController:self.twitterViewController];
    [self.nowPlayingView setTwitterView:(UIScrollView *)self.twitterViewController.view];
}

- (void)viewDidUnload {
    [self.arcanosRadio stop];
    [super viewDidUnload];
}

@end
