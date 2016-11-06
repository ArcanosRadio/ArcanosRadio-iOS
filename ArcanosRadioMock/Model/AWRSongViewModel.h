#import <Foundation/Foundation.h>

@interface AWRSongViewModel : NSObject

@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *lyrics;
@property (nonatomic, strong) NSString *albumArtAssetName;
@property (nonatomic, strong) NSDate *updatedAt;

@end
