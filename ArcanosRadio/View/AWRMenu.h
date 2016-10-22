#import <UIKit/UIKit.h>

@class AWRMenu;

@protocol AWRMenuDelegate

- (void)menu:(AWRMenu *)menu didSelectItemWithIdentifier:(NSString *)identifier;

@optional
- (void)menuDidBecomeVisible:(AWRMenu *)menu;
- (void)menuDidBecomeHidden:(AWRMenu *)menu;

@end

@interface AWRMenuItem : NSObject

+ (instancetype)itemWithIdentifier:(NSString *)identifier icon:(UIImage *)icon text:(NSString *)text;

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *text;

@end

@interface AWRMenu : UIView

@property(nonatomic, weak) NSObject<AWRMenuDelegate> *delegate;
@property(nonatomic, strong) NSArray<AWRMenuItem *> *items;

- (void)show;
- (void)hide;
- (BOOL)toggle;

@end
