#import "AWRAboutView.h"

@interface AWRAboutView()<UINavigationBarDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AWRAboutView

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AWRDeveloperInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"developerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AWRAppLinkInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"appLinkCell"];
}

- (void)setNavigationBar:(UINavigationBar *)navigationBar {
    _navigationBar = navigationBar;
    _navigationBar.delegate = self;

    UINavigationItem *titleItem = [_navigationBar.items firstObject];
    titleItem.title = NSLocalizedString(@"ABOUT_TITLE_TEXT", nil);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.navigationBar.frame;
    float y = rect.size.height + rect.origin.y;
    self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    CGRect frame = self.navigationBar.frame;
    frame.origin = CGPointMake(0, [UIApplication sharedApplication].statusBarFrame.size.height);
    self.navigationBar.frame = frame;

    return UIBarPositionTopAttached;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.delegate) return;
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (IBAction)backButtonPressed:(id)sender {
    if (!self.delegate) return;

    [self.delegate backButtonPressed];
}

@end
