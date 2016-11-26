#import <Foundation/Foundation.h>
#import "AWREntity.h"
#import "AWRFile.h"

@protocol AWRArtist <NSObject, AWREntity>

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSString *spotifyArtistId;
@property (nonatomic, strong) NSDictionary<NSString *, __kindof id<AWRFile>> *localizedDescription;

@end
