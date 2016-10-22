#import <Foundation/Foundation.h>
#import "AWRMetadataService.h"

@interface AWRMetadataPoolingService : NSObject<AWRMetadataService>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStore:(id<AWRMetadataStore>)store NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak)id<AWRMetadataServiceDelegate> delegate;

@end
