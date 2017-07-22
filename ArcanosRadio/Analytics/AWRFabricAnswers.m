#import "AWRFabricAnswers.h"
#import <Crashlytics/Crashlytics.h>

static NSString *const LAST_SONG       = @"LAST_SONG";
static NSString *const LAST_ARTIST     = @"LAST_ARTIST";
static NSString *const LAST_SONG_COUNT = @"LAST_SONG_COUNT";

@interface AWRFabricAnswers ()

@property (nonatomic) NSInteger songCount;

@end

@implementation AWRFabricAnswers

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *lastSong      = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SONG];
        NSString *lastArtist    = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_ARTIST];
        NSInteger lastSongCount = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SONG_COUNT];
        if (lastSong && lastArtist && lastSongCount) {
            [self trackUserLeavingWithSong:lastSong artist:lastArtist sessionSongCount:lastSongCount];
        }
    }
    return self;
}

- (void)trackMetric:(NSString *)metric withAttributes:(NSDictionary<NSString *, id> *)attributes {
    [Answers logCustomEventWithName:metric customAttributes:attributes];
}

- (void)trackTab:(nonnull NSString *)content forSong:(nonnull NSString *)song artist:(nonnull NSString *)artist {
    DLog(@"trackTab:forSong:artist: (%@,%@,%@)", content, song, artist);
    NSString *fullContent = [NSString stringWithFormat:@"%@ : %@ - %@", content, song, artist];
    [Answers logContentViewWithName:content
                        contentType:@"tab"
                          contentId:content
                   customAttributes:@{
                       @"Tab" : content,
                       @"Content" : fullContent
                   }];
}

- (void)trackListenSong:(NSString *)song artist:(NSString *)artist {
    self.songCount++;
    [self trackMetric:@"Listen" withAttributes:@{ @"Artist" : artist, @"Song" : song, @"Song Count" : @(self.songCount) }];
    DLog(@"trackListenSong:artist: (%@,%@,self.songCount=%ld)", song, artist, self.songCount);

    [[NSUserDefaults standardUserDefaults] setObject:song forKey:LAST_SONG];
    [[NSUserDefaults standardUserDefaults] setObject:artist forKey:LAST_ARTIST];
    [[NSUserDefaults standardUserDefaults] setInteger:self.songCount forKey:LAST_SONG_COUNT];
}

- (void)trackFinishedSong:(NSString *)song artist:(NSString *)artist {
    [self trackMetric:@"Finished Song" withAttributes:@{ @"Artist" : artist, @"Song" : song, @"Song Count" : @(self.songCount) }];
    DLog(@"trackFinishedSong:artist: (%@,%@,self.songCount=%ld)", song, artist, self.songCount);
}

- (void)trackShareSong:(NSString *)song artist:(NSString *)artist on:(NSString *)service {
    NSString *fullName = [NSString stringWithFormat:@"%@ - %@", song, artist];
    [Answers logShareWithMethod:@"Song"
                    contentName:fullName
                    contentType:@"song"
                      contentId:fullName
               customAttributes:@{
                   @"Artist" : artist,
                   @"Song" : song,
                   @"Service" : service
               }];
    DLog(@"trackShareSong:artist:service: (%@,%@,%@)", song, artist, service);
}

- (void)trackUserLeavingWithSong:(NSString *)song artist:(NSString *)artist sessionSongCount:(NSInteger)sessionSongCount {
    NSString *fullName = [NSString stringWithFormat:@"%@ - %@", song, artist];
    [self trackMetric:@"Leave"
        withAttributes:@{
            @"Artist" : artist,
            @"Song" : song,
            @"Listened" : @(sessionSongCount),
            @"Popularity" : [NSString stringWithFormat:@"%ld : %@", sessionSongCount, fullName]
        }];
    DLog(@"trackUserLeavingWithSong:artist:sessionSongCount: (%@,%@,%ld)", song, artist, sessionSongCount);
}

@end
