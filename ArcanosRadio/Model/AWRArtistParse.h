#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AWRArtist.h"

@interface AWRArtistParse : PFObject<PFSubclassing, AWRArtist>

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *tags;

+ (NSString *)parseClassName;

@end

