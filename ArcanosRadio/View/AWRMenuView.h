#import <UIKit/UIKit.h>

@class AWRMenuView;

@protocol AWRMenuViewDelegate

- (void)menu:(AWRMenuView *)menu didSelectItemWithIdentifier:(NSString *)identifier;

@optional
- (void)menuDidBecomeVisible:(AWRMenuView *)menu;
- (void)menuDidBecomeHidden:(AWRMenuView *)menu;

@end

@interface AWRMenuViewItem : NSObject

+ (instancetype)itemWithIdentifier:(NSString *)identifier icon:(UIImage *)icon text:(NSString *)text;

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *text;

@end

@interface AWRMenuView : UIView

@property(nonatomic, weak) NSObject<AWRMenuViewDelegate> *delegate;
@property(nonatomic, strong) NSArray<AWRMenuViewItem *> *items;

- (void)show;
- (void)hide;
- (BOOL)toggle;

@end
