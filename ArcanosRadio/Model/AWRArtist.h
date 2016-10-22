#import <Foundation/Foundation.h>
#import "AWREntity.h"

@protocol AWRArtist <NSObject, AWREntity>

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<NSString *> *tags;

@end
