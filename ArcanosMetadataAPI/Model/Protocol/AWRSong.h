#import <Foundation/Foundation.h>
#import "AWRArtist.h"
#import "AWRFile.h"
#import "AWREntity.h"

@protocol AWRSong <NSObject, AWREntity>

@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) id<AWRArtist> artist;
@property (nonatomic, strong) id<AWRFile> albumArt;
@property (nonatomic, strong) id<AWRFile> lyrics;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic) BOOL hasRightsContract;
@property (nonatomic, strong) NSString *spotifyTrackId;
@property (nonatomic, strong) NSString *spotifyAlbumId;
@property (nonatomic, strong) NSDictionary<NSString *, __kindof id<AWRFile>> *localizedDescription;

@end
