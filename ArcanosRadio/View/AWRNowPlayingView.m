// ScrollView behavior was adapted from Yari D'areglia's (@bitwaker) article:
// http://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
// Visit his github for more information:
// https://github.com/ariok/TB_TwitterUI

#import "AWRNowPlayingView.h"
#import "AWRNowPlayingHeaderView.h"
#import "AWRNowPlayingBodyView.h"
#import "UIView+Utils.h"
#import "AWRMenuView.h"

@interface AWRNowPlayingView()<UIScrollViewDelegate, AWRMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (strong, nonatomic) AWRNowPlayingHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bodyContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyHeight;
@property (strong, nonatomic) AWRNowPlayingBodyView *bodyView;

@property (weak, nonatomic) IBOutlet UIView *mediaControlBar;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *togglePlayButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacerBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) AWRMenuView *menu;

@end

@implementation AWRNowPlayingView

- (AWRMenuView *)menu {
    if (!_menu) {
        NSArray<AWRMenuViewItem *> *items = @[[AWRMenuViewItem itemWithIdentifier:@"about"
                                                                             icon: [UIImage imageNamed:@"help"]
                                                                             text: NSLocalizedString(@"MENU_ABOUT", nil)],
                                              [AWRMenuViewItem itemWithIdentifier:@"settings"
                                                                             icon: [UIImage imageNamed:@"settings"]
                                                                             text: NSLocalizedString(@"MENU_SETTINGS", nil)],
                                              [AWRMenuViewItem itemWithIdentifier:@"share"
                                                                             icon: [UIImage imageNamed:@"share"]
                                                                             text: NSLocalizedString(@"MENU_SHARE", nil)]];
        _menu = [[AWRMenuView alloc] initWithFrame:self.frame];
        _menu.delegate = self;
        _menu.items = items;
    }
    return _menu;
}

- (AWRNowPlayingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AWRNowPlayingHeaderView" owner:self options:nil] firstObject];
        [self.headerContainer addSubview:_headerView];
        [_headerView fillSuperview];
        self.headerHeight.constant = _headerView.maximumHeight;
    }
    return _headerView;
}

- (AWRNowPlayingBodyView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[[NSBundle mainBundle] loadNibNamed:@"AWRNowPlayingBodyView" owner:self options:nil] firstObject];
        [self.bodyContainer addSubview:_bodyView];
        [_bodyView anchorToTheTop];
        [self.bodyView sizeToFit];
        self.bodyHeight.constant = self.bodyView.bounds.size.height;
    }
    return _bodyView;
}

- (void)setTwitterView:(UITableView *)twitterView {
    [self.bodyView setTwitterView:twitterView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateConstraints];
    self.headerContainer.layer.zPosition = 2;
    self.togglePlayButton.layer.zPosition = 3;
    [self configureMediaControlBarBackground];
}

- (void)calculateConstraints {
    self.spacerTopConstraint.constant = self.headerView.maximumHeight + self.togglePlayButton.frame.size.height / 2;
    [self calculatePaddingBottom];
}

- (void)calculatePaddingBottom {
    float mediaControlHeight = 54;
    [self.bodyView sizeToFit];
    self.bodyHeight.constant = self.bodyView.bounds.size.height;

    self.spacerBottomConstraint.constant =
    MAX(mediaControlHeight,
        self.bounds.size.height - self.bodyHeight.constant - self.headerView.minimumHeight / 2);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    self.headerHeight.constant = MAX(self.headerView.maximumHeight - offset,
                                     self.headerView.minimumHeight);


    float mainMetadataContainerPaddingTop = 6.0;

    float realSongNameTop = self.bodyContainer.frame.origin.y + mainMetadataContainerPaddingTop - offset;

    if (realSongNameTop >= self.headerHeight.constant) {
        // big song name is completely visible
        // header title should be hidden
        self.headerView.metadataOffset = mainMetadataContainerPaddingTop + self.headerView.maximumHeight / 2;
        self.headerView.metadataAlpha = 0.0;
        self.bodyView.titleAlpha = 1.0;
    } else {
        // big song name is partially or fully covered by header
        // header title should be proportionally visible
        float headerPathStart = mainMetadataContainerPaddingTop + self.headerView.minimumHeight / 2;
        float hiddenSize = self.headerHeight.constant - realSongNameTop;

        float alphaHeader = MIN(hiddenSize / 30, 1.0);
        float alphaMain = 1.0 - alphaHeader;
        self.headerView.metadataAlpha = alphaHeader;
        self.bodyView.titleAlpha = alphaMain;

        float headerPathProgress = MAX(0.0, headerPathStart - hiddenSize);
        self.headerView.metadataOffset = headerPathProgress;
    }
}

- (IBAction)playButtonPressed:(id)sender {
    if (!self.delegate) return;
    [self.delegate playButtonPressed];
}

- (IBAction)heavyMetalButtonPressed:(id)sender {
    if (!self.delegate) return;
    [self.delegate heavyMetalButtonPressed];
}

- (IBAction)muteButtonPressed:(id)sender {
    if (!self.delegate) return;
    self.volumeSlider.value = 0.0;
    [self.delegate muteButtonPressed];
}

- (IBAction)menuButtonPressed:(UIButton *)sender {
    self.menu.layer.zPosition = 4;
    [self addSubview:self.menu];
    [self.menu show];
}

- (void)menu:(AWRMenuView *)menu didSelectItemWithIdentifier:(NSString *)identifier {
    if (!self.delegate) return;

    if ([@"share" isEqualToString:identifier]) {
        [self.delegate shareButtonPressed];
        return;
    }

    if ([@"settings" isEqualToString:identifier]) {
        [self.delegate settingsButtonPressed];
        return;
    }

    if ([@"about" isEqualToString:identifier]) {
        [self.delegate aboutButtonPressed];
        return;
    }
}

- (void)menuDidBecomeHidden:(AWRMenuView *)menu {
    [self.menu removeFromSuperview];
    self.menu = nil;
}

- (void)setVolume:(float)percentage {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.volumeSlider setValue:percentage];
    });
}

- (IBAction)volumeChanged:(UISlider *)sender {
    if (!self.delegate) return;
    [self.delegate volumeChangedTo:self.volumeSlider.value];
}

- (void)renderModel:(AWRNowPlayingViewModel *)model {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spacerBottomConstraint.constant = self.bounds.size.height;
        [weakSelf.bodyView renderModel:model];
        [weakSelf.headerView renderModel:model];
        [weakSelf calculatePaddingBottom];
    });
}

- (void)setStatusPlaying {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.togglePlayButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    });
}

- (void)setStatusStopped {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.togglePlayButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    });
}

- (void)setStatusBuffering {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.togglePlayButton setImage:[UIImage imageNamed:@"hourglass"] forState:UIControlStateNormal];
    });
}

- (void)configureMediaControlBarBackground {
    id backgroundColor = (id)[self.backgroundColor CGColor];
    id backgroundColorWithTransparency = (id)[[self.backgroundColor colorWithAlphaComponent:0.10] CGColor];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.mediaControlBar.bounds;
        gradient.colors = [NSArray arrayWithObjects:backgroundColorWithTransparency,
                                                    backgroundColor,
                                                    backgroundColor,
                                                    nil];
        [self.mediaControlBar.layer insertSublayer:gradient atIndex:0];
    });
}

@end
