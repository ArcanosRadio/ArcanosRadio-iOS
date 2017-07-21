#import "AWRCrashReportController.h"

@interface AWRCrashReportController ()

@property (nonatomic, weak) UIViewController *parent;

@end

@implementation AWRCrashReportController

- (instancetype)initWithParent:(UIViewController *)parent {
    self = [super init];
    if (self) {
        self.parent = parent;
    }
    return self;
}

- (void)sendReport:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler {
    BOOL reportCrash = [[NSUserDefaults standardUserDefaults] boolForKey:CONFIG_AGREE_WITH_CRASH_REPORTS_KEY];

    if (reportCrash) {
        completionHandler(YES);
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"CRASHREPORT_REQUEST_TITLE", nil)
                                                                       message:NSLocalizedString(@"CRASHREPORT_REQUEST_MESSAGE", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"CRASHREPORT_REQUEST_NEVER_SEND", nil)
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    completionHandler(NO);
                                                }]];

        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"CRASHREPORT_REQUEST_ALWAYS_SEND", nil)
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CONFIG_AGREE_WITH_CRASH_REPORTS_KEY];
                                                    completionHandler(YES);
                                                }]];

        [self.parent presentViewController:alert animated:YES completion:NULL];
    }
}

@end
