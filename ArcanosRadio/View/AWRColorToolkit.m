#import "AWRColorToolkit.h"

@implementation AWRColorToolkit

static UIColor *_toolbarBackgroundColor;
static UIColor *_toolbarForegroundColor;
static UIColor *_backgroundPrimaryColor;
static UIColor *_backgroundSecundaryColor;
static UIColor *_headerTextPrimaryColor;
static UIColor *_headerTextSecundaryColor;
static UIColor *_bodyTextPrimaryColor;
static UIColor *_bodyTextSecundaryColor;
static UIColor *_extraHighlightBackgroundColor;
static UIColor *_extraHighlightTextColor;
static UIColor *_disabledBackgroundColor;
static UIColor *_disabledTextColor;
static UIColor *_infoBackgroundColor;
static UIColor *_infoTextColor;
static UIColor *_warningBackgroundColor;
static UIColor *_warningTextColor;
static UIColor *_errorBackgroundColor;
static UIColor *_errorTextColor;
static UIColor *_noColor;
static UIColor *_highlightStrokeColor;
static UIColor *_shadowColor;

+ (void)initialize {
    if (self == [AWRColorToolkit class]) {
        _toolbarBackgroundColor        = [UIColor colorWithRed:23.0 / 255.0 green:55.0 / 255.0 blue:68.0 / 255.0 alpha:1.0];
        _toolbarForegroundColor        = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _backgroundPrimaryColor        = [UIColor colorWithRed:0.0161213 green:0.157977 blue:0.222895 alpha:1.0];
        _backgroundSecundaryColor      = [UIColor whiteColor];
        _headerTextPrimaryColor        = [UIColor whiteColor];
        _headerTextSecundaryColor      = [UIColor whiteColor];
        _bodyTextPrimaryColor          = [UIColor whiteColor];
        _bodyTextSecundaryColor        = [UIColor whiteColor];
        _extraHighlightBackgroundColor = [UIColor whiteColor];
        _extraHighlightTextColor       = [UIColor colorWithRed:254. / 255. green:208. / 255. blue:49. / 255. alpha:1.0];
        _disabledBackgroundColor       = [UIColor lightGrayColor];
        _disabledTextColor             = [UIColor darkGrayColor];
        _infoBackgroundColor           = [UIColor whiteColor];
        _infoTextColor                 = [UIColor whiteColor];
        _warningBackgroundColor        = [UIColor whiteColor];
        _warningTextColor              = [UIColor whiteColor];
        _errorBackgroundColor          = [UIColor whiteColor];
        _errorTextColor                = [UIColor whiteColor];
        _noColor                       = [UIColor clearColor];
        _highlightStrokeColor          = [UIColor colorWithRed:0.5 green:0.5 blue:0.1 alpha:0.9];
        _shadowColor                   = [UIColor blackColor];
    }
}

+ (UIColor *)toolbarBackgroundColor {
    return _toolbarBackgroundColor;
}

+ (UIColor *)toolbarForegroundColor {
    return _toolbarForegroundColor;
}

+ (UIColor *)backgroundPrimaryColor {
    return _backgroundPrimaryColor;
}

+ (UIColor *)backgroundSecundaryColor {
    return _backgroundSecundaryColor;
}

+ (UIColor *)headerTextPrimaryColor {
    return _headerTextPrimaryColor;
}

+ (UIColor *)headerTextSecundaryColor {
    return _headerTextSecundaryColor;
}

+ (UIColor *)bodyTextPrimaryColor {
    return _bodyTextPrimaryColor;
}

+ (UIColor *)bodyTextSecundaryColor {
    return _bodyTextSecundaryColor;
}

+ (UIColor *)extraHighlightBackgroundColor {
    return _extraHighlightBackgroundColor;
}

+ (UIColor *)extraHighlightTextColor {
    return _extraHighlightTextColor;
}

+ (UIColor *)disabledBackgroundColor {
    return _disabledBackgroundColor;
}

+ (UIColor *)disabledTextColor {
    return _disabledTextColor;
}

+ (UIColor *)infoBackgroundColor {
    return _infoBackgroundColor;
}

+ (UIColor *)infoTextColor {
    return _infoTextColor;
}

+ (UIColor *)warningBackgroundColor {
    return _warningBackgroundColor;
}

+ (UIColor *)warningTextColor {
    return _warningTextColor;
}

+ (UIColor *)errorBackgroundColor {
    return _errorBackgroundColor;
}

+ (UIColor *)errorTextColor {
    return _errorTextColor;
}

+ (UIColor *)highlightStrokeColor {
    return _highlightStrokeColor;
}

+ (UIColor *)noColor {
    return _noColor;
}

+ (UIColor *)shadowColor {
    return _shadowColor;
}

@end
