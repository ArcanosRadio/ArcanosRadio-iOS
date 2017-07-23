#import "AWRMetadataService.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRMockMetadataService : NSObject <AWRMetadataService>

@property (nonatomic, nullable, weak) id<AWRMetadataServiceDelegate> delegate;
@property (nonatomic, nullable, strong) id<AWRPlaylist> currentPlaylist;

+ (AWRMockMetadataService *)sharedInstance;
- (instancetype)initWithStore:(id<AWRMetadataStore>)store;
- (void)startScheduledFetch;
- (void)cancelScheduledFetch;
- (void)backgroundMode;
- (void)foregroundMode;
- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler;
- (void)setSong:(id<AWRSong>)song lyrics:(NSString *)lyrics art:(UIImage *)art;

@end

NS_ASSUME_NONNULL_END
