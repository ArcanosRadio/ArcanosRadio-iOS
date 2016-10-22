// ScrollView behavior was adapted from Yari D'areglia's (@bitwaker) article:
// http://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
// Visit his github for more information:
// https://github.com/ariok/TB_TwitterUI

#import "AWRNowPlayingView.h"
#import "AWRNowPlayingHeaderView.h"
#import "UIView+Utils.h"
#import "AWRMenu.h"

@interface AWRNowPlayingView()<UIScrollViewDelegate, AWRMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet UIStackView *metadataContainer;
@property (strong, nonatomic) AWRNowPlayingHeaderView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet UIView *mediaControlBar;

@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *togglePlayButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacerBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaControlsMaxTopConstraint;

@property (nonatomic, strong) NSDictionary *songNameEffects;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet AWRMenu *menu;

@end

@implementation AWRNowPlayingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (AWRMenu *)menu {
    if (!_menu) {
        NSArray<AWRMenuItem *> *items = @[[AWRMenuItem itemWithIdentifier:@"share"
                                                                     icon: [UIImage imageNamed:@"share"]
                                                                     text: NSLocalizedString(@"MENU_SHARE", nil)],
                                          [AWRMenuItem itemWithIdentifier:@"settings"
                                                                     icon: [UIImage imageNamed:@"settings"]
                                                                     text: NSLocalizedString(@"MENU_SETTINGS", nil)],
                                          [AWRMenuItem itemWithIdentifier:@"about"
                                                                     icon: [UIImage imageNamed:@"help"]
                                                                     text: NSLocalizedString(@"MENU_ABOUT", nil)]
                                          ];
        _menu = [[AWRMenu alloc] initWithFrame:self.frame];
        _menu.delegate = self;
        _menu.items = items;
    }
    return _menu;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self emptyFields];
}

- (void)emptyFields {
    self.songNameLabel.text = @"";
    self.artistNameLabel.text = @"";
    self.lyricsLabel.text = @"";
}

- (AWRNowPlayingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AWRNowPlayingHeaderView" owner:self options:nil] firstObject];
        [self.headerContainer addSubview:_headerView];
        [_headerView fillSuperview];
        self.headerHeight.constant = _headerView.maximumHeight;
        self.mediaControlsMaxTopConstraint.constant = _headerView.minimumHeight;
    }
    return _headerView;
}

- (void)setTogglePlayButton:(UIButton *)togglePlayButton {
    _togglePlayButton = togglePlayButton;
    _togglePlayButton.layer.cornerRadius = _togglePlayButton.frame.size.height / 2.0f;
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
    self.spacerBottomConstraint.constant =
    MAX(mediaControlHeight,
        self.bounds.size.height - self.lyricsLabel.frame.size.height - self.headerView.minimumHeight / 2);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    self.headerHeight.constant = MAX(self.headerView.maximumHeight - offset,
                                     self.headerView.minimumHeight);


    float mainMetadataContainerPaddingTop = 6.0;

    float realSongNameTop = self.metadataContainer.frame.origin.y + mainMetadataContainerPaddingTop - offset;

    if (realSongNameTop >= self.headerHeight.constant) {
        // big song name is completely visible
        // header title should be hidden
        self.headerView.metadataOffset = mainMetadataContainerPaddingTop + self.headerView.maximumHeight / 2;
        self.headerView.metadataAlpha = 0.0;
        self.metadataContainer.alpha = 1.0;
    } else {
        // big song name is partially or fully covered by header
        // header title should be proportionally visible
        float headerPathStart = mainMetadataContainerPaddingTop + self.headerView.minimumHeight / 2;
        float hiddenSize = self.headerHeight.constant - realSongNameTop;

        float alphaHeader = MIN(hiddenSize / 30, 1.0);
        float alphaMain = 1.0 - alphaHeader;
        self.headerView.metadataAlpha = alphaHeader;
        self.metadataContainer.alpha = alphaMain;

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

- (IBAction)menuPressed:(id)sender {
    self.menu.layer.zPosition = 4;
    [self addSubview:_menu];
    [self.menu show];
}

- (void)menu:(AWRMenu *)menu didSelectItemWithIdentifier:(NSString *)identifier {
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

- (void)menuDidBecomeHidden:(AWRMenu *)menu {
    [menu removeFromSuperview];
}

- (void)setVolume:(float)percentage {
    [self.volumeSlider setValue:percentage];
}

- (IBAction)volumeChanged:(UISlider *)sender {
    if (!self.delegate) return;
    [self.delegate volumeChangedTo:self.volumeSlider.value];
}

- (NSDictionary *)songNameEffects {
    if (!_songNameEffects) {
        _songNameEffects = @{
                             NSForegroundColorAttributeName: self.songNameLabel.textColor,
                             NSFontAttributeName: self.songNameLabel.font,
                             NSStrokeColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.1 alpha:0.9],
                             NSStrokeWidthAttributeName: @(-5.0)
                             };
    }
    return _songNameEffects;
}

- (void)renderModel:(AWRNowPlayingViewModel *)model {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spacerBottomConstraint.constant = self.bounds.size.height;
        weakSelf.songNameLabel.attributedText = [[NSAttributedString alloc]initWithString:model.songName attributes:weakSelf.songNameEffects];
        weakSelf.artistNameLabel.text = model.artistName;
        weakSelf.lyricsLabel.text = model.lyrics;
        [weakSelf.headerView renderModel:model];
        [weakSelf calculatePaddingBottom];
    });
}

- (void)setStatusPlaying {
    [self.togglePlayButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}

- (void)setStatusStopped {
    [self.togglePlayButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (void)setStatusBuffering {
    [self.togglePlayButton setImage:[UIImage imageNamed:@"hourglass"] forState:UIControlStateNormal];
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
