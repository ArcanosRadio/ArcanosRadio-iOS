#import "AWRStreamingServerParse.h"
#import <Parse/PFObject+Subclass.h>

@implementation AWRStreamingServerParse

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"StreamingServer";
}

@dynamic mainServer, port, portDj, hostname, shoutcast, iPhoneStreaming, rtspStreaming, rtmpStreaming,
         iTunesStreaming, flashStreaming, winampStreaming, vlcStreaming, quicktimeStreaming, metadataUrl;


@end
