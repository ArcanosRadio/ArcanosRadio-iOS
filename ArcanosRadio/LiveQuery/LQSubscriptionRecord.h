#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class LQClient;
@class LQEvent;
@class LQErrorType;
@class LQRequestId;

@interface LQSubscriptionRecord <T> : NSObject

@property (nonatomic, weak) id subscriptionHandler;
@property (nonatomic, copy) void (^eventHandlerClosure)(LQEvent *, LQClient *);
@property (nonatomic, copy) void (^errorHandlerClosure)(LQErrorType *, LQClient *);
@property (nonatomic, copy) void (^subscribeHandlerClosure)(LQClient *);
@property (nonatomic, copy) void (^unsubscribeHandlerClosure)(LQClient *);

@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, strong) LQRequestId *requestId;

- (instancetype)initWithQuery:(PFQuery *)query requestId:(LQRequestId *)requestId handler:(T)handler;

@end
