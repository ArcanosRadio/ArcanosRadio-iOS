// ScrollView behavior was adapted from Yari D'areglia's (@bitwaker) article:
// http://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
// Visit his github for more information:
// https://github.com/ariok/TB_TwitterUI

#import "AWRNowPlayingView.h"
#import "AWRNowPlayingHeaderView.h"
#import "AWRNowPlayingBodyView.h"
#import "UIView+Utils.h"
#import "AWRMenuView.h"
#import "AWRColorToolkit.h"

@interface AWRNowPlayingView()<UIScrollViewDelegate, AWRMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (strong, nonatomic) AWRNowPlayingHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *mediaControlBar;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *togglePlayButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *lyricsButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (nonatomic, strong) NSDictionary *songNameEffects;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;

@property (strong, nonatomic) AWRMenuView *menu;
@property (weak, nonatomic) IBOutlet UIView *tabContainer;

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
    });

    [self calculateConstraints];
    self.headerContainer.layer.zPosition = 2;
    self.togglePlayButton.layer.zPosition = 3;
//    [self configureMediaBarShadow];
    [self recalculateContentSize];
}

- (void)recalculateContentSize {
//    let maxOffsetText1 = textView.contentSize.height - textView.frame.height
//    let maxOffsetText2 = textView2.contentSize.height - textView2.frame.height
//    let totalOffset = maxOffsetText1 + maxOffsetText2
//    let scrollContentSize = totalOffset + scrollView.frame.height
    float scrollContentSize = 5000.0;

    self.scrollView.contentSize = CGSizeMake(1.0, scrollContentSize);
}

- (void)calculateConstraints {
//    self.bodyTopConstraint.constant = self.headerView.maximumHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;

    self.headerHeight.constant = MAX(self.headerView.maximumHeight - offset,
                                     self.headerView.minimumHeight);

//    float mainMetadataContainerPaddingTop = 6.0;

//    float realSongNameTop = self.bodyContainer.frame.origin.y + mainMetadataContainerPaddingTop - offset;

//    if (realSongNameTop >= self.headerHeight.constant) {
//        // big song name is completely visible
//        // header title should be hidden
//        self.headerView.metadataOffset = mainMetadataContainerPaddingTop + self.headerView.maximumHeight / 2;
//        self.headerView.metadataAlpha = 0.0;
//        self.bodyView.titleAlpha = 1.0;
//    } else {
//        // big song name is partially or fully covered by header
//        // header title should be proportionally visible
//        float headerPathStart = mainMetadataContainerPaddingTop + self.headerView.minimumHeight / 2;
//        float hiddenSize = self.headerHeight.constant - realSongNameTop;
//
//        float alphaHeader = MIN(hiddenSize / 30, 1.0);
//        float alphaMain = 1.0 - alphaHeader;
//        self.headerView.metadataAlpha = alphaHeader;
//        self.bodyView.titleAlpha = alphaMain;
//
//        float headerPathProgress = MAX(0.0, headerPathStart - hiddenSize);
//        self.headerView.metadataOffset = headerPathProgress;
//    }
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
