#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AWRHelpCoordinator;

@protocol AWRHelpCoordinatorDelegate

- (void)coordinator:(AWRHelpCoordinator *)coordinator didFinishExecutingItsMainController:(UIViewController *)controller;

@end

@interface AWRHelpCoordinator : NSObject

@property (nonatomic, weak) id<AWRHelpCoordinatorDelegate> delegate;

- (UIViewController *)start;

@end
