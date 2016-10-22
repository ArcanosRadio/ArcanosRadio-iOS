#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AWRNowPlayingViewModel : NSObject

@property(nonatomic, strong) NSString *songName;
@property(nonatomic, strong) NSString *artistName;
@property(nonatomic, strong) NSString *lyrics;
@property(nonatomic, strong) UIImage *albumArt;

@end
