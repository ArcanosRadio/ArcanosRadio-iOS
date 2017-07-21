#import "AWRAboutController.h"
#import "AWRAboutView.h"
#import "AWRAppDeveloperViewState.h"
#import "AWRAppInfoViewState.h"
#import "AWRAppLinkInfoTableViewCell.h"
#import "AWRDeveloperInfoTableViewCell.h"
#import "AWRVersionTableViewCell.h"

@interface AWRAboutController () <AWRAboutViewDelegate, UITableViewDataSource>

@property (readonly, nonatomic) AWRAboutView *aboutView;
@property (strong, nonatomic) NSArray<AWRLicenseViewState *> *thirdPartyLibs;
@property (strong, nonatomic) NSArray<AWRAppDeveloperViewState *> *developers;
@property (strong, nonatomic) NSArray<AWRAppInfoViewState *> *appLinks;

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

- (NSArray<AWRLicenseViewState *> *)thirdPartyLibs {
    if (!_thirdPartyLibs) {
        NSString *acknowledgementsPlist                     = [[NSBundle mainBundle] pathForResource:@"Acknowledgements" ofType:@"plist"];
        NSDictionary *root                                  = [[NSDictionary alloc] initWithContentsOfFile:acknowledgementsPlist];
        NSDictionary *licenses                              = [root objectForKey:@"Licenses"];
        NSMutableArray<AWRLicenseViewState *> *licenseArray = [[NSMutableArray alloc] initWithCapacity:licenses.count];
        for (NSString *key in licenses) {
            AWRLicenseViewState *l = [[AWRLicenseViewState alloc] init];
            l.name                 = key;
            l.text                 = [licenses objectForKey:key];
            [licenseArray addObject:l];
        }

        _thirdPartyLibs = [licenseArray mutableCopy];
    }
    return _thirdPartyLibs;
}

- (NSArray<AWRAppInfoViewState *> *)appLinks {
    if (!_appLinks) {
        _appLinks = [AWRAppInfoViewState all];
    }
    return _appLinks;
}

- (NSArray<AWRAppDeveloperViewState *> *)developers {
    if (!_developers) {
        _developers = [AWRAppDeveloperViewState all];
    }
    return _developers;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }

    if (section == 1) {
        return [self.developers count];
    }

    if (section == 2) {
        return [self.appLinks count];
    }

    return [self.thirdPartyLibs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? nil
                          : (section == 1) ? NSLocalizedString(@"ABOUT_TEAM_HEADER", nil)
                                           : (section == 2) ? NSLocalizedString(@"ABOUT_LINKS_HEADER", nil)
                                                            : NSLocalizedString(@"ABOUT_THIRD_PARTY_HEADER", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AWRVersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appVersionCell" forIndexPath:indexPath];

        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build   = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

        cell.appNameLabel.text   = NSLocalizedString(@"ABOUT_ARCANOS", nil);
        cell.copyrightLabel.text = NSLocalizedString(@"ABOUT_COPYRIGHT", nil);
        cell.versionLabel.text   = [NSString stringWithFormat:@"%@ (%@)", version, build];
        return cell;
    }

    if (indexPath.section == 1) {
        AWRAppDeveloperViewState *dev       = self.developers[indexPath.row];
        AWRDeveloperInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"developerCell" forIndexPath:indexPath];
        cell.nameLabel.text                 = dev.name;
        cell.detailsFirstLineLabel.text     = dev.details;
        cell.detailsSecondLineLabel.text    = dev.moreDetails;
        return cell;
    }

    if (indexPath.section == 2) {
        AWRAppInfoViewState *link         = self.appLinks[indexPath.row];
        AWRAppLinkInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appLinkCell" forIndexPath:indexPath];
        cell.nameLabel.text               = link.name;
        cell.detailsOnlyLineLabel.text    = link.details;
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = [self.thirdPartyLibs objectAtIndex:indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.delegate) return;

    if (indexPath.section == 0) {
        return;
    }

    if (indexPath.section == 1) {
        [self.delegate userDidSelectUrl:self.developers[indexPath.row].url];
        return;
    }

    if (indexPath.section == 2) {
        [self.delegate userDidSelectUrl:self.appLinks[indexPath.row].url];
        return;
    }

    [self.delegate userDidSelectLicense:self.thirdPartyLibs[indexPath.row]];
}

@end
