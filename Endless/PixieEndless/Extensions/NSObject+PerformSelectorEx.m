
#import "NSObject+PerformSelectorEx.h"

@implementation NSObject (PerformSelectorEx)

- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay
{
    NSMethodSignature * sig = [self methodSignatureForSelector:aSelector];
    if (!sig) return;
    
    NSInvocation * invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:aSelector];
    
    if (anArgument != nil) [invo setArgument:&anArgument atIndex:2];
    [invo retainArguments];
    
    NSMethodSignature * sigMT = [invo methodSignatureForSelector:@selector(performSelector:withObject:afterDelay:)];
    NSInvocation * invoMT = [NSInvocation invocationWithMethodSignature:sigMT];
    [invoMT setTarget:invo];
    [invoMT setSelector:@selector(performSelector:withObject:afterDelay:)];
    
    SEL arg1 = @selector(invoke);
    void * arg2 = nil;
    NSTimeInterval arg3 = delay;
    [invoMT setArgument:&arg1 atIndex:2];
    [invoMT setArgument:&arg2 atIndex:3];
    [invoMT setArgument:&arg3 atIndex:4];
    [invoMT retainArguments];
    
    [invoMT performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
}

@end