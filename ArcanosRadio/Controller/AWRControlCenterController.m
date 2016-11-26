#import "AWRControlCenterController.h"
#import "AWRMetadataFactory.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation AWRControlCenterController

- (void)metadataDidChangeTheSong:(id<AWRSong>)song {
    UIImage *defaultImage = [[AWRMetadataFactory metadataStoreClass] defaultAlbumArt];
    [self controlCentreWithArtist:song.artist.artistName song:song.songName albumArt:defaultImage];
}

- (void)metadataDidFinishDownloadingAlbumArt:(UIImage *)albumArt forSong:(id<AWRSong>)song {
    [self controlCentreWithArtist:song.artist.artistName song:song.songName albumArt:albumArt];
}

- (void)controlCentreWithArtist:(NSString *)artist song:(NSString *)song albumArt:(UIImage *)albumArt {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSDictionary *songInfo = @{
                                   MPMediaItemPropertyMediaType: @(MPMediaTypeMusic),
                                   MPMediaItemPropertyTitle: song,
                                   MPMediaItemPropertyAlbumArtist: artist,
                                   MPMediaItemPropertyArtist: artist,
                                   MPMediaItemPropertyArtwork: [[MPMediaItemArtwork alloc] initWithImage: albumArt],
                                   MPMediaItemPropertyPlaybackDuration: @0.0,
                                   MPNowPlayingInfoPropertyPlaybackRate: @1.0,
                                   MPNowPlayingInfoPropertyElapsedPlaybackTime: @0.0
                                   };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = songInfo;
        });
    }
}

@end
