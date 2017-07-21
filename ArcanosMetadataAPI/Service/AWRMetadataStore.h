#import "AWRArtist.h"
#import "AWRSong.h"
#import <Foundation/Foundation.h>
#import <IOZPromise/IOZPromise.h>
#import <UIKit/UIKit.h>

@protocol AWRMetadataStore

- (id<IOZPromise>)currentSong;
- (id<IOZPromise>)artistByName:(NSString *)name;
- (id<IOZPromise>)artistByTag:(NSString *)tag;
- (id<IOZPromise>)songByName:(NSString *)name;
- (id<IOZPromise>)songByTag:(NSString *)tag;
- (id<IOZPromise>)albumArtBySong:(id<AWRSong>)song;
- (id<IOZPromise>)lyricsBySong:(id<AWRSong>)song;
- (id<IOZPromise>)descriptionForArtist:(id<AWRArtist>)artist locale:(NSString *)locale;
- (id<IOZPromise>)descriptionForSong:(id<AWRSong>)song locale:(NSString *)locale;
- (void)refreshConfig;
- (id)readConfig:(NSString *)configKey;
+ (UIImage *)defaultAlbumArt;
@end
