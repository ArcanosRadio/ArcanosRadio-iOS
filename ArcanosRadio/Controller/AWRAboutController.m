#import "AWRAboutController.h"
#import "AWRAboutView.h"
#import "AWRAppDeveloperViewModel.h"
#import "AWRDeveloperInfoTableViewCell.h"
#import "AWRAppInfoViewModel.h"
#import "AWRAppLinkInfoTableViewCell.h"

@interface AWRAboutController () <AWRAboutViewDelegate, UITableViewDataSource>

@property(readonly, nonatomic) AWRAboutView *aboutView;
@property (strong, nonatomic) NSArray<AWRLicenseViewModel *> *thirdPartyLibs;
@property (strong, nonatomic) NSArray<AWRAppDeveloperViewModel *> *developers;
@property (strong, nonatomic) NSArray<AWRAppInfoViewModel *> *appLinks;

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
    self.aboutView.delegate = self;
}

- (void)backButtonPressed {
    if (!self.delegate) return;

    [self.delegate userDidCloseAbout];
}

- (NSArray<AWRLicenseViewModel *> *)thirdPartyLibs {
    if (!_thirdPartyLibs) {
        NSString *acknowledgementsPlist = [[NSBundle mainBundle]
                                           pathForResource:@"Acknowledgements"
                                           ofType:@"plist"];
        NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:acknowledgementsPlist];
        NSDictionary *licenses = [root objectForKey:@"Licenses"];
        NSMutableArray<AWRLicenseViewModel *> *licenseArray = [[NSMutableArray alloc] initWithCapacity:licenses.count];
        for (NSString *key in licenses) {
            AWRLicenseViewModel *l = [[AWRLicenseViewModel alloc] init];
            l.name = key;
            l.text = [licenses objectForKey:key];
            [licenseArray addObject:l];
        }

        _thirdPartyLibs = [licenseArray mutableCopy];
    }
    return _thirdPartyLibs;
}

- (NSArray<AWRAppInfoViewModel *> *)appLinks {
    if (!_appLinks) {
        _appLinks = [AWRAppInfoViewModel all];
    }
    return _appLinks;
}

- (NSArray<AWRAppDeveloperViewModel *> *)developers {
    if (!_developers) {
        _developers = [AWRAppDeveloperViewModel all];
    }
    return _developers;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.developers count];
    }

    if (section == 1) {
        return [self.appLinks count];
    }

    return [self.thirdPartyLibs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return
        (section == 0) ? @"Equipe"
      : (section == 1) ? @"Endereços"
      : @"Licenças de terceiros";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        AWRAppDeveloperViewModel *dev = self.developers[indexPath.row];
        AWRDeveloperInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"developerCell" forIndexPath:indexPath];
        cell.nameLabel.text = dev.name;
        cell.detailsFirstLineLabel.text = dev.details;
        cell.detailsSecondLineLabel.text = dev.moreDetails;
        return cell;
    }

    if (indexPath.section == 1) {
        AWRAppInfoViewModel *link = self.appLinks[indexPath.row];
        AWRAppLinkInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appLinkCell" forIndexPath:indexPath];
        cell.nameLabel.text = link.name;
        cell.detailsOnlyLineLabel.text = link.details;
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [self.thirdPartyLibs objectAtIndex:indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.delegate) return;

    if (indexPath.section == 0) {
        [self.delegate userDidSelectUrl: self.developers[indexPath.row].url];
        return;
    }

    if (indexPath.section == 1) {
        [self.delegate userDidSelectUrl: self.appLinks[indexPath.row].url];
        return;
    }

    [self.delegate userDidSelectLicense:self.thirdPartyLibs[indexPath.row]];
}

@end
