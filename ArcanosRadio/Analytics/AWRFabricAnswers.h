#import "AWRAnalyticsService.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRFabricAnswers : NSObject <AWRAnalyticsService>

- (void)trackMetric:(NSString *)metric withAttributes:(nullable NSDictionary<NSString *, id> *)attributes;
- (void)trackTab:(NSString *)content forSong:(NSString *)song artist:(NSString *)artist;
- (void)trackListenSong:(NSString *)song artist:(NSString *)artist;
- (void)trackFinishedSong:(NSString *)song artist:(NSString *)artist;
- (void)trackShareSong:(NSString *)song artist:(NSString *)artist on:(NSString *)service;
- (void)trackUserLeavingWithSong:(NSString *)song artist:(NSString *)artist sessionSongCount:(NSInteger)sessionSongCount;

@end

NS_ASSUME_NONNULL_END
