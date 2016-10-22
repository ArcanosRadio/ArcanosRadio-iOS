#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AWRSongParse.h"
#import "AWRPlaylist.h"

@interface AWRPlaylistParse : PFObject<PFSubclassing, AWRPlaylist>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AWRSongParse *song;

+ (NSString *)parseClassName;

@end
