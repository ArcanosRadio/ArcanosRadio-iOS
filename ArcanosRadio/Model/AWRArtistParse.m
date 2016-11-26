#import "AWRArtistParse.h"
#import <Parse/PFObject+Subclass.h>

@implementation AWRArtistParse

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Artist";
}

@dynamic artistName, url, text, tags, spotifyArtistId;

@end
