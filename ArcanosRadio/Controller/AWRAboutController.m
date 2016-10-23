#import "AWRAboutController.h"
#import "AWRAboutView.h"

@interface AWRAboutController () <AWRAboutViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property(readonly, nonatomic) AWRAboutView *aboutView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *content;

@end

@implementation AWRAboutController

- (AWRAboutView *)aboutView {
    return (AWRAboutView *)self.view;
}

- (instancetype)init {
    self = [super initWithNibName:@"AWRAboutView" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.aboutView.delegate = self;
}

- (void)backButtonPressed {
    if (!self.delegate) return;

    [self.delegate userDidCloseAbout];
}

-(NSArray *)content {
    if (!_content) {
        NSString *acknowledgementsPlist = [[NSBundle mainBundle]
                                           pathForResource:@"Acknowledgements"
                                           ofType:@"plist"];
        NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:acknowledgementsPlist];
        _content = [root objectForKey:@"Licenses"];
    }
    return _content;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [self.content objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [[self.content objectAtIndex:indexPath.row] valueForKey:@"state"];
    return cell;
}

@end
