#import "AWRTwitterView.h"
#import <TwitterKit/TwitterKit.h>
#import "AWRColorToolkit.h"

@implementation AWRTwitterView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self ) {
        [self configureView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [TWTRTweetView appearance].theme = TWTRTweetViewThemeDark;
    [TWTRTweetView appearance].backgroundColor = [AWRColorToolkit backgroundPrimaryColor];
}

@end
