#import <Bolts/Bolts.h>
#import <IOZPromise/IOZPromise.h>

@interface BFTask (IOZPromise) <IOZPromise, IOZBrokenPromise, IOZSuccessfulPromise>

@end
