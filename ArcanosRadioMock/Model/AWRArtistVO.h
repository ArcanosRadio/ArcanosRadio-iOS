#import <Foundation/Foundation.h>
#import "AWREntityVO.h"
#import "AWRArtist.h"

@interface AWRArtistVO : AWREntityVO<AWRArtist>

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<NSString *> *tags;

@end
