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

+ (UIImage *)defaultAlbumArt {
    return [UIImage imageNamed:@"arcanos_transparent_big"];
}

- (void)userDidSelectAbout {
    if (!self.delegate) return;

    [self.delegate userDidSelectAbout];
}

- (void)userDidSelectShare {
    NSMutableArray *sharingItems = [NSMutableArray new];

    NSString *songName = self.currentSong.songName;
    NSString *artistName = self.currentSong.artist.artistName;
    NSString *shareUrl = [[AWRMetadataFactory createMetadataStore] readConfig:@"iphoneShareUrl"];

    NSString *text = [[[NSLocalizedString(@"SHARE_TEXT", nil)
                       stringByReplacingOccurrencesOfString:@"${song}" withString:songName]
                      stringByReplacingOccurrencesOfString:@"${artist}" withString:artistName]
                      stringByReplacingOccurrencesOfString:@"${shareUrl}" withString:shareUrl];

    [sharingItems addObject:text];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems
                                                                                     applicationActivities:nil];

    activityController.popoverPresentationController.sourceView = self.mainController.view;
    activityController.popoverPresentationController.sourceRect = self.mainController.view.bounds;

    [self.mainController presentViewController:activityController animated:YES completion:nil];
}

- (void)userDidSelectSettings {
    if (!self.delegate) return;

    [self.delegate userDidSelectSettings];
}

- (void)runningInBackground {
    [self.metadataService backgroundMode];
}

- (void)runningInForeground {
    [self.metadataService foregroundMode];
}

- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler {
    [self.metadataService backgroundFetchWithCompletionHandler:completionHandler];
}

@end
