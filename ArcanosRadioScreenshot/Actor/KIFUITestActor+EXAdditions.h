#import <KIF/KIF.h>
@protocol AWRPlaylist;

NS_ASSUME_NONNULL_BEGIN

@interface KIFUITestActor (EXAdditions)

- (void)waitForMusic;
- (void)screenshotWithIdentifier:(NSString *)identifier;
- (void)scrollToBottom;
- (void)scrollToTop;
- (void)setSongName:(NSString *)songName
         artistName:(NSString *)artistName
            twitter:(NSString *)twitter
            website:(NSString *)website
             lyrics:(NSString *)lyrics
                art:(UIImage *)art;
- (void)goToLyricsTab;
- (void)goToTwitterTab;
- (void)goToWebsiteTab;

@end

NS_ASSUME_NONNULL_END
