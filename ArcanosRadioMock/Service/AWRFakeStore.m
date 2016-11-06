#import "AWRFakeStore.h"
#import "AWRSongVO.h"
#import "AWRArtistVO.h"
#import "AWRPlaylistVO.h"
#import "PXPromise.h"
#import "AWRFileVO.h"
#import "AWRSongViewModel.h"
#import <UIKit/UIKit.h>
#import <SimulatorStatusMagiciOS/SimulatorStatusMagiciOS.h>

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SDStatusBarManager sharedInstance] enableOverrides];
    });
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

    AWRSongViewModel *huntingHighAndLow = [[AWRSongViewModel alloc] init];
    huntingHighAndLow.songName = @"Hunting High And Low";
    huntingHighAndLow.artistName = @"Stratovarius";
    huntingHighAndLow.lyrics = @"I feel the wind in my hair\n\
And it's whispering, telling me things\n\
Of a storm that is gathering near\n\
Full of power I'm spreading my wings\n\
\n\
Now I'm leaving my worries behind\n\
Feel the freedom of body and mind\n\
I'm starting my journey, I'm drifting away with the wind, I go\n\
\n\
I am Hunting High and Low\n\
Diving from the sky above\n\
Looking for, more and more, once again\n\
I'm Hunting High and Low\n\
Sometimes I may win, sometimes I'll lose\n\
It's just a game that I play\n\
\n\
After the storm there's a calm\n\
Through the clouds shines a ray of the sun\n\
I'm carried from all my harm\n\
There is no one I can't outrun\n\
\n\
Now I'm leaving my worries behind\n\
Feel the freedom of body and mind\n\
I'm starting my journey, I'm drifting away with the wind, I go\n\
\n\
I am Hunting High and Low\n\
Diving from the sky above\n\
Looking for, more and more, once again\n\
I'm Hunting High and Low\n\
Sometimes I may win sometimes I lose\n\
It's just a game that I play\n\
\n\
I am Hunting High and Low\n\
Diving from the sky above\n\
Looking for, more and more, once again\n\
I'm Hunting High and Low\n\
Sometimes I may win sometimes I lose\n\
It's just a game that I play";
    huntingHighAndLow.albumArtAssetName = @"hunting_high_and_low";
    huntingHighAndLow.updatedAt = self.referenceDate;

    AWRSongViewModel *ironMan = [[AWRSongViewModel alloc] init];
    ironMan.songName = @"Iron Man";
    ironMan.artistName = @"Black Sabbath";
    ironMan.lyrics = @"Has he lost his mind?\n\
Can he see or is he blind?\n\
Can he walk at all\n\
Or if he moves will he fall?\n\
Is he alive or dead?\n\
Has he thoughts within his head?\n\
We'll just pass him there\n\
Why should we even care?\n\
\n\
He was turned to steel\n\
In the great magnetic field\n\
When he travelled time\n\
For the future of mankind\n\
\n\
Nobody wants him\n\
He just stares at the world\n\
Planning his vengeance\n\
That he will soon unfurl\n\
\n\
Now the time is here\n\
For iron man to spread fear\n\
Vengeance from the grave\n\
Kills the people he once saved\n\
\n\
Nobody wants him\n\
They just turn their heads\n\
Nobody helps him\n\
Now he has his revenge\n\
\n\
Heavy boots of lead\n\
Fills his victims full of dread\n\
Running as fast as they can\n\
Iron man lives again!";
    ironMan.albumArtAssetName = @"iron_man";
    ironMan.updatedAt = self.referenceDate;

    return @[bornToBeWild, huntingHighAndLow, ironMan];
}

@end
