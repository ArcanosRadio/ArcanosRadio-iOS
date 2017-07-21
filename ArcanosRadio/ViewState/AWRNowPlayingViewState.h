#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AWRNowPlayingViewState : NSObject

@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *lyrics;
@property (nonatomic) BOOL hasUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *albumArt;

@end
