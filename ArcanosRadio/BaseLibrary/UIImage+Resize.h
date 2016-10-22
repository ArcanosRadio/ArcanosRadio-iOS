#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)convertToSize:(CGSize)size;
- (UIImage *)convertToSquareWithSideLength:(float)sideLength;

@end
