#import "AWRTwitterView.h"
#import "AWRColorToolkit.h"
#import <TwitterKit/TwitterKit.h>

@implementation AWRTwitterView

- (void)configureView {
    [TWTRTweetView appearance].theme           = TWTRTweetViewThemeDark;
    [TWTRTweetView appearance].backgroundColor = [AWRColorToolkit backgroundPrimaryColor];
    self.backgroundColor                       = [AWRColorToolkit backgroundPrimaryColor];
}

@end
