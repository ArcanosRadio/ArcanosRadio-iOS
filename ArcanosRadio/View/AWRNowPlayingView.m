#import "AWRNowPlayingView.h"
#import "AWRNowPlayingHeaderView.h"
#import "AWRNowPlayingBodyView.h"
#import "UIView+Utils.h"
#import "AWRMenuView.h"
#import "AWRColorToolkit.h"

const float kToolbarMaximumSize = 58.0;
const float kToolbarMinimumSize = 28.0;

@interface AWRNowPlayingView()<UIScrollViewDelegate, AWRMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (strong, nonatomic) AWRNowPlayingHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *mediaControlBar;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *togglePlayButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIStackView *toolbar;
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
        [_headerView fillSuperview];
        self.headerHeight.constant = _headerView.maximumHeight;
    }
    return _headerView;
}

//- (void)setTwitterView:(UITableView *)twitterView {
//    [self.bodyView setTwitterView:twitterView];
//}

- (void)layoutSubviews {
    [super layoutSubviews];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self emptyFields];
        [self addGestureRecognizer: self.scrollView.panGestureRecognizer];
        [self toolbarItemSelected: self.lyricsButton];

        self.headerContainer.layer.zPosition = 2;
        self.toolbar.layer.zPosition = 3;
        self.togglePlayButton.layer.zPosition = 4;
        [self setToolbarColor:AWRColorToolkit.toolbarBackgroundColor];
    });

//    [self configureMediaBarShadow];
    [self recalculateContentSize];
}

- (void)setToolbarColor:(UIColor *)color {
    for (UIView *view in self.toolbar.subviews) {
        view.backgroundColor = color;
    }
}

- (void)recalculateContentSize {
    float scrollbarFrameHeight = self.scrollView.frame.size.height;
    float headerOffset = self.headerView.maximumHeight - self.headerView.minimumHeight;
    float toolbarOffset = kToolbarMaximumSize - kToolbarMinimumSize;
    float offsetUntilMetadataIsCompletelyHidden = self.bigMetadataStackView.frame.size.height;
    float maxBigMetadataMovement = offsetUntilMetadataIsCompletelyHidden + kToolbarMinimumSize;
    float maxToolbarMovement = kToolbarMinimumSize + 8;

    float maxLyricsContainerSize = [UIScreen mainScreen].bounds.size.height
        - self.headerView.minimumHeight
        - self.mediaControlBar.frame.size.height;

    float lyricsMaxOffset = MAX(self.lyricsScrollView.contentSize.height - maxLyricsContainerSize, 0);
    self.scrollView.contentSize = CGSizeMake(1.0, scrollbarFrameHeight + headerOffset + toolbarOffset + lyricsMaxOffset + maxBigMetadataMovement + maxToolbarMovement);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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

        // Scroll lyrics to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);

        // Keep Big Metadata 4 pixels below toolbar
        self.metadataTopLayoutConstraint.constant = 4;

        // Big Metadata is completely visible
        self.songLabel.alpha = 1.0;
        self.artistLabel.alpha = 1.0;

        // Header mini-Metadata should be hidden
        self.headerView.metadataAlpha = 0.0;
        self.headerView.metadataOffset = self.headerView.maximumHeight;

        // Toolbar is yet at the maximum size
        self.toolbarHeightLayoutConstraint.constant = kToolbarMaximumSize;

        self.toolbarTopLayoutConstraint.constant = 0;
        [self setToolbarColor:AWRColorToolkit.toolbarBackgroundColor];
        return;
    }

    // Header size is the minimum
    // Let's check how further we are from that point
    float offsetAfterHeaderTransition = offset - maxScrollHeader;
    float toolbarSize = MAX(kToolbarMaximumSize - offsetAfterHeaderTransition,
                            kToolbarMinimumSize);

    self.toolbarHeightLayoutConstraint.constant = toolbarSize;
    float maxToolbarTransformation = kToolbarMaximumSize - kToolbarMinimumSize;

    // Check if Toolbar is transitioning between maximum and minimum sizes
    if (offsetAfterHeaderTransition <= maxToolbarTransformation) {
        ////////////////////////////
        /// Transforming Toolbar ///
        ////////////////////////////

        // Scroll lyrics to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);

        // Keep Big Metadata 4 pixels below toolbar
        self.metadataTopLayoutConstraint.constant = 4;

        // Big Metadata is completely visible
        self.songLabel.alpha = 1.0;
        self.artistLabel.alpha = 1.0;

        // Header mini-Metadata should be hidden
        self.headerView.metadataAlpha = 0.0;
        self.headerView.metadataOffset = self.headerView.maximumHeight;

        self.toolbarTopLayoutConstraint.constant = 0;
        [self setToolbarColor:AWRColorToolkit.toolbarBackgroundColor];
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

        // Scroll lyrics to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);

        float movementPercentage = offsetAfterToolbarTransformation / offsetUntilMetadataIsCompletelyHidden;
        // Big Metadata is partially visible
        self.songLabel.alpha = 1.0 - movementPercentage;
        self.artistLabel.alpha = 1.0 - movementPercentage;

        // Header mini-Metadata is partially visible (inversely proportional to big metadata alpha)
        self.headerView.metadataAlpha = movementPercentage;

        self.toolbarTopLayoutConstraint.constant = 0;
        [self setToolbarColor:AWRColorToolkit.toolbarBackgroundColor];
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

        // Scroll lyrics to the top
        self.lyricsScrollView.contentOffset = CGPointMake(0, 0);

        float movementPercentage = 1.0 - offsetAfterHidingMetadata / maxToolbarMovement;
        // Toolbar background is partially opaque
        [self setToolbarColor:[AWRColorToolkit.toolbarBackgroundColor colorWithAlphaComponent:movementPercentage]];
        return;
    }

    // Outer scroll is done, the toolbar must be hidden now
    [self setToolbarColor:[UIColor clearColor]];

    // And the rest of the scroll belongs to the children scrollviews
    float remainingOffset = offsetAfterHidingMetadata - maxToolbarMovement;
    self.lyricsScrollView.contentOffset = CGPointMake(0, remainingOffset);
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
