#import "AWRParseMetadataStore.h"
#import <Parse/Parse.h>
#import "AWRSongParse.h"
#import "AWRArtistParse.h"
#import "AWRPlaylistParse.h"

@interface AWRParseMetadataStore()

@end

@implementation AWRParseMetadataStore

+ (void)configure {
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = PARSE_APP;
        configuration.server = PARSE_URL;
    }]];
}

- (id<PXPromise>)currentSong {
    PFQuery *query = [AWRPlaylistParse query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"song.artist"];
    [query setLimit:1];

    return [query getFirstObjectInBackground];
}

- (id<PXPromise>)artistByName:(NSString *)name {
    PFQuery *query = [AWRArtistParse query];
    [query whereKey:@"artistName" equalTo:name];
    [query setLimit:1];

    return [query getFirstObjectInBackground];
}

- (id<PXPromise>)artistByTag:(NSString *)tag {
    PFQuery *query = [AWRArtistParse query];
    [query whereKey:@"tags" containsAllObjectsInArray:@[tag]];
    [query setLimit:1];

    return [query getFirstObjectInBackground];
}

- (id<PXPromise>)songByName:(NSString *)name {
    PFQuery *query = [AWRSongParse query];
    [query whereKey:@"songName" equalTo:name];
    [query setLimit:1];

    return [query getFirstObjectInBackground];
}

- (id<PXPromise>)songByTag:(NSString *)tag {
    PFQuery *query = [AWRSongParse query];
    [query whereKey:@"tags" containsAllObjectsInArray:@[tag]];
    [query setLimit:1];

    return [query getFirstObjectInBackground];
}

- (id<PXPromise>)albumArtBySong:(id<AWRSong>)song {
    if (![song isKindOfClass:AWRSongParse.class]) {
        return nil;
    }
    AWRSongParse *songParse = (AWRSongParse *)song;
    return [songParse.albumArt getDataInBackground]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            NSData *imageData = finishedPromise.result;
            return imageData;
        });
}

- (id<PXPromise>)lyricsBySong:(id<AWRSong>)song {
    if (![song isKindOfClass:AWRSongParse.class]) {
        return nil;
    }
    AWRSongParse *songParse = (AWRSongParse *)song;
    return [songParse.lyrics getDataInBackground]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            NSData *lyricsData = finishedPromise.result;
            NSString *lyricsText = [[NSString alloc]initWithData:lyricsData encoding:NSUTF8StringEncoding];
            return lyricsText;
        });
}

@end
