#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface AWRTwitterViewController : TWTRTimelineViewController

- (void)setTwitterTimeline:(NSString *)timeline;
- (void)setTwitterSearch:(NSString *)searchQuery;

@end
