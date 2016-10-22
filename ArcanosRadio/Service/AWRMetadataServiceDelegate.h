#import <Foundation/Foundation.h>
#import "AWRPlaylist.h"

@protocol AWRMetadataServiceDelegate <NSObject>

- (void)didFetchSongMetadata:(id<AWRPlaylist>)playlist;
- (void)didFetchSongAlbumArt:(NSData *)albumArt;
- (void)didFetchSongLyrics:(NSString *)lyrics;

@end
