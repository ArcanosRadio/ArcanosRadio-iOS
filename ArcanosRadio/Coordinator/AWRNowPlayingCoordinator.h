#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AWRNowPlayingCoordinatorDelegate

- (void)userDidSelectAbout;
- (void)userDidSelectSettings;

@end

@interface AWRNowPlayingCoordinator : NSObject

@property (nonatomic, weak) id<AWRNowPlayingCoordinatorDelegate> delegate;

- (UIViewController *)start;

@end
