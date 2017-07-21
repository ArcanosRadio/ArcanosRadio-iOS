#import <Parse/Parse.h>

@interface Parse (LQLiveQuery)

+ (ParseClientConfiguration *)validatedCurrentConfiguration:(NSError **)error;

@end
