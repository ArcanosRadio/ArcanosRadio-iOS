#import <Foundation/Foundation.h>
#import "AWRSong.h"
#import "AWREntityVO.h"

@interface AWRSongVO : AWREntityVO<AWRSong>

@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) id<AWRArtist> artist;
@property (nonatomic, strong) id<AWRFile> albumArt;
@property (nonatomic, strong) id<AWRFile> lyrics;
@property (nonatomic, strong) NSArray<NSString *> *tags;

@end
