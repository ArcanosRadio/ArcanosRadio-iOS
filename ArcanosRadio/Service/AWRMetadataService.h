#import <Foundation/Foundation.h>
#import "AWRMetadataServiceDelegate.h"
#import "AWRMetadataStore.h"

@protocol AWRMetadataService <NSObject>

@property (nonatomic, weak)id<AWRMetadataServiceDelegate> delegate;

- (instancetype)initWithStore:(id<AWRMetadataStore>)store;
- (void)startScheduledFetch;
- (void)cancelScheduledFetch;
- (void)backgroundMode;
- (void)foregroundMode;
- (void)backgroundFetchWithCompletionHandler:(void (^)(BOOL))completionHandler;

@end
