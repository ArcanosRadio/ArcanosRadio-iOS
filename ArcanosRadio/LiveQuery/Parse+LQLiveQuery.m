#import "Parse+LQLiveQuery.h"

@implementation Parse (LQLiveQuery)

+ (ParseClientConfiguration *)validatedCurrentConfiguration:(NSError *__autoreleasing *)error {
    ParseClientConfiguration *current = [Parse currentConfiguration];
    if (!current) {
        if (*error) {
            *error = [NSError errorWithDomain:@"Parse SDK is not initialized. \
                      Call Parse.initializeWithConfiguration() before loading \
                      live query client."
                                         code:200
                                     userInfo:nil];
        }
        return nil;
    }

    return current;
}

@end
