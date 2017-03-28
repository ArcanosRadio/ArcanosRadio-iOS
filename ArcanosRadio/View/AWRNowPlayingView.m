#import "AWRNowPlayingView.h"
#import "AWRNowPlayingHeaderView.h"
#import "UIView+Utils.h"
#import "AWRMenuView.h"
#import "AWRColorToolkit.h"

const float kToolbarMaximumSize = 58.0;
const float kToolbarMinimumSize = 28.0;

const float kToolbarInitialLeftMargin = 25.0;
const float kToolbarInitialSpacing = 50.0;
const float kToolbarFinalLeftMargin = 112.0;
const float kToolbarFinalSpacing = 20.0;

@interface AWRNowPlayingView()<UIScrollViewDelegate, AWRMenuViewDelegate, AWRNowPlayingHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (strong, nonatomic) AWRNowPlayingHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *mediaControlBar;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *togglePlayButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *lyricsButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (nonatomic, strong) NSDictionary *songNameEffects;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;

@property (strong, nonatomic) AWRMenuView *menu;
@property (weak, nonatomic) IBOutlet UIView *tabContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *lyricsScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *metadataTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIStackView *bigMetadataStackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarItemsLeftMargin;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *toolbarItemsSpacing;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *toolbarItemsWidth;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *toolbarItemsHeight;

@property (strong, nonatomic)UIScrollView *twitterView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AWRNowPlayingView

- (IBAction)toolbarItemSelected:(UIButton *)sender {
    self.lyricsButton.selected = NO;
    self.twitterButton.selected = NO;
    self.websiteButton.selected = NO;
    sender.selected = YES;

    self.lyricsButton.tintColor = [UIColor darkGrayColor];
    self.twitterButton.tintColor = [UIColor darkGrayColor];
    self.websiteButton.tintColor = [UIColor darkGrayColor];
    sender.tintColor = AWRColorToolkit.extraHighlightBackgroundColor;

    self.lyricsLabel.hidden = sender != self.lyricsButton;
    self.twitterView.hidden = sender != self.twitterButton;
    self.webView.hidden = sender != self.websiteButton;

    if (sender == self.lyricsButton) {
        [self setCurrentTab:AWRNowPlayingViewTabLyrics];
    } else if (sender == self.twitterButton) {
        [self setCurrentTab:AWRNowPlayingViewTabTwitter];
    } else if (sender == self.websiteButton) {
        [self setCurrentTab:AWRNowPlayingViewTabWebsite];
    }
}

- (void)setCurrentTab:(AWRNowPlayingViewTab)currentTab {
    if (_currentTab == currentTab) return;

    _currentTab = currentTab;
    switch (currentTab) {
        case AWRNowPlayingViewTabLyrics:
            [self.scrollView setUserInteractionEnabled:YES];
            self.scrollView.scrollEnabled = YES;
            self.lyricsScrollView.hidden = NO;
            self.twitterView.hidden = YES;
            self.webView.hidden = YES;
            [self innerScrollsToTop:NO];
            break;
        case AWRNowPlayingViewTabTwitter:
            [self.scrollView setUserInteractionEnabled:YES];
            self.scrollView.scrollEnabled = YES;
            self.lyricsScrollView.hidden = YES;
            self.twitterView.hidden = NO;
            self.webView.hidden = YES;
            [self innerScrollsToTop:NO];
            break;
        case AWRNowPlayingViewTabWebsite:
            [self.scrollView setUserInteractionEnabled:NO];
            [self.scrollView setContentOffset:CGPointMake(0, [self screenAnimationScrollOffset]) animated:YES];
            self.scrollView.scrollEnabled = NO;
            self.lyricsScrollView.hidden = YES;
            self.twitterView.hidden = YES;
            self.webView.hidden = NO;
            break;
    }

    [self.delegate currentTabHasChanged:_currentTab];
}

- (void)didTapStatusBar {
    [self innerScrollsToTop:YES];
}

- (void)innerScrollsToTop:(BOOL)animated {
    float currentContentOffset = self.scrollView.contentOffset.y;
    [self recalculateContentSize];
    [self.scrollView setContentOffset:CGPointMake(0, MIN(currentContentOffset, [self screenAnimationScrollOffset])) animated:animated];
    [self.lyricsScrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    [self.twitterView setContentOffset:CGPointMake(0, 0) animated:animated];
}

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
        _headerView.delegate = self;
        [_headerView fillSuperview];
        self.headerHeight.constant = _headerView.maximumHeight;
    }
    return _headerView;
}

- (void)setTwitterView:(UIScrollView *)twitterView {
    if (_twitterView) {
        [_twitterView removeFromSuperview];
        _twitterView = nil;
    }
    _twitterView = twitterView;
    [_twitterView removeGestureRecognizer:_twitterView.panGestureRecognizer];
    _twitterView.hidden = self.currentTab != AWRNowPlayingViewTabTwitter;
    [self.tabContainer addSubview:_twitterView];
    [_twitterView fillSuperview];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self emptyFields];
    [self addGestureRecognizer: self.scrollView.panGestureRecognizer];
    [self toolbarItemSelected: self.lyricsButton];

    self.headerContainer.layer.zPosition = 2;
    self.toolbar.layer.zPosition = 3;
    self.togglePlayButton.layer.zPosition = 4;
    self.scrollView.layer.zPosition = 5;
    self.toolbar.backgroundColor = AWRColorToolkit.toolbarBackgroundColor;

    self.toolbarItemsLeftMargin.constant = kToolbarInitialLeftMargin;
    for (NSLayoutConstraint *c in self.toolbarItemsSpacing) { c.constant = kToolbarInitialSpacing; }
    [self setToolbarHeight:kToolbarMaximumSize];
    self.websiteButton.enabled = NO;
    //    [self configureMediaBarShadow];
}

- (void)navigate:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self recalculateContentSize];
}

- (float)screenAnimationScrollOffset {
    float headerOffset = self.headerView.maximumHeight - self.headerView.minimumHeight;
    float toolbarOffset = kToolbarMaximumSize - kToolbarMinimumSize;
    float offsetUntilMetadataIsCompletelyHidden = self.bigMetadataStackView.frame.size.height;
    float maxBigMetadataMovement = offsetUntilMetadataIsCompletelyHidden + 8;
    float maxToolbarMovement = kToolbarMinimumSize + 8;
    return headerOffset + toolbarOffset + maxBigMetadataMovement + maxToolbarMovement;
}

- (void)recalculateContentSize {
    float scrollbarFrameHeight = self.scrollView.frame.size.height;

    float innerScrollMaxContainerSize = [UIScreen mainScreen].bounds.size.height
        - self.headerView.minimumHeight
        - self.mediaControlBar.frame.size.height;

    float innerScrollMaxOffset =
        self.currentTab == AWRNowPlayingViewTabLyrics ? MAX(self.lyricsScrollView.contentSize.height - innerScrollMaxContainerSize, 0)
      : self.currentTab == AWRNowPlayingViewTabTwitter ? MAX(self.twitterView.contentSize.height - innerScrollMaxContainerSize, 0)
      : 0;

    self.scrollView.contentSize = CGSizeMake(1.0, scrollbarFrameHeight + [self screenAnimationScrollOffset] + innerScrollMaxOffset);
}

- (void)setToolbarHeight:(float)height {
    self.toolbarHeightLayoutConstraint.constant = height;
    NSArray *buttons = @[self.lyricsButton, self.twitterButton, self.websiteButton];

    if (height >= 52) {
        for (NSLayoutConstraint *c in self.toolbarItemsWidth) { c.constant = 40; }
        for (NSLayoutConstraint *c in self.toolbarItemsHeight) { c.constant = 12; }
        for (UIButton *b in buttons) { b.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 12.0, 0.0); }
        [self.lyricsButton setTitle:NSLocalizedString(@"TOOLBAR_LYRICS", nil) forState:UIControlStateNormal];
        [self.twitterButton setTitle:NSLocalizedString(@"TOOLBAR_TWITTER", nil) forState:UIControlStateNormal];
        [self.websiteButton setTitle:NSLocalizedString(@"TOOLBAR_WEBSITE", nil) forState:UIControlStateNormal];
        [self.lyricsButton setTitle:NSLocalizedString(@"TOOLBAR_LYRICS", nil) forState:UIControlStateSelected];
        [self.twitterButton setTitle:NSLocalizedString(@"TOOLBAR_TWITTER", nil) forState:UIControlStateSelected];
        [self.websiteButton setTitle:NSLocalizedString(@"TOOLBAR_WEBSITE", nil) forState:UIControlStateSelected];
        return;
    }

    if (height >= 44) {
        for (NSLayoutConstraint *c in self.toolbarItemsWidth) { c.constant = 40; }
        for (NSLayoutConstraint *c in self.toolbarItemsHeight) { c.constant = 0; }
        for (UIButton *b in buttons) {
            b.imageEdgeInsets = UIEdgeInsetsZero;
            [b setTitle:@"" forState:UIControlStateNormal];
            [b setTitle:@"" forState:UIControlStateSelected];
        }
        return;
    }

    for (NSLayoutConstraint *c in self.toolbarItemsWidth) { c.constant = height - 4; }
    for (NSLayoutConstraint *c in self.toolbarItemsHeight) { c.constant = 0; }
    for (UIButton *b in buttons) {
        b.imageEdgeInsets = UIEdgeInsetsZero;
        [b setTitle:@"" forState:UIControlStateNormal];
        [b setTitle:@"" forState:UIControlStateSelected];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"hey!");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) return;

    float offset = scrollView.contentOffset.y;
    float headerSize = MAX(self.headerView.maximumHeight - offset,
                           self.headerView.minimumHeight);

    self.headerHeight.constant = headerSize;
    float maxScrollHeader = self.headerView.maximumHeight - self.headerView.minimumHeight;

    // Check if Header is transitioning between maximum and minimum sizes
    if (offset <= maxScrollHeader) {
        ////////////////////////
        /// Scrolling Header ///
        ////////////////////////

        // Scroll lyrics and Twitter to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);
        self.twitterView.contentOffset = CGPointMake(0, 0);

        // Keep Big Metadata 4 pixels below toolbar
        self.metadataTopLayoutConstraint.constant = 4;

        // Big Metadata is completely visible
        self.songLabel.alpha = 1.0;
        self.artistLabel.alpha = 1.0;

        // Header mini-Metadata should be hidden
        self.headerView.metadataAlpha = 0.0;
        self.headerView.metadataOffset = self.headerView.maximumHeight;

        // Toolbar is yet at the maximum size
        [self setToolbarHeight:kToolbarMaximumSize];

        self.toolbarTopLayoutConstraint.constant = 0;
        self.toolbar.backgroundColor = AWRColorToolkit.toolbarBackgroundColor;

        self.toolbarItemsLeftMargin.constant = kToolbarInitialLeftMargin;
        for (NSLayoutConstraint *c in self.toolbarItemsSpacing) { c.constant = kToolbarInitialSpacing; }

        return;
    }

    // Header size is the minimum
    // Let's check how further we are from that point
    float offsetAfterHeaderTransition = offset - maxScrollHeader;
    float toolbarSize = MAX(kToolbarMaximumSize - offsetAfterHeaderTransition,
                            kToolbarMinimumSize);

    [self setToolbarHeight:toolbarSize];
    float maxToolbarTransformation = kToolbarMaximumSize - kToolbarMinimumSize;

    // Check if Toolbar is transitioning between maximum and minimum sizes
    if (offsetAfterHeaderTransition <= maxToolbarTransformation) {
        ////////////////////////////
        /// Transforming Toolbar ///
        ////////////////////////////

        // Scroll lyrics and Twitter to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);
        self.twitterView.contentOffset = CGPointMake(0, 0);

        // Keep Big Metadata 4 pixels below toolbar
        self.metadataTopLayoutConstraint.constant = 4;

        // Big Metadata is completely visible
        self.songLabel.alpha = 1.0;
        self.artistLabel.alpha = 1.0;

        // Header mini-Metadata should be hidden
        self.headerView.metadataAlpha = 0.0;
        self.headerView.metadataOffset = self.headerView.maximumHeight;

        self.toolbarTopLayoutConstraint.constant = 0;
        self.toolbar.backgroundColor = AWRColorToolkit.toolbarBackgroundColor;

        self.toolbarItemsLeftMargin.constant = kToolbarInitialLeftMargin;
        for (NSLayoutConstraint *c in self.toolbarItemsSpacing) { c.constant = kToolbarInitialSpacing; }

        return;
    }

    // Toolbar already reached the minimum size
    // Let's check how further we are from that point
    float offsetAfterToolbarTransformation = offsetAfterHeaderTransition - maxToolbarTransformation;
    float offsetUntilMetadataIsCompletelyHidden = self.bigMetadataStackView.frame.size.height;
    float maxBigMetadataMovement = offsetUntilMetadataIsCompletelyHidden + kToolbarMinimumSize + 12;
    float offsetBigMetadata = 4 - MIN(offsetAfterToolbarTransformation, maxBigMetadataMovement);

    self.metadataTopLayoutConstraint.constant = offsetBigMetadata;
    self.headerView.metadataOffset = MAX((self.headerView.minimumHeight / 2) + 20 - offsetAfterToolbarTransformation, 0);

    if (offsetAfterToolbarTransformation <= offsetUntilMetadataIsCompletelyHidden) {
        //////////////////////////////////
        /// Still visible Big Metadata ///
        //////////////////////////////////

        // Scroll lyrics and Twitter to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);
        self.twitterView.contentOffset = CGPointMake(0, 0);

        float movementPercentage = offsetAfterToolbarTransformation / offsetUntilMetadataIsCompletelyHidden;
        // Big Metadata is partially visible
        self.songLabel.alpha = 1.0 - movementPercentage;
        self.artistLabel.alpha = 1.0 - movementPercentage;

        // Header mini-Metadata is partially visible (inversely proportional to big metadata alpha)
        self.headerView.metadataAlpha = movementPercentage;

        self.toolbarTopLayoutConstraint.constant = 0;
        self.toolbar.backgroundColor = AWRColorToolkit.toolbarBackgroundColor;

        self.toolbarItemsLeftMargin.constant = kToolbarInitialLeftMargin;
        for (NSLayoutConstraint *c in self.toolbarItemsSpacing) { c.constant = kToolbarInitialSpacing; }

        return;
    }

    // Big metadata is completely invisible now
    // Small metadata completely visible
    self.songLabel.alpha = 0.0;
    self.artistLabel.alpha = 0.0;
    self.headerView.metadataAlpha = 1.0;

    // Let's check how further we are from that point
    float offsetAfterHidingMetadata = offsetAfterToolbarTransformation - offsetUntilMetadataIsCompletelyHidden;
    float maxToolbarMovement = kToolbarMinimumSize + 8;
    float offsetToolbarMovement = -MIN(offsetAfterHidingMetadata, maxToolbarMovement);

    self.metadataTopLayoutConstraint.constant = offsetBigMetadata - offsetToolbarMovement;
    self.toolbarTopLayoutConstraint.constant = offsetToolbarMovement;

    if (offsetAfterHidingMetadata <= maxToolbarMovement) {
        ////////////////////////////////
        /// Moving toolbar to header ///
        ////////////////////////////////

        // Scroll lyrics and Twitter to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);
        self.twitterView.contentOffset = CGPointMake(0, 0);

        float movementPercentage = 1.0 - offsetAfterHidingMetadata / maxToolbarMovement;
        // Toolbar background is partially opaque
        self.toolbar.backgroundColor = [AWRColorToolkit.toolbarBackgroundColor colorWithAlphaComponent:movementPercentage];

        self.toolbarItemsLeftMargin.constant = kToolbarInitialLeftMargin + (1.0 - movementPercentage) * (kToolbarFinalLeftMargin - kToolbarInitialLeftMargin);
        for (NSLayoutConstraint *c in self.toolbarItemsSpacing) { c.constant = kToolbarInitialSpacing + (1.0 - movementPercentage) * (kToolbarFinalSpacing - kToolbarInitialSpacing); }

        return;
    }

    // Outer scroll is done, the toolbar must be hidden now
    self.toolbar.backgroundColor = [UIColor clearColor];

    self.toolbarItemsLeftMargin.constant = kToolbarFinalLeftMargin;
    for (NSLayoutConstraint *c in self.toolbarItemsSpacing) { c.constant = kToolbarFinalSpacing; }

    // And the rest of the scroll belongs to the children scrollviews
    float remainingOffset = offsetAfterHidingMetadata - maxToolbarMovement;
    if (self.currentTab == AWRNowPlayingViewTabLyrics) {
        self.lyricsScrollView.contentOffset = CGPointMake(0, remainingOffset);
    } else if (self.currentTab == AWRNowPlayingViewTabTwitter) {
        self.twitterView.contentOffset = CGPointMake(0, remainingOffset);
    } else {

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
        [weakSelf.headerView renderModel:model];
        self.songLabel.attributedText = [[NSAttributedString alloc]initWithString:model.songName attributes:self.songNameEffects];
        self.artistLabel.text = model.artistName;
        self.lyricsLabel.text = model.lyrics;
        self.websiteButton.enabled = model.hasUrl;
    });
}

- (NSDictionary *)songNameEffects {
    if (!_songNameEffects) {
        _songNameEffects = @{
                             NSForegroundColorAttributeName: self.songLabel.textColor,
                             NSFontAttributeName: self.songLabel.font,
                             NSStrokeColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.1 alpha:0.9],
                             NSStrokeWidthAttributeName: @(-5.0)
                             };
    }
    return _songNameEffects;
}

- (void)emptyFields {
    self.songLabel.text = @"";
    self.artistLabel.text = @"";
    self.lyricsLabel.text = @"";
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

//- (void)configureMediaBarShadow {
//    id backgroundColor = (id)[self.backgroundColor CGColor];
//    id backgroundColorWithTransparency = (id)[[self.backgroundColor colorWithAlphaComponent:0.01] CGColor];
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.shadowView.bounds;
//        gradient.colors = [NSArray arrayWithObjects:backgroundColorWithTransparency,
//                                                    backgroundColor,
//                                                    nil];
//        [self.shadowView.layer insertSublayer:gradient atIndex:0];
//    });
//}

@end
