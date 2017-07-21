#import "AWRMetadataService.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRMetadataPoolingService : NSObject <AWRMetadataService>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)initWithStore:(id<AWRMetadataStore>)store NS_DESIGNATED_INITIALIZER;

@property (nonatomic, nullable, weak) id<AWRMetadataServiceDelegate> delegate;
@property (nonatomic, nullable, strong) id<AWRPlaylist> currentPlaylist;

@end

NS_ASSUME_NONNULL_END
