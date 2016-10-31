#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AWRStreamingServer.h"

@interface AWRStreamingServerParse : PFObject<PFSubclassing, AWRStreamingServer>

@property (nonatomic) BOOL mainServer;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSInteger portDj;
@property (nonatomic, strong) NSString *hostname;
@property (nonatomic, strong) NSString *shoutcast;
@property (nonatomic, strong) NSString *iPhoneStreaming;
@property (nonatomic, strong) NSString *rtspStreaming;
@property (nonatomic, strong) NSString *rtmpStreaming;
@property (nonatomic, strong) NSString *iTunesStreaming;
@property (nonatomic, strong) NSString *flashStreaming;
@property (nonatomic, strong) NSString *winampStreaming;
@property (nonatomic, strong) NSString *vlcStreaming;
@property (nonatomic, strong) NSString *quicktimeStreaming;
@property (nonatomic, strong) NSString *metadataUrl;

+ (NSString *)parseClassName;

@end
