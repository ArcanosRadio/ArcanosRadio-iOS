#import "AWRSong.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRShareViewController : UIActivityViewController

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)initWithActivityItems:(NSArray *)activityItems
                applicationActivities:(nullable NSArray<__kindof UIActivity *> *)applicationActivities NS_UNAVAILABLE;
- (instancetype)initWithCurrentSong:(id<AWRSong>)currentSong parentView:(UIView *)parentView NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
