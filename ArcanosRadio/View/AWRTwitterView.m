#import "AWRTwitterView.h"
#import <TwitterKit/TwitterKit.h>
#import "AWRColorToolkit.h"

@implementation AWRTwitterView

- (void)configureView {
    [TWTRTweetView appearance].theme = TWTRTweetViewThemeDark;
    [TWTRTweetView appearance].backgroundColor = [AWRColorToolkit backgroundPrimaryColor];
    self.backgroundColor = [AWRColorToolkit backgroundPrimaryColor];
}

@end
