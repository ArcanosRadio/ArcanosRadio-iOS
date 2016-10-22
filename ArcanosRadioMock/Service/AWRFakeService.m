#import "AWRFakeService.h"
#import "AWRSong.h"
#import "AWRArtist.h"
#import "AWRPlaylist.h"

@interface AWRFakeService()

@property (class, nonatomic, readonly) NSArray<id<AWRSong>> *songs;

@end

@implementation AWRFakeService

static NSArray *_songs;

+ (NSArray<id<AWRSong>> *)songs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _songs = @[];
    });
    return _songs;
}

+ (void)configure {
}

- (id<PXPromise>)currentSong {
    return nil;
}

- (id<PXPromise>)artistByName:(NSString *)name {
    return nil;
}

- (id<PXPromise>)artistByTag:(NSString *)tag {
    return nil;
}

- (id<PXPromise>)songByName:(NSString *)name {
    return nil;
}

- (id<PXPromise>)songByTag:(NSString *)tag {
    return nil;
}

- (id<PXPromise>)albumArtBySong:(id<AWRSong>)song {
    return nil;
}

- (id<PXPromise>)lyricsBySong:(id<AWRSong>)song {
    return nil;
}

@end
