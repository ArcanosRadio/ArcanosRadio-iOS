#import "AWRTwitterViewController.h"

@interface AWRTwitterViewController ()

@property (nonatomic, strong)TWTRAPIClient *client;

@end

@implementation AWRTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [TWTRAPIClient new];
}

- (void)setTwitterSearch:(NSString *)searchQuery {
    TWTRSearchTimelineDataSource *searchDataSource = [[TWTRSearchTimelineDataSource alloc] initWithSearchQuery:searchQuery APIClient:self.client];
    self.dataSource = searchDataSource;
}

- (void)setTwitterTimeline:(NSString *)timeline {
    TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:timeline APIClient:self.client];
    self.dataSource = userTimelineDataSource;
}

@end
