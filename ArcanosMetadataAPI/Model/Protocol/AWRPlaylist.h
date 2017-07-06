#import <Foundation/Foundation.h>
#import "AWRSong.h"
#import "AWREntity.h"

@protocol AWRPlaylist <NSObject, AWREntity>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id<AWRSong> song;

@end
