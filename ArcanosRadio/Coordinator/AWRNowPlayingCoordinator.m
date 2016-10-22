#import "AWRNowPlayingCoordinator.h"
#import <UIKit/UIKit.h>
#import "AWRSong.h"
#import "AWRNowPlayingController.h"
#import "AWRMetadataFactory.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AWRMetadataService.h"
#import "AWRMetadataServiceDelegate.h"

@interface AWRNowPlayingCoordinator()<AWRMetadataServiceDelegate, AWRNowPlayingControllerDelegate>

@property (nonatomic, strong) AWRNowPlayingController *mainController;
@property (nonatomic, strong) id<AWRMetadataService> metadataService;
@property (nonatomic, strong) id<AWRSong> currentSong;

@end

@implementation AWRNowPlayingCoordinator

- (id<AWRMetadataService>)metadataService {
    if (!_metadataService) {
        _metadataService = [AWRMetadataFactory createMetadataService];
    }
    return _metadataService;
}

- (id)start {
    self.mainController = [[AWRNowPlayingController alloc]init];
    self.mainController.delegate = self;
    [self configureRemoteEvents];
    self.metadataService.delegate = self;
    [self.metadataService startScheduledFetch];
    return self.mainController;
}

- (void)didFetchSongMetadata:(id<AWRPlaylist>)playlist {
    self.currentSong = playlist.song;
    NSString *songName = self.currentSong.songName;
    NSString *artistName = self.currentSong.artist.artistName;

    UIImage *defaultImage = [AWRNowPlayingCoordinator defaultAlbumArt];
    [self.mainController metadataDidChangeTheSong:songName artist:artistName albumArt:defaultImage];
    [self controlCentreWithArtist:artistName song:songName albumArt:defaultImage];
}

- (void)didFetchSongAlbumArt:(NSData *)albumArt {
    UIImage *image = [UIImage imageWithData:albumArt];
    NSString *songName = self.currentSong.songName;
    NSString *artistName = self.currentSong.artist.artistName;

    [self.mainController metadataDidFinishDownloadingAlbumArt:image];
    [self controlCentreWithArtist:artistName song:songName albumArt:image];
}

- (void)didFetchSongLyrics:(NSString *)lyrics {
    [self.mainController metadataDidFinishDownloadingLyrics:lyrics];
}

- (void)configureRemoteEvents {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)controlCentreWithArtist:(NSString *)artist song:(NSString *)song albumArt:(UIImage *)albumArt {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSDictionary *songInfo = @{
            MPMediaItemPropertyTitle: song,
            MPMediaItemPropertyArtist: artist,
            MPMediaItemPropertyArtwork: [[MPMediaItemArtwork alloc] initWithImage: albumArt]
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = songInfo;
        });
    }
}

+ (UIImage *)defaultAlbumArt {
    return [UIImage imageNamed:@"arcanos_transparent_big"];
}

- (void)userDidSelectAbout {
    if (!self.delegate) return;

    [self.delegate userDidSelectAbout];
}

- (void)userDidSelectShare {
    NSMutableArray *sharingItems = [NSMutableArray new];

    NSString *text = [[NSLocalizedString(@"SHARE_TEXT", nil)
                      stringByReplacingOccurrencesOfString:@"${song}" withString:self.currentSong.songName]
                      stringByReplacingOccurrencesOfString:@"${artist}" withString:self.currentSong.artist.artistName];
    [sharingItems addObject:text];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self.mainController presentViewController:activityController animated:YES completion:nil];
}

- (void)userDidSelectSettings {
    if (!self.delegate) return;

    [self.delegate userDidSelectSettings];
}

@end
