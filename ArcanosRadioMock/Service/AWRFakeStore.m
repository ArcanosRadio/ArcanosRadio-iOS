#import "AWRFakeStore.h"
#import "AWRSongVO.h"
#import "AWRArtistVO.h"
#import "AWRPlaylistVO.h"
#import "PXPromise.h"
#import "AWRFileVO.h"
#import "AWRSongViewModel.h"
#import <UIKit/UIKit.h>

@interface AWRFakeStore()

@property (nonatomic) int songIndex;
@property (nonatomic, strong) NSDate *referenceDate;

@end

@implementation AWRFakeStore

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
    song.songName = [self listSongs][self.songIndex].songName;
    song.artist = [self defaultArtist];
    song.albumArt = [self defaultFile];
    song.lyrics = [self defaultFile];
    song.tags = @[];
    return song;
}

- (AWRArtistVO *)defaultArtist {
    AWRArtistVO *artist = [[AWRArtistVO alloc] init];
    artist.artistName = [self listSongs][self.songIndex].artistName;
    artist.url = nil;
    artist.text = nil;
    artist.tags = @[];
    return artist;
}

- (AWRPlaylistVO *)defaultPlaylist {
    AWRPlaylistVO *playlist = [[AWRPlaylistVO alloc] init];
    playlist.title = [NSString stringWithFormat:@"%@ - %@",
                      [self listSongs][self.songIndex].artistName,
                      [self listSongs][self.songIndex].songName];
    playlist.song = [self defaultSong];
    playlist.updatedAt = [self listSongs][self.songIndex].updatedAt;
    return playlist;
}

- (NSData *)defaultAlbumArt {
    UIImage *art = [UIImage imageNamed:[self listSongs][self.songIndex].albumArtAssetName];
    return UIImageJPEGRepresentation(art, 1);
}

- (NSString *)defaultLyrics {
    return [self listSongs][self.songIndex].lyrics;
}

- (id<PXPromise>)currentSong {
    if (!self.referenceDate) {
        self.referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:60];
    }

    self.referenceDate = [self.referenceDate dateByAddingTimeInterval:10];

    self.songIndex++;
    if (self.songIndex >= [self listSongs].count) {
        self.songIndex = 0;
    }
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
             @"iphoneStreamingUrl": @"",
             @"iphonePoolingTimeActive": @(6),
             @"iphonePoolingTimeBackground": @(100),
             @"iphoneShareUrl": @"arcanosmc.com.br"
      }[configKey];
}

- (NSArray<AWRSongViewModel *> *)listSongs {
    AWRSongViewModel *bornToBeWild = [[AWRSongViewModel alloc] init];
    bornToBeWild.songName = @"Born To Be Wild";
    bornToBeWild.artistName = @"Steppenwolf";
    bornToBeWild.lyrics =  @"Get your motor runnin'\n\
Head out on the highway\n\
Looking for adventure\n\
In whatever comes our way\n\
\n\
Yeah, darlin'\n\
Gonna make it happen\n\
Take the world in a love embrace\n\
Fire all of your guns at once\n\
And explode into space\n\
\n\
I like smoke and lightnin'\n\
Heavy Metal thunder\n\
Racing in the wind\n\
And the feeling that I'm under\n\
\n\
Yeah, darlin'\n\
Gonna make it happen\n\
Take the world in a love embrace\n\
Fire all of your guns at once\n\
And explode into space\n\
\n\
Like a true nature's child\n\
We were born\n\
Born to be wild\n\
We can climb so high\n\
I never wanna die\n\
\n\
Born to be wild\n\
Born to be wild\n\
\n\
Get your motor runnin'\n\
Head out on the highway\n\
Looking for adventure\n\
In whatever comes our way\n\
\n\
Yeah, darlin'\n\
Gonna make it happen\n\
Take the world in a love embrace\n\
Fire all of your guns at once\n\
And explode into space\n\
\n\
Like a true natures child\n\
We were born\n\
Born to be wild\n\
We can climb so high\n\
I never wanna die\n\
\n\
Born to be wild\n\
Born to be wild";
    bornToBeWild.albumArtAssetName = @"born_to_be_wild";
    bornToBeWild.updatedAt = self.referenceDate;

    AWRSongViewModel *ironMan = [[AWRSongViewModel alloc] init];
    ironMan.songName = @"Iron Man";
    ironMan.artistName = @"Black Sabbath";
    ironMan.lyrics = @"";
    ironMan.albumArtAssetName = @"born_to_be_wild";
    ironMan.updatedAt = self.referenceDate;

    return @[bornToBeWild, ironMan];
}

@end
