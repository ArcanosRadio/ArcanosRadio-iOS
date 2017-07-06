#import "AWRNowPlayingCoordinator.h"
#import <UIKit/UIKit.h>
#import <ArcanosMetadataAPI/ArcanosMetadataAPI.h>
#import "AWRNowPlayingController.h"
#import "AWRShareViewController.h"
#import "AWRControlCenterController.h"

@interface AWRNowPlayingCoordinator()<AWRNowPlayingControllerDelegate>

@property (nonatomic, strong) AWRNowPlayingController *mainController;
@property (nonatomic, strong) AWRControlCenterController *controlCenterController;
@property (nonatomic, strong) id<AWRMetadataService> metadataService;
@property (nonatomic, strong) AWRMetadataServiceMulticastDelegate *metadataServiceListeners;

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

    self.metadataService.delegate = self.metadataServiceListeners =
        [[AWRMetadataServiceMulticastDelegate new]
            addListeners:@[self.mainController,
                           self.controlCenterController]];

    [self.metadataService startScheduledFetch];
    return self.mainController;
}

- (void)configureRemoteEvents {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)userDidSelectAbout {
    if (!self.delegate) return;

    [self.delegate userDidSelectAbout];
}

- (void)userDidSelectShare {
    AWRShareViewController *shareController = [[AWRShareViewController alloc] initWithCurrentSong:self.metadataService.currentPlaylist.song parentView:self.mainController.view];
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
