#import "LQSubscriptionRecord.h"

#import "LQClient.h"
//@class LQEvent;
//@class LQErrorType;
#import "LQRequestId.h"

@implementation LQSubscriptionRecord

- (instancetype)initWithQuery:(PFQuery *)query requestId:(LQRequestId *)requestId handler:(id)handler {
    self = [super init];
    if (self) {
        self.query               = query;
        self.requestId           = requestId;
        self.subscriptionHandler = handler;

        __weak LQSubscriptionRecord *weakSelf = self;

        self.eventHandlerClosure = ^(LQEvent *event, LQClient *client) {
            if (!weakSelf || !weakSelf.subscriptionHandler) {
                return;
            }

            // [weakSelf.subscriptionHandler didReceiveEvent: event forQuery:query inClient:client];
        };

        self.errorHandlerClosure = ^(LQErrorType *error, LQClient *client) {
            if (!weakSelf || !weakSelf.subscriptionHandler) {
                return;
            }

            // [weakSelf.subscriptionHandler didEncounterError:error forQuery: query inClient:client];
        };

        self.subscribeHandlerClosure = ^(LQClient *client) {
            if (!weakSelf || !weakSelf.subscriptionHandler) {
                return;
            }

            //[weakSelf.subscriptionHandler didSubscribeToQuery:query inClient:client];
        };

        self.unsubscribeHandlerClosure = ^(LQClient *client) {
            if (!weakSelf || !weakSelf.subscriptionHandler) {
                return;
            }

            //[weakSelf.subscriptionHandler didUnsubscribeFromQuery:query inClient:client];
        };
    }

    return self;
}

@end
