#import "AWRColorToolkit.h"

@implementation AWRColorToolkit

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

+ (void)initialize
{
    if (self == [AWRColorToolkit class])
    {
        _backgroundPrimaryColor = [UIColor colorWithRed:0.0161213 green:0.157977 blue:0.222895 alpha:1.0];
        _backgroundSecundaryColor = [UIColor whiteColor];
        _headerTextPrimaryColor = [UIColor whiteColor];
        _headerTextSecundaryColor = [UIColor whiteColor];
        _bodyTextPrimaryColor = [UIColor whiteColor];
        _bodyTextSecundaryColor = [UIColor whiteColor];
        _extraHighlightBackgroundColor = [UIColor colorWithRed:254./255. green:208./255. blue:49./255. alpha:1.0];
        _extraHighlightTextColor = [UIColor whiteColor];
        _disabledBackgroundColor = [UIColor whiteColor];
        _disabledTextColor = [UIColor whiteColor];
        _infoBackgroundColor = [UIColor whiteColor];
        _infoTextColor = [UIColor whiteColor];
        _warningBackgroundColor = [UIColor whiteColor];
        _warningTextColor = [UIColor whiteColor];
        _errorBackgroundColor = [UIColor whiteColor];
        _errorTextColor = [UIColor whiteColor];

    }
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

@end
