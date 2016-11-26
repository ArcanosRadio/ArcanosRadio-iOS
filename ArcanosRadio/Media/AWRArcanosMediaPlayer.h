#import <Foundation/Foundation.h>

@protocol AWRArcanosMediaPlayerDelegate

- (void)didStartPlaying;
- (void)didStopPlaying;
- (void)didStartBuffering;
- (void)beginReceivingRemoteControlEvents;

@end

@interface AWRArcanosMediaPlayer : NSObject

@property(nonatomic, weak)id<AWRArcanosMediaPlayerDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithUrl:(NSString *)url;
- (void)play;
- (void)prepare;
- (void)stop;
- (void)togglePlayPause;
- (BOOL)isMuted;
- (void)toggleMute;
- (float)currentVolume;
- (void)setVolumeTo:(float)percentage;

@end
