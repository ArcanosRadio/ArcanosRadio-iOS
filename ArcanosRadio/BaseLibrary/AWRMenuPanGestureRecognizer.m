#import "AWRMenuPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation AWRMenuPanGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateBegan;
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateChanged;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateEnded;
}


@end
