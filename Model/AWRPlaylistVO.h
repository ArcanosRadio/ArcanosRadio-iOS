#import <Foundation/Foundation.h>
#import "AWRPlaylist.h"
#import "AWREntityVO.h"

@interface AWRPlaylistVO : AWREntityVO<AWRPlaylist>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id<AWRSong> song;

@end
