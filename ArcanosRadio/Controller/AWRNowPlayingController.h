#import <UIKit/UIKit.h>
#import "AWRViewController.h"
@class AWRNowPlayingViewModel;

@protocol AWRNowPlayingControllerDelegate

- (void)userDidSelectShare;
- (void)userDidSelectAbout;
- (void)userDidSelectSettings;

@end

@interface AWRNowPlayingController : AWRViewController

@property (weak, nonatomic) id<AWRNowPlayingControllerDelegate>delegate;

- (void)metadataDidChangeTheSong:(NSString *)song artist:(NSString *)artist albumArt:(UIImage *)albumArt;
- (void)metadataDidFinishDownloadingAlbumArt:(UIImage *)albumArt;
- (void)metadataDidFinishDownloadingLyrics:(NSString *)lyrics;

@end
