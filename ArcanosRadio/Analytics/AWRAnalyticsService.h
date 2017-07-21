#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AWRAnalyticsService <NSObject>

- (void)trackMetric:(NSString *)metric withAttributes:(nullable NSDictionary<NSString *, id> *)attributes;
- (void)trackTab:(NSString *)content forSong:(NSString *)song artist:(NSString *)artist;
- (void)trackListenSong:(NSString *)song artist:(NSString *)artist;
- (void)trackShareSong:(NSString *)song artist:(NSString *)artist;
- (void)trackUserLeavingWithSong:(NSString *)song artist:(NSString *)artist;

@end

NS_ASSUME_NONNULL_END
