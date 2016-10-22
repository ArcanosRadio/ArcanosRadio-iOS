#import <Bolts/Bolts.h>
#import "PXPromiseProtocol.h"

@interface BFTask (PXPromise) <PXPromise, PXBrokenPromise, PXSuccessfulPromise>

@end
