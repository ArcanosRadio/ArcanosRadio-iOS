#import "LQClient.h"
#import "LQRequestId.h"
#import "LQSubscriptionRecord.h"
#import "Parse+LQLiveQuery.h"
#import <Parse/Parse.h>
#import <SocketRocket/SocketRocket.h>

@interface LQClient ()

@property (nonatomic, strong) NSURL *host;
@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *clientKey;
@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic) BOOL *userDisconnected;
@property (nonatomic, copy) LQRequestId * (^requestIdGenerator)();
@property (nonatomic, strong) NSMutableArray<LQSubscriptionRecord *> *subscriptions;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation LQClient

- (instancetype)init {
    NSError *error;
    id server = [Parse validatedCurrentConfiguration:&error].server;
    if (error) {
        return nil;
    }
    return [self initWithServer:server applicationId:nil clientKey:nil];
}

- (instancetype)initWithServer:(NSString *)server applicationId:(NSString *)applicationId clientKey:(NSString *)clientKey {
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("com.parse.livequery", DISPATCH_QUEUE_SERIAL);

        NSURLComponents *components = [NSURLComponents componentsWithString:server];
        if (!components) {
            @throw @"Server should be a valid URL.";
        }

        components.scheme = [components.scheme isEqualToString:@"https"] ? @"wss" : @"ws";

        __block NSInteger currentRequestId = 0;
        self.requestIdGenerator            = ^LQRequestId * {
            currentRequestId += 1;
            return [[LQRequestId alloc] initWithValue:currentRequestId];
        };

        NSError *error;
        self.applicationId = applicationId ? applicationId : [Parse validatedCurrentConfiguration:&error].applicationId;
        if (error) {
            return nil;
        }
        self.clientKey = clientKey ? clientKey : [Parse validatedCurrentConfiguration:&error].clientKey;
        if (error) {
            return nil;
        }

        self.host = components.URL;
    }
    return self;
}

@end

//
//    extension Client {
//        // Swift is lame and doesn't allow storage to directly be in extensions.
//        // So we create an inner struct to wrap it up.
//        private class Storage {
//            static var onceToken: dispatch_once_t = 0
//            static var sharedStorage: Storage!
//            static var shared: Storage {
//                dispatch_once(&onceToken) {
//                    sharedStorage = Storage()
//                }
//                return sharedStorage
//            }
//
//            let queue: dispatch_queue_t = dispatch_queue_create("com.parse.livequery.client.storage", DISPATCH_QUEUE_SERIAL)
//            var client: Client?
//        }
//
//        /// Gets or sets shared live query client to be used for default subscriptions
//        @objc(sharedClient)
//        public static var shared: Client! {
//            get {
//                let storage = Storage.shared
//                var client: Client?
//                dispatch_sync(storage.queue) {
//                    client = storage.client
//                    if client == nil {
//                        let configuration = Parse.validatedCurrentConfiguration()
//                        client = Client(
//                                        server: configuration.server,
//                                        applicationId: configuration.applicationId,
//                                        clientKey: configuration.clientKey
//                                        )
//                        storage.client = client
//                    }
//                }
//                return client
//            }
//            set {
//                let storage = Storage.shared
//                dispatch_sync(storage.queue) {
//                    storage.client = newValue
//                }
//            }
//        }
//    }
//
//    extension Client {
//        /**
//         Registers a query for live updates, using the default subscription handler
//         - parameter query:        The query to register for updates.
//         - parameter subclassType: The subclass of PFObject to be used as the type of the Subscription.
//         This parameter can be automatically inferred from context most of the time
//         - returns: The subscription that has just been registered
//         */
//        public func subscribe<T where T: PFObject>(
//                                                   query: PFQuery,
//                                                   subclassType: T.Type = T.self
//                                                   ) -> Subscription<T> {
//            return subscribe(query, handler: Subscription<T>())
//        }
//
//        /**
//         Registers a query for live updates, using a custom subscription handler
//         - parameter query:   The query to register for updates.
//         - parameter handler: A custom subscription handler.
//         - returns: Your subscription handler, for easy chaining.
//         */
//        public func subscribe<T where T: SubscriptionHandling>(
//                                                               query: PFQuery,
//                                                               handler: T
//                                                               ) -> T {
//            let subscriptionRecord = SubscriptionRecord(
//                                                        query: query,
//                                                        requestId: requestIdGenerator(),
//                                                        handler: handler
//                                                        )
//            subscriptions.append(subscriptionRecord)
//
//            if socket?.readyState == .OPEN {
//                sendOperationAsync(.Subscribe(requestId: subscriptionRecord.requestId, query: query))
//            } else if socket == nil || socket?.readyState != .CONNECTING {
//                if !userDisconnected {
//                    reconnect()
//                } else {
//                    debugPrint("Warning: The client was explicitly disconnected! You must explicitly call .reconnect() in order to process
//                    your
//                    subscriptions.")
//                }
//            }
//
//            return handler
//        }
//
//        /**
//         Unsubscribes all current subscriptions for a given query.
//         - parameter query: The query to unsubscribe from.
//         */
//        @objc(unsubscribeFromQuery:)
//        public func unsubscribe(query: PFQuery) {
//            unsubscribe { $0.query == query }
//        }
//
//        /**
//         Unsubscribes from a specific query-handler pair.
//         - parameter query:   The query to unsubscribe from.
//         - parameter handler: The specific handler to unsubscribe from.
//         */
//        public func unsubscribe<T where T: SubscriptionHandling>(query: PFQuery, handler: T) {
//            unsubscribe { $0.query == query && $0.subscriptionHandler === handler }
//        }
//
//        func unsubscribe(@noescape matching matcher: SubscriptionRecord -> Bool) {
//            subscriptions.filter {
//                matcher($0)
//            }.forEach {
//                sendOperationAsync(.Unsubscribe(requestId: $0.requestId))
//            }
//        }
//
//    }
//
//    extension Client {
//        /**
//         Reconnects this client to the server.
//         This will disconnect and resubscribe all existing subscriptions. This is not required to be called the first time
//         you use the client, and should usually only be called when an error occurs.
//         */
//        public func reconnect() {
//            socket?.close()
//            socket = {
//                let socket = SRWebSocket(URL: host)
//                socket.delegate = self
//                socket.setDelegateDispatchQueue(queue)
//                socket.open()
//                userDisconnected = false
//                return socket
//            }()
//        }
//
//        /**
//         Explicitly disconnects this client from the server.
//         This does not remove any subscriptions - if you `reconnect()` your existing subscriptions will be restored.
//         Use this if you wish to dispose of the live query client.
//         */
//        public func disconnect() {
//            guard let socket = socket
//            else {
//                return
//            }
//            socket.close()
//            self.socket = nil
//            userDisconnected = true
//        }
//    }
//
