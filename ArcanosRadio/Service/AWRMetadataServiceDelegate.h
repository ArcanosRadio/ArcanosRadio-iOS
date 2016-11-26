#import <Foundation/Foundation.h>
#import "AWRPlaylist.h"
#import <UIKit/UIKit.h>

@protocol AWRMetadataServiceDelegate <NSObject>

@required
- (void)metadataDidChangeTheSong:(id<AWRSong>)song;
- (void)metadataDidFinishDownloadingAlbumArt:(UIImage *)albumArt forSong:(id<AWRSong>)song;

@optional
- (void)metadataDidFinishDownloadingLyrics:(NSString *)lyrics forSong:(id<AWRSong>)song;
- (void)metadataDidFinishDownloadingArtistDescription:(NSString *)artistDescription forSong:(id<AWRSong>)song;
- (void)metadataDidFinishDownloadingSongDescription:(NSString *)songDescription forSong:(id<AWRSong>)song;

@end
