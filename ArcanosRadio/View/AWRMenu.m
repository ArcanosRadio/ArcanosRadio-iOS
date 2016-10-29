#import "AWRMenu.h"
#import "UIView+Utils.h"
#import "AWRMenuPanGestureRecognizer.h"

#define FIRST_INNER_CIRCLE_RADIUS   75
#define DISTACE_BETWEEN_CIRCLES     75

@implementation AWRMenuItem

+ (instancetype)itemWithIdentifier:(NSString *)identifier icon:(UIImage *)icon text:(NSString *)text {
    AWRMenuItem *item = [[AWRMenuItem alloc] init];
    item.identifier = identifier;
    item.icon = icon;
    item.text = text;
    return item;
}

@end

@interface AWRMenu()

@property (nonatomic) BOOL shown;
@property (nonatomic, strong) NSArray<UIButton *> *menuItemButtons;
@property (nonatomic) CGPoint startingPoint;
@property (nonatomic, strong) UILabel *helpLabel;
@property (nonatomic, strong) UIView *overlay;

@end

@implementation AWRMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.startingPoint = CGPointMake(frame.origin.x + frame.size.width - 44 / 2 - 8,
                                         frame.origin.y + frame.size.height - 44 / 2 - 8);
        self.clipsToBounds = NO;
    }
    return self;
}

- (UIView *)overlay {
    if (!_overlay) {
        _overlay = [[UIView alloc] initWithFrame:self.frame];
        _overlay.layer.zPosition = 10;
        [self addSubview:_overlay];
        [_overlay fillSuperview];

        AWRMenuPanGestureRecognizer *gesture = [[AWRMenuPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_overlay addGestureRecognizer:gesture];
    }
    return _overlay;
}

- (UILabel *)helpLabel {
    if (!_helpLabel) {
        _helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 30)];
        _helpLabel.alpha = 0.0;
        _helpLabel.textAlignment = NSTextAlignmentCenter;
        _helpLabel.backgroundColor = UIColor.darkGrayColor;
        _helpLabel.font = [UIFont preferredFontForTextStyle: UIFontTextStyleCaption1];
        _helpLabel.textColor = [UIColor whiteColor];
        [self addSubview:_helpLabel];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_helpLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                                  toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:20];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_helpLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                                   toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_helpLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                                                    toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];

        [self addConstraints:@[top, left, right]];
    }
    return _helpLabel;
}

- (void)setItems:(NSArray<AWRMenuItem *> *)items {
    if (self.shown) {
        return;
    }
    _items = items;
    if (_menuItemButtons) {
        for (UIButton *button in _menuItemButtons) {
            [button removeTarget:nil
                          action:NULL
                forControlEvents:UIControlEventAllEvents];
            [button removeFromSuperview];
        }
        _menuItemButtons = nil;
    }
}

- (NSArray<UIView *> *)menuItemButtons {
    if (!_menuItemButtons) {
        NSMutableArray *subviews = [[NSMutableArray alloc] initWithCapacity:self.items.count];
        for (AWRMenuItem *item in self.items) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.startingPoint.x - 22, self.startingPoint.y - 22, 44, 44)];
            button.layer.cornerRadius = 22;
            button.alpha = 0.0;
            button.tag = [self.items indexOfObject:item];
            button.accessibilityLabel = item.text;
            button.backgroundColor = UIColor.darkGrayColor;
            button.tintColor = UIColor.whiteColor;
            [button setImage:item.icon forState:UIControlStateNormal];
            [subviews addObject:button];
            [self addSubview:button];
        }
        _menuItemButtons = subviews;
    }
    return _menuItemButtons;
}

- (UIButton *)buttonForPoint:(CGPoint)point {
    UIButton *found = nil;
    for (UIButton *button in _menuItemButtons) {
        if (point.x >= button.frame.origin.x &&
            point.x <= button.frame.origin.x + button.frame.size.width &&
            point.y >= button.frame.origin.y &&
            point.y <= button.frame.origin.y + button.frame.size.height) {
            button.backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0];
            found = button;
        } else {
            button.backgroundColor = UIColor.darkGrayColor;
        }
    }

    return found;
}

- (void)pan:(AWRMenuPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];

    if (gesture.state == UIGestureRecognizerStateBegan
        || gesture.state == UIGestureRecognizerStateChanged) {

        UIButton *button = [self buttonForPoint:point];
        if (button) {
            AWRMenuItem *item = [self.items objectAtIndex:button.tag];
            self.helpLabel.text = item.text;
            self.helpLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0];
            return;
        }
        
        self.helpLabel.backgroundColor = UIColor.darkGrayColor;
        self.helpLabel.text = NSLocalizedString(@"MENU_SELECT_ITEM_TEXT", nil);
        return;
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        UIButton *button = [self buttonForPoint:point];
        if (button) {
            AWRMenuItem *item = [self.items objectAtIndex: button.tag];
            if (self.delegate) {
                [self.delegate menu:self didSelectItemWithIdentifier:item.identifier];
            }
            [self hide];
            return;
        }
        
        [self hide];
    }

}

- (void)show {
    self.helpLabel.backgroundColor = UIColor.darkGrayColor;
    self.helpLabel.text = NSLocalizedString(@"MENU_SELECT_ITEM_TEXT", nil);

    for (UIButton *button in self.menuItemButtons) {
        button.center = self.startingPoint;
        [self.overlay bringSubviewToFront:button];
    }

    [self.overlay bringSubviewToFront:self.helpLabel];
    [self layoutIfNeeded];

    [UIView animateWithDuration:0.3 animations: ^{
         [self updateButtonCenters];
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
         self.helpLabel.alpha = 0.9;
         [self layoutIfNeeded];
     } completion:^(BOOL finished) {
         if (finished) {
             self.shown = YES;
             if (self.delegate && [self.delegate respondsToSelector:@selector(menuDidBecomeVisible:)]) {
                 [self.delegate menuDidBecomeVisible:self];
             }
         }
     }];
}

- (void)updateButtonCenters {
    // This method was [STRONGLY] inspired by:
    // https://github.com/AdityaDeshmane/iOSCircularMenu
    // Only adapted for a different screen position

    /*
     Logic : Use parametric equations to set point along circumference of circle

     These formulae will give point(x,y) along circumference

     x = cx + r * cos(a)
     y = cy + r * sin(a)

     Where,
     r is the radius,
     cx,cy the origin,
     and a the angle from 0..2PI radians or 0..360 degrees.
     */

    //1st circle initialization
    int marginAngle             = 5; //5 degree space is kept to avoid touching button on extreme position to corner
    int totalAvailableDegrees   = 90 - marginAngle * 2; //Space left to fit button is 80
    int numberOfButtons         = 3; //first circle has 3 button along circumference
    int initialAngle            = 180;

    float incrementAngle    = totalAvailableDegrees/ (numberOfButtons - 1);//Available space is divided as per button count
    float currentAngle      = marginAngle + initialAngle;
    float circleRadius      = FIRST_INNER_CIRCLE_RADIUS;

    for (int i = 0; i < self.menuItemButtons.count; i++) {
        if (i == 3) { //2nd circle started
            numberOfButtons = 4;
            currentAngle    = marginAngle + initialAngle;
            incrementAngle  = totalAvailableDegrees/(numberOfButtons - 1);
            circleRadius    = FIRST_INNER_CIRCLE_RADIUS + DISTACE_BETWEEN_CIRCLES;
        } else if(i == 7) { //3rd circle started
            numberOfButtons = 5;
            currentAngle    = marginAngle + initialAngle;
            incrementAngle  = totalAvailableDegrees/(numberOfButtons - 1);
            circleRadius    = FIRST_INNER_CIRCLE_RADIUS + (DISTACE_BETWEEN_CIRCLES * 2);
        }

        CGPoint buttonCenter;
        buttonCenter.x   = self.startingPoint.x + cos(currentAngle * M_PI / 180) * circleRadius;
        buttonCenter.y   = self.startingPoint.y + sin(currentAngle * M_PI / 180) * circleRadius;
        UIButton *button = [_menuItemButtons objectAtIndex:i];
        button.center    = buttonCenter;
        button.alpha     = 1.0;
        currentAngle     += incrementAngle;
    }
}

- (void)hide {
    [self layoutIfNeeded];

    [UIView animateWithDuration:0.3
                     animations: ^{
                         for (UIButton *button in self.menuItemButtons) {
                             button.center = self.startingPoint;
                             button.alpha = 0.0;
                             self.backgroundColor = [UIColor clearColor];
                         }
                         self.helpLabel.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.shown = NO;
                             if (self.delegate && [self.delegate respondsToSelector:@selector(menuDidBecomeHidden:)]) {
                                 [self.delegate menuDidBecomeHidden:self];
                             }
                         }
                     }];
}

- (BOOL)toggle {
    if(self.shown) {
        [self hide];
    } else {
        [self show];
    }

    return self.shown;
}

@end
