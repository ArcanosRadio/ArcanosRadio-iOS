#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface AWRAvatarImageView : UIImageView

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
