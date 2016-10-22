#import <Foundation/Foundation.h>

@protocol AWRArcanosMediaPlayerDelegate

- (void)didStartPlaying;
- (void)didStopPlaying;
- (void)didStartBuffering;
- (void)beginReceivingRemoteControlEvents;

@end

@interface AWRArcanosMediaPlayer : NSObject

@property(nonatomic, weak)id<AWRArcanosMediaPlayerDelegate> delegate;

- (void)play;
- (void)prepare;
- (void)stop;
- (void)togglePlayPause;
- (BOOL)isMuted;
- (void)toggleMute;
- (float)currentVolume;
- (void)setVolumeTo:(float)percentage;

@end
