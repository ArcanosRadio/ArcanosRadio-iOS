#import "AWRMetadataServiceMulticastDelegate.h"
#import "NSArray+Functional.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWRMetadataServiceMulticastDelegate ()

@property (nonatomic, strong) NSMutableArray<__kindof id<AWRMetadataServiceDelegate>> *listeners;

@end

@implementation AWRMetadataServiceMulticastDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.listeners = [NSMutableArray new];
    }
    return self;
}

- (instancetype)addListener:(__kindof id<AWRMetadataServiceDelegate>)listener {
    [self.listeners addObject:listener];
    return self;
}

- (instancetype)addListeners:(__kindof NSArray<__kindof id<AWRMetadataServiceDelegate>> *)listeners {
    [self.listeners addObjectsFromArray:listeners];
    return self;
}

- (instancetype)removeListener:(__kindof id<AWRMetadataServiceDelegate>)listener {
    [self.listeners removeObject:listener];
    return self;
}

- (instancetype)clearListeners {
    [self.listeners removeAllObjects];
    return self;
}

- (void)metadataDidChangeTheSong:(id<AWRSong>)song {
    self.listeners.each(^(id<AWRMetadataServiceDelegate> listener) {
        [listener metadataDidChangeTheSong:song];
    });
}

- (void)metadataDidFinishDownloadingAlbumArt:(UIImage *)albumArt forSong:(id<AWRSong>)song {
    self.listeners.each(^(id<AWRMetadataServiceDelegate> listener) {
        [listener metadataDidFinishDownloadingAlbumArt:albumArt forSong:song];
    });
}

- (void)metadataDidFinishDownloadingLyrics:(NSString *)lyrics forSong:(id<AWRSong>)song {
    self.listeners.each(^(id<AWRMetadataServiceDelegate> listener) {
        if (![listener respondsToSelector:@selector(metadataDidFinishDownloadingLyrics:forSong:)]) {
            return;
        }
        [listener metadataDidFinishDownloadingLyrics:lyrics forSong:song];
    });
}

- (void)metadataDidFinishDownloadingArtistDescription:(NSString *)artistDescription forSong:(id<AWRSong>)song {
    self.listeners.each(^(id<AWRMetadataServiceDelegate> listener) {
        if (![listener respondsToSelector:@selector(metadataDidFinishDownloadingArtistDescription:forSong:)]) {
            return;
        }
        [listener metadataDidFinishDownloadingArtistDescription:artistDescription forSong:song];
    });
}

- (void)metadataDidFinishDownloadingSongDescription:(NSString *)songDescription forSong:(id<AWRSong>)song {
    self.listeners.each(^(id<AWRMetadataServiceDelegate> listener) {
        if (![listener respondsToSelector:@selector(metadataDidFinishDownloadingSongDescription:forSong:)]) {
            return;
        }
        [listener metadataDidFinishDownloadingSongDescription:songDescription forSong:song];
    });
}

@end

NS_ASSUME_NONNULL_END
