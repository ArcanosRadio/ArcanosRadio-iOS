#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (UIImage *)convertToSquareWithSideLength:(float)sideLength {
    return [self convertToSize:CGSizeMake(sideLength, sideLength)];
}

@end
