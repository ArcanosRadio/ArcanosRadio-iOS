#import "AWRPlaylistParse.h"
#import <Parse/PFObject+Subclass.h>

@implementation AWRPlaylistParse

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Playlist";
}

@dynamic title, song;

@end
