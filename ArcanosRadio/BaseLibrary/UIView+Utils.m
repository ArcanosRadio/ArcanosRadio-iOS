#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)fillSuperview {
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    [self anchorToTheTop];
    [self.superview addConstraints:@[ bottom ]];
}

- (void)anchorToTheTop {
    self.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.superview
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.superview
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.superview
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:0];

    [self.superview addConstraints:@[ top, left, right ]];
}

@end
