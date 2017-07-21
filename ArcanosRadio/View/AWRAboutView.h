#import <UIKit/UIKit.h>

@protocol AWRAboutViewDelegate

- (void)backButtonPressed;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface AWRAboutView : UIView

@property (nonatomic, weak) id<AWRAboutViewDelegate> delegate;

@end
