#import "AWRNowPlayingBodyView.h"
#import "UIView+Utils.h"

@interface AWRNowPlayingBodyView()

@property (weak, nonatomic) IBOutlet UIStackView *metadataContainer;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;
@property (weak, nonatomic) IBOutlet UIView *twitterContainerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *twitterViewHeight;
@property (nonatomic, strong) NSDictionary *songNameEffects;
@property (nonatomic, strong) UITableView *twitterView;

@end

@implementation AWRNowPlayingBodyView

- (void)layoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self emptyFields];
    });
}

- (void)renderModel:(AWRNowPlayingViewModel *)model {
    self.songNameLabel.attributedText = [[NSAttributedString alloc]initWithString:model.songName attributes:self.songNameEffects];
    self.artistNameLabel.text = model.artistName;
    self.lyricsLabel.text = model.lyrics;
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

- (void)emptyFields {
    self.songNameLabel.text = @"";
    self.artistNameLabel.text = @"";
    self.lyricsLabel.text = @"";
}

- (float)titleAlpha {
    return self.metadataContainer.alpha;
}

- (void)setTitleAlpha:(float)titleAlpha {
    self.metadataContainer.alpha = titleAlpha;
    self.twitterView.scrollEnabled = titleAlpha <= 0.01;
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIView *lowerView = self.twitterView ?: self.lyricsLabel;
    return CGSizeMake(lowerView.frame.origin.x + lowerView.frame.size.width,
                      lowerView.frame.origin.y + lowerView.frame.size.height);
}

- (void)setTwitterView:(UITableView *)twitterView {
    if (_twitterView != twitterView) {
        if (_twitterView) {
            [_twitterView removeFromSuperview];
        }
        twitterView.scrollEnabled = self.titleAlpha <= 0.01;
        _twitterView = twitterView;
        _twitterView.frame = self.twitterContainerView.frame;
        [self.twitterContainerView addSubview:_twitterView];
        [_twitterView fillSuperview];
        self.twitterViewHeight.constant = 200;
    }
}

@end
