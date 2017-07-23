#import "AWRMetadataFactory+Mock.h"
#import "AWRMockMetadataService.h"
#import <objc/runtime.h>

@implementation AWRMetadataFactory (Mock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass((id)self);

        SEL originalSelector  = @selector(createMetadataService);
        SEL swizzledSelector  = @selector(xxx_createMetadataService);
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
            class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (id<AWRMetadataService>)xxx_createMetadataService {
    return [AWRMockMetadataService sharedInstance];
}

@end
