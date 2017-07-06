#import <Foundation/Foundation.h>
#import "AWRMetadataServiceDelegate.h"
#import "AWRMetadataStore.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AWRMetadataService <NSObject>

@property (nonatomic, nullable, weak)id<AWRMetadataServiceDelegate> delegate;
@property (nonatomic, nullable, strong) id<AWRPlaylist>currentPlaylist;

- (instancetype)initWithStore:(id<AWRMetadataStore>)store;
- (void)startScheduledFetch;
- (void)cancelScheduledFetch;
- (void)backgroundMode;
- (void)foregroundMode;
- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler;

@end

NS_ASSUME_NONNULL_END
