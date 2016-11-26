#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AWRArtistParse.h"
#import "AWRFile.h"
#import "PFFile+AWRFile.h"
#import "AWRSong.h"

@interface AWRSongParse : PFObject<PFSubclassing, AWRSong>

@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) AWRArtistParse *artist;
@property (nonatomic, strong) PFFile *albumArt;
@property (nonatomic, strong) PFFile *lyrics;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic) BOOL hasRightsContract;
@property (nonatomic, strong) NSString *spotifyTrackId;
@property (nonatomic, strong) NSString *spotifyAlbumId;

+ (NSString *)parseClassName;

@end
