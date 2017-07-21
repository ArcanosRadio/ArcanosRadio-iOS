#import "AWRArtist.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AWRArtistParse : PFObject <PFSubclassing, AWRArtist>

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *spotifyArtistId;
@property (nonatomic, strong) NSDictionary<NSString *, __kindof id<AWRFile>> *localizedDescription;
@property (nonatomic, strong) NSString *twitterTimeline;

+ (NSString *)parseClassName;

@end
