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
        configuration.clientKey = PARSE_CLIENT_KEY;
        configuration.server = PARSE_URL;
    }]];
}

+ (UIImage *)defaultAlbumArt {
    return [UIImage imageNamed:@"arcanos_transparent_big"];
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
        return [NSError errorWithDomain:@"Error on Parse Metadata Store: song is not a PFObject" code:0 userInfo:nil];
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
        return [NSError errorWithDomain:@"Error on Parse Metadata Store: song is not a PFObject" code:0 userInfo:nil];
    }
    AWRSongParse *songParse = (AWRSongParse *)song;
    return [self fetchTextFile:songParse.lyrics];
}

- (id<PXPromise>)descriptionForArtist:(id<AWRArtist>)artist locale:(NSString *)locale {
    if (![artist isKindOfClass:AWRArtistParse.class]) {
        return [NSError errorWithDomain:@"Error on Parse Metadata Store: artist is not a PFObject" code:0 userInfo:nil];
    }
    AWRArtistParse *artistParse = (AWRArtistParse *)artist;
    PFFile *file = [artistParse.localizedDescription objectForKey:locale];
    if (!file) {
        return [[PXPromiseResult alloc] initWithValue:nil];
    }

    return [self fetchTextFile:file];
}

- (id<PXPromise>)descriptionForSong:(id<AWRSong>)song locale:(NSString *)locale {
    if (![song isKindOfClass:AWRSongParse.class]) {
        return [NSError errorWithDomain:@"Error on Parse Metadata Store: song is not a PFObject" code:0 userInfo:nil];
    }
    AWRSongParse *songParse = (AWRSongParse *)song;
    PFFile *file = [songParse.localizedDescription objectForKey:locale];
    if (!file) {
        return [[PXPromiseResult alloc] initWithValue:nil];
    }

    return [self fetchTextFile:file];
}

- (id<PXPromise>)fetchTextFile:(PFFile *)file {
    return [file getDataInBackground]
        .then(^id<PXPromise>(id<PXSuccessfulPromise> finishedPromise) {
            NSData *data = finishedPromise.result;
            NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            return text;
        });
}

- (void)refreshConfig {
    [PFConfig getConfig];
}

- (id)readConfig:(NSString *)configKey {
    return [[PFConfig currentConfig] objectForKey:configKey];
}

@end
