#import <Foundation/Foundation.h>
#import "PXPromise.h"
#import "AWRSong.h"

@protocol AWRMetadataStore

- (id<PXPromise>)currentSong;
- (id<PXPromise>)artistByName:(NSString *)name;
- (id<PXPromise>)artistByTag:(NSString *)tag;
- (id<PXPromise>)songByName:(NSString *)name;
- (id<PXPromise>)songByTag:(NSString *)tag;
- (id<PXPromise>)albumArtBySong:(id<AWRSong>)song;
- (id<PXPromise>)lyricsBySong:(id<AWRSong>)song;
- (id<PXPromise>)readConfig:(NSString *)configKey;

@end
