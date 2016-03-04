
@interface NSObject (PerformSelectorEx)

- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;

@end
