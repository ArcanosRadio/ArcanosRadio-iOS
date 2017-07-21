#import "AWREntity.h"
#import "AWRSong.h"
#import <Foundation/Foundation.h>

@protocol AWRPlaylist <NSObject, AWREntity>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id<AWRSong> song;

@end
