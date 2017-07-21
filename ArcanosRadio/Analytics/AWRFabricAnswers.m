#import "AWRFabricAnswers.h"
#import <Crashlytics/Crashlytics.h>

@implementation AWRFabricAnswers

- (void)trackMetric:(NSString *)metric withAttributes:(NSDictionary<NSString *, id> *)attributes {
    [Answers logCustomEventWithName:metric customAttributes:attributes];
}

- (void)trackTab:(nonnull NSString *)content forSong:(nonnull NSString *)song artist:(nonnull NSString *)artist {
    [Answers logContentViewWithName:content
                        contentType:@"tab"
                          contentId:content
                   customAttributes:@{
                       @"Tab" : content,
                       @"Artist" : artist,
                       @"Song" : song
                   }];
}

- (void)trackListenSong:(NSString *)song artist:(NSString *)artist {
    [self trackMetric:@"Listen" withAttributes:@{ @"Artist" : artist, @"Song" : song }];
}

- (void)trackShareSong:(NSString *)song artist:(NSString *)artist {
    NSString *fullName = [NSString stringWithFormat:@"%@ - %@", song, artist];
    [Answers logShareWithMethod:@"Song"
                    contentName:fullName
                    contentType:@"song"
                      contentId:fullName
               customAttributes:@{
                   @"Artist" : artist,
                   @"Song" : song
               }];
}

- (void)trackUserLeavingWithSong:(NSString *)song artist:(NSString *)artist {
    [self trackMetric:@"Leave" withAttributes:@{ @"Artist" : artist, @"Song" : song }];
}

@end
