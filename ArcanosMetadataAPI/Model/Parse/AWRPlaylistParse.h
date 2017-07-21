#import "AWRPlaylist.h"
#import "AWRSongParse.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AWRPlaylistParse : PFObject <PFSubclassing, AWRPlaylist>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AWRSongParse *song;

+ (NSString *)parseClassName;

@end
