#import <Foundation/Foundation.h>
#import "PXPromise.h"
#import "AWRSong.h"
#import <UIKit/UIKit.h>

@protocol AWRMetadataStore

- (id<PXPromise>)currentSong;
- (id<PXPromise>)artistByName:(NSString *)name;
- (id<PXPromise>)artistByTag:(NSString *)tag;
- (id<PXPromise>)songByName:(NSString *)name;
- (id<PXPromise>)songByTag:(NSString *)tag;
- (id<PXPromise>)albumArtBySong:(id<AWRSong>)song;
- (id<PXPromise>)lyricsBySong:(id<AWRSong>)song;
- (void)refreshConfig;
- (id)readConfig:(NSString *)configKey;
+ (UIImage *)defaultAlbumArt;
@end
