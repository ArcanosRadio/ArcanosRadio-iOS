#import <KIF/KIF.h>

@interface KIFUITestActor (EXAdditions)

- (void)waitForMusic;
- (void)screenshotWithIdentifier:(nonnull NSString *)identifier;

@end
