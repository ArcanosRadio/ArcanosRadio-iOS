#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AWRColorToolkit : NSObject

+ (UIColor *)toolbarBackgroundColor;

+ (UIColor *)backgroundPrimaryColor;
+ (UIColor *)backgroundSecundaryColor;

+ (UIColor *)headerTextPrimaryColor;
+ (UIColor *)headerTextSecundaryColor;

+ (UIColor *)bodyTextPrimaryColor;
+ (UIColor *)bodyTextSecundaryColor;

+ (UIColor *)extraHighlightBackgroundColor;
+ (UIColor *)extraHighlightTextColor;

+ (UIColor *)disabledBackgroundColor;
+ (UIColor *)disabledTextColor;

+ (UIColor *)infoBackgroundColor;
+ (UIColor *)infoTextColor;

+ (UIColor *)warningBackgroundColor;
+ (UIColor *)warningTextColor;

+ (UIColor *)errorBackgroundColor;
+ (UIColor *)errorTextColor;

@end
