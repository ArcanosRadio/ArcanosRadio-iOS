#import <TwitterKit/TwitterKit.h>
#import <UIKit/UIKit.h>

@protocol AWRTwitterViewControllerDelegate

- (void)twitterDidRefresh;

@end

@interface AWRTwitterViewController : TWTRTimelineViewController

@property (nonatomic, weak) id<AWRTwitterViewControllerDelegate> delegate;
- (void)setTwitterTimeline:(NSString *)timeline;
- (void)setTwitterSearch:(NSString *)searchQuery;

@end
