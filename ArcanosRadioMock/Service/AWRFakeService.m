#import "AWRFakeService.h"
#import "AWRSongVO.h"
#import "AWRArtistVO.h"
#import "AWRPlaylistVO.h"
#import "PXPromise.h"
#import "AWRFileVO.h"

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

- (AWRFileVO *)defaultFile {
    AWRFileVO *file = [[AWRFileVO alloc] init];
    file.name = @"";
    file.url = @"";
    return file;
}

- (AWRSongVO *)defaultSong {
    AWRSongVO *song = [[AWRSongVO alloc] init];
    song.songName = @"Forbidden Light";
    song.artist = [self defaultArtist];
    song.albumArt = [self defaultFile];
    song.lyrics = [self defaultFile];
    song.tags = @[];
    return song;
}

- (AWRArtistVO *)defaultArtist {
    AWRArtistVO *artist = [[AWRArtistVO alloc] init];
    artist.artistName = @"Wolfenbach";
    artist.url = nil;
    artist.text = nil;
    artist.tags = @[];
    return artist;
}

- (AWRPlaylistVO *)defaultPlaylist {
    AWRPlaylistVO *playlist = [[AWRPlaylistVO alloc] init];
    playlist.title = @"Wolfenbach - Forbidden Light";
    playlist.song = [self defaultSong];
    playlist.updatedAt = [NSDate dateWithTimeIntervalSinceReferenceDate:60];
    return playlist;
}

- (NSData *)defaultAlbumArt {
    UIImage *art = [UIImage imageNamed:@"arcanos_transparent_big"];

    return UIImageJPEGRepresentation(art, 1);
}

- (NSString *)defaultLyrics {
    return @"For all that I've seen";
}

- (id<PXPromise>)currentSong {
    return [[PXPromiseResult alloc] initWithValue:[self defaultPlaylist]];
}

- (id<PXPromise>)artistByName:(NSString *)name {
    return [[PXPromiseResult alloc] initWithValue:[self defaultArtist]];
}

- (id<PXPromise>)artistByTag:(NSString *)tag {
    return [[PXPromiseResult alloc] initWithValue:[self defaultArtist]];
}

- (id<PXPromise>)songByName:(NSString *)name {
    return [[PXPromiseResult alloc] initWithValue:[self defaultSong]];
}

- (id<PXPromise>)songByTag:(NSString *)tag {
    return [[PXPromiseResult alloc] initWithValue:[self defaultSong]];
}

- (id<PXPromise>)albumArtBySong:(id<AWRSong>)song {
    return [[PXPromiseResult alloc] initWithValue:[self defaultAlbumArt]];
}

- (id<PXPromise>)lyricsBySong:(id<AWRSong>)song {
    return [[PXPromiseResult alloc] initWithValue:[self defaultLyrics]];
}

- (void)refreshConfig {
}

- (id)readConfig:(NSString *)configKey {
    return @{
             @"iphoneStreamingUrl": @"http://player.liderstreaming.com.br/player/16300/iphone.m3u",
             @"iphonePoolingTimeActive": @(10),
             @"iphonePoolingTimeBackground": @(100),
             @"iphoneShareUrl": @"arcanosmc.com.br"
      }[configKey];
}

@end
