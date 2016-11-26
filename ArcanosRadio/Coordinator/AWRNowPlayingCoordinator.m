#import "AWRNowPlayingCoordinator.h"
#import <UIKit/UIKit.h>
#import "AWRSong.h"
#import "AWRNowPlayingController.h"
#import "AWRMetadataFactory.h"
#import "AWRMetadataService.h"
#import "AWRMetadataServiceDelegate.h"
#import "AWRShareViewController.h"
#import "AWRControlCenterController.h"

@interface AWRNowPlayingCoordinator()<AWRMetadataServiceDelegate, AWRNowPlayingControllerDelegate>

@property (nonatomic, strong) AWRNowPlayingController *mainController;
@property (nonatomic, strong) AWRControlCenterController *controlCenterController;
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
    self.mainController = [[AWRNowPlayingController alloc] init];
    self.controlCenterController = [[AWRControlCenterController alloc] init];
    self.mainController.delegate = self;
    [self configureRemoteEvents];
    self.metadataService.delegate = self;
    [self.metadataService startScheduledFetch];
    return self.mainController;
}

- (void)metadataDidChangeTheSong:(id<AWRSong>)song {
    self.currentSong = song;
    [self.mainController metadataDidChangeTheSong:self.currentSong];
    [self.controlCenterController metadataDidChangeTheSong:self.currentSong];
}

- (void)metadataDidFinishDownloadingAlbumArt:(UIImage *)albumArt forSong:(id<AWRSong>)song {
    [self.mainController metadataDidFinishDownloadingAlbumArt:albumArt forSong:self.currentSong];
    [self.controlCenterController metadataDidFinishDownloadingAlbumArt:albumArt forSong:self.currentSong];
}

- (void)metadataDidFinishDownloadingLyrics:(NSString *)lyrics forSong:(id<AWRSong>)song {
    [self.mainController metadataDidFinishDownloadingLyrics:lyrics forSong:self.currentSong];
}

- (void)configureRemoteEvents {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)userDidSelectAbout {
    if (!self.delegate) return;

    [self.delegate userDidSelectAbout];
}

- (void)userDidSelectShare {
    AWRShareViewController *shareController = [[AWRShareViewController alloc] initWithCurrentSong:self.currentSong parentView:self.mainController.view];
    [self.mainController presentViewController:shareController animated:YES completion:nil];
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
