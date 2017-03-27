//#import "AWRNowPlayingBodyView.h"
//#import "UIView+Utils.h"
//
//@interface AWRNowPlayingBodyView()
//
//@property (weak, nonatomic) IBOutlet UIStackView *metadataContainer;
//@property (weak, nonatomic) IBOutlet UIScrollView *lyricsContainer;
//@property (weak, nonatomic) IBOutlet UIView *twitterContainerView;
//
//@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;
//@property (nonatomic, strong) NSDictionary *songNameEffects;
//@property (nonatomic, strong) UITableView *twitterView;
//
//@end
//
//@implementation AWRNowPlayingBodyView
//
//- (void)layoutSubviews {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self emptyFields];
//    });
//}
//
//- (void)renderModel:(AWRNowPlayingViewModel *)model {
//    self.songNameLabel.attributedText = [[NSAttributedString alloc]initWithString:model.songName attributes:self.songNameEffects];
//    self.artistNameLabel.text = model.artistName;
//    self.lyricsLabel.text = model.lyrics;
//}
//
//- (NSDictionary *)songNameEffects {
//    if (!_songNameEffects) {
//        _songNameEffects = @{
//                             NSForegroundColorAttributeName: self.songNameLabel.textColor,
//                             NSFontAttributeName: self.songNameLabel.font,
//                             NSStrokeColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.1 alpha:0.9],
//                             NSStrokeWidthAttributeName: @(-5.0)
//                             };
//    }
//    return _songNameEffects;
//}
//
//- (void)emptyFields {
//    self.songNameLabel.text = @"";
//    self.artistNameLabel.text = @"";
//    self.lyricsLabel.text = @"";
//}
//
//- (void)showLyrics {
//    self.lyricsContainer.hidden = NO;
//    self.twitterContainerView.hidden = YES;
//}
//
//- (void)showTwitter {
//    self.lyricsContainer.hidden = YES;
//    self.twitterContainerView.hidden = NO;
//}
//
//- (void)showWebsite {
//    self.lyricsContainer.hidden = YES;
//    self.twitterContainerView.hidden = YES;
//}
//
//- (float)titleAlpha {
//    return self.metadataContainer.alpha;
//}
//
//- (void)setTitleAlpha:(float)titleAlpha {
//    self.metadataContainer.alpha = titleAlpha;
//    self.lyricsContainer.scrollEnabled = self.twitterView.scrollEnabled = self.titleAlpha <= 0.01;
//}
//
//- (void)setTwitterView:(UITableView *)twitterView {
//    if (_twitterView != twitterView) {
//        if (_twitterView) {
//            [_twitterView removeFromSuperview];
//        }
//        self.lyricsContainer.scrollEnabled = twitterView.scrollEnabled = self.titleAlpha <= 0.01;
//        _twitterView = twitterView;
//        _twitterView.frame = self.twitterContainerView.frame;
//        [self.twitterContainerView addSubview:_twitterView];
//        [_twitterView fillSuperview];
//    }
//}
//
//@end
