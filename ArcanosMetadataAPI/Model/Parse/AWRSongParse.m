#import "AWRSongParse.h"
#import <Parse/PFObject+Subclass.h>

@implementation AWRSongParse

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Song";
}

@dynamic songName, artist, albumArt, lyrics, tags, hasRightsContract, spotifyTrackId, spotifyAlbumId, localizedDescription;

@end
