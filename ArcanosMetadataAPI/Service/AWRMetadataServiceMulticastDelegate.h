#import <Foundation/Foundation.h>
#import "AWRMetadataServiceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWRMetadataServiceMulticastDelegate : NSObject<AWRMetadataServiceDelegate>

- (instancetype)addListener:(__kindof id<AWRMetadataServiceDelegate>)listener;
- (instancetype)addListeners:(__kindof NSArray<__kindof id<AWRMetadataServiceDelegate>> *)listeners;
- (instancetype)removeListener:(__kindof id<AWRMetadataServiceDelegate>)listener;
- (instancetype)clearListeners;

@end

NS_ASSUME_NONNULL_END
