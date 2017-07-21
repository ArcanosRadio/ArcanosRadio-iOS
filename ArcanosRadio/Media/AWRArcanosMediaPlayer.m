#import "AWRArcanosMediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AWRArcanosMediaPlayer ()

@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (strong, nonatomic) AVPlayerItem *streamingFlow;
@property (nonatomic) float restoreVolume;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) AVPlayerTimeControlStatus lastStatus;

@end

@implementation AWRArcanosMediaPlayer

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        NSURL *streamingUrl = [NSURL URLWithString:url];
        self.streamingFlow  = [[AVPlayerItem alloc] initWithURL:streamingUrl];
        self.audioPlayer    = [[AVPlayer alloc] initWithPlayerItem:self.streamingFlow];
        self.restoreVolume  = 0.0;
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    return self;
}

- (NSTimer *)timer {
    __weak typeof(self) weakSelf = self;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:weakSelf selector:@selector(updateStatus:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)prepare {
    [self startBackgroundStreaming];
    [self registerForNotifications];
}

- (void)play {
    [self.audioPlayer replaceCurrentItemWithPlayerItem:nil];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:self.streamingFlow];
    [self.audioPlayer play];
    if (self.delegate) [self.delegate didStartPlaying];
}

- (void)updateStatus:(NSTimer *)timer {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];

    if (self.lastStatus != self.audioPlayer.timeControlStatus) {
        self.lastStatus = self.audioPlayer.timeControlStatus;
        if (self.delegate) {
            switch (self.lastStatus) {
            case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
                commandCenter.playCommand.enabled  = NO;
                commandCenter.pauseCommand.enabled = YES;
                [self.delegate didStartBuffering];
                break;
            case AVPlayerTimeControlStatusPlaying:
                commandCenter.playCommand.enabled  = NO;
                commandCenter.pauseCommand.enabled = YES;
                [self.delegate didStartPlaying];
                break;
            case AVPlayerTimeControlStatusPaused:
            default:
                commandCenter.playCommand.enabled  = YES;
                commandCenter.pauseCommand.enabled = NO;
                [self.delegate didStopPlaying];
                break;
            }
        }
    }
}

- (void)stop {
    [self.audioPlayer pause];
    if (self.delegate) [self.delegate didStopPlaying];
}

- (void)togglePlayPause {
    if (self.audioPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self stop];
    } else {
        [self play];
    }
}

- (BOOL)isMuted {
    return self.audioPlayer.isMuted;
}

- (void)toggleMute {
    if (self.audioPlayer.muted) {
        [self.audioPlayer setMuted:NO];
        if (self.restoreVolume == 0.0) self.restoreVolume = 0.1;
        [self.audioPlayer setVolume:self.restoreVolume];
    } else {
        [self.audioPlayer setMuted:YES];
        self.restoreVolume = self.audioPlayer.volume;
    }
}

- (float)currentVolume {
    return self.audioPlayer.volume;
}

- (void)setVolumeTo:(float)percentage {
    if (percentage > 0.0) {
        [self.audioPlayer setMuted:NO];
    }
    [self.audioPlayer setVolume:percentage];
}

- (void)startBackgroundStreaming {
    if (self.delegate) [self.delegate beginReceivingRemoteControlEvents];
    NSError *activationError     = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&activationError];
    [audioSession setActive:YES error:&activationError];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlEventNotification:) name:@"RemoteControlEventReceived" object:nil];

    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];

    commandCenter.previousTrackCommand.enabled = NO;
    commandCenter.nextTrackCommand.enabled     = NO;
    commandCenter.playCommand.enabled          = YES;
    commandCenter.pauseCommand.enabled         = NO;
    //    commandCenter.likeCommand.enabled = YES;
    //    commandCenter.bookmarkCommand.enabled = YES;

    [commandCenter.playCommand addTarget:self action:@selector(play)];
    [commandCenter.pauseCommand addTarget:self action:@selector(stop)];
    //    [commandCenter.likeCommand addTarget:self action:@selector(like)];
    //    [commandCenter.likeCommand addTarget:self action:@selector(bookmark)];
}

- (void)like {
}
- (void)bookmark {
}

- (void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteControlEventReceived" object:nil];
}

- (void)remoteControlEventNotification:(NSNotification *)note {
    UIEvent *event = note.object;
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause: [self togglePlayPause]; break;
        case UIEventSubtypeRemoteControlPlay: [self play]; break;
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlStop: [self stop]; break;
        default: break;
        }
    }
}

@end
