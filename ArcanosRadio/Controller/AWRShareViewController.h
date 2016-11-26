#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWRSong.h"

@interface AWRShareViewController : UIActivityViewController

- (nonnull instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithActivityItems:(nonnull NSArray *)activityItems applicationActivities:(nullable NSArray<__kindof UIActivity *> *)applicationActivities NS_UNAVAILABLE;
- (nonnull instancetype)initWithCurrentSong:(nonnull id<AWRSong>)currentSong parentView:(nonnull UIView *)parentView NS_DESIGNATED_INITIALIZER;

@end
