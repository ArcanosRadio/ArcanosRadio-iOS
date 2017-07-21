#import "AWRTwitterViewController.h"
#import "AWRTwitterView.h"

@interface AWRTwitterViewController () <TWTRTimelineDelegate>

@property (nonatomic, strong) TWTRAPIClient *client;

@end

@implementation AWRTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [(AWRTwitterView *)self.view configureView];
    self.client           = [TWTRAPIClient new];
    self.timelineDelegate = self;
}

- (void)timeline:(TWTRTimelineViewController *)timeline didFinishLoadingTweets:(NSArray *)tweets error:(NSError *)error {
    [self.delegate twitterDidRefresh];
}

- (void)setTwitterSearch:(NSString *)searchQuery {
    dispatch_async(dispatch_get_main_queue(), ^{
        TWTRSearchTimelineDataSource *searchDataSource =
            [[TWTRSearchTimelineDataSource alloc] initWithSearchQuery:searchQuery APIClient:self.client];
        self.dataSource = searchDataSource;
    });
}

- (void)setTwitterTimeline:(NSString *)timeline {
    dispatch_async(dispatch_get_main_queue(), ^{
        TWTRUserTimelineDataSource *userTimelineDataSource =
            [[TWTRUserTimelineDataSource alloc] initWithScreenName:timeline APIClient:self.client];
        self.dataSource = userTimelineDataSource;
    });
}

@end
