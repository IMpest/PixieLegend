
#import "PPSpriteButton.h"

@implementation PPSpriteButton
{
    UITouch * currentTouch;
    NSMutableArray *marrSelectors;
}

#pragma mark - CLASS METHODS FOR INIT

+(PPSpriteButton *)buttonWithImageNamed:(NSString *)image
{
    PPSpriteButton *newButton = [[PPSpriteButton alloc]initWithImageNamed:image];
    
    return newButton;
}

+(PPSpriteButton *)buttonWithColor:(UIColor *)color andSize:(CGSize)size
{
    PPSpriteButton *newButton = [[PPSpriteButton alloc]initWithColor:color size:size];
    
    return newButton;
}

+(PPSpriteButton *)buttonWithTexture:(SKTexture *)texture andSize:(CGSize)size
{
    PPSpriteButton *newButton = [[PPSpriteButton alloc]initWithTexture:texture color:[UIColor whiteColor] size:size];
    
    return newButton;
}

+(PPSpriteButton *)buttonWithTexture:(SKTexture *)texture
{
    PPSpriteButton *newButton = [[PPSpriteButton alloc]initWithTexture:texture];
    
    return newButton;
}

#pragma mark - INIT OVERRIDING

-(instancetype)initWithImageNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:name])
    {
        [self setBaseProperties];
    }
    
    return self;
    
}

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size])
    {
        [self setBaseProperties];
    }
    
    return self;
}

-(instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithTexture:texture color:color size:size])
    {
        [self setBaseProperties];
    }
    
    return self;
}

-(instancetype)initWithTexture:(SKTexture *)texture
{
    if (self = [super initWithTexture:texture])
    {
        [self setBaseProperties];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self setBaseProperties];
    }
    
    return self;
}

-(void)setBaseProperties
{
    self.userInteractionEnabled = YES;
    self.exclusiveTouch = YES;
    
    marrSelectors = [[NSMutableArray alloc]init];
}

#pragma mark - LABEL FOR BUTTON


-(void)setLabelWithText:(NSString *)text andFont:(UIFont *)font withColor:(UIColor*)fontColor
{
    if (self.label == nil)
    {
        self.label = [SKLabelNode node];
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    }
    else
    {
        [self.label removeFromParent];
    }
    
    if (text != nil)
    {
        self.label.text = text;
    }
    
    if (font != nil)
    {
        self.label.fontName = font.fontName;
        self.label.fontSize = font.pointSize;
    }
    
    if (fontColor != nil)
    {
        self.label.fontColor = fontColor;
    }
    
    [self addChild:self.label];
    
}

#pragma mark - TOUCH DELEGATES

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.exclusiveTouch)
    {
        if (currentTouch == nil)
        {
            currentTouch = [touches anyObject];
            
            [self controlEventOccured:PPButtonControlEventTouchDown];
            
            [self transformForTouchDown];
            
            //            [self.parent touchesBegan:touches withEvent:event];
        }
        else
        {
            //current touch occupied
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.exclusiveTouch)
    {
        if ([touches containsObject:currentTouch])
        {
            CGPoint touchPoint = [currentTouch locationInNode:self];
            float lenX = self.size.width / 2;
            float lenY = self.size.height / 2;
            
            //            [self.parent touchesMoved:touches withEvent:event];
            
            if ((touchPoint.x > lenX + 10)|| (touchPoint.x < (-lenX - 10)) || (touchPoint.y > lenY + 10) || (touchPoint.y < (-lenY - 10)))
            {
                [self touchesCancelled:touches withEvent:Nil];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.exclusiveTouch)
    {
        if ([touches containsObject:currentTouch])
        {
            //touchupinside
            
            [self controlEventOccured:PPButtonControlEventTouchUp];
            [self controlEventOccured:PPButtonControlEventTouchUpInside];
            
            currentTouch = Nil;
            
            [self transformForTouchUp];
            
            //            [self.parent touchesEnded:touches withEvent:event];
            
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.exclusiveTouch)
    {
        if ([touches containsObject:currentTouch])
        {
            currentTouch = Nil;
            
            [self transformForTouchUp];
            
        }
    }
}

#pragma mark - BUTTON TRANSFORM ON SELECTION

-(void)transformForTouchDown
{
    // You can define your custom transformation here.
    [self runAction:[SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.5 duration:0]];
}

-(void)transformForTouchDrag
{
    // You can define your custom transformation here.
}

-(void)transformForTouchUp
{
    // You can define your custom transformation here.
    [self runAction:[SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.0 duration:0]];
}

#pragma mark - TARGET/SELECTOR HANDLING

-(void)addTarget:(id)target selector:(SEL)selector withObject:(id)object forControlEvent:(PPButtonControlEvent)controlEvent
{
    //check whether selector is already saved, otherwise it will get called twice
    
    NSMutableDictionary * mdicSelector = [[NSMutableDictionary alloc]init];
    
    [mdicSelector setObject:target forKey:@"target"];
    [mdicSelector setObject:[NSValue valueWithPointer:selector] forKey:@"selector"];
    
    if (object)
    {
        [mdicSelector setObject:object forKey:@"object"];
    }
    
    [mdicSelector setObject:[NSNumber numberWithInt:controlEvent] forKey:@"controlEvent"];
    
    [marrSelectors addObject:mdicSelector];
}

-(void)removeTarget:(id)target selector:(SEL)selector forControlEvent:(PPButtonControlEvent)controlEvent
{
    NSMutableArray *arrSelectors = [marrSelectors mutableCopy]; //Copied to prevent inconsistency
    
    for (int i = 0; i < [arrSelectors count]; i++)
    {
        
        NSDictionary * dicSelector = [arrSelectors objectAtIndex: i];
        
        BOOL shouldRemove = NO;
        BOOL shouldCheckSelector = NO;
        BOOL shouldCheckControlEvent = NO;
        
        id selTarget = [dicSelector objectForKey:@"target"];
        
        NSValue * valSelector = [dicSelector objectForKey:@"selector"];
        
        SEL selSelector = nil;
        
        if (valSelector)
        {
            selSelector = [valSelector pointerValue];
        }
        
        PPButtonControlEvent selControlEvent = [[dicSelector objectForKey:@"controlEvent"]intValue];
        
        if (target != nil)
        {
            if ([selTarget isEqual:target])
            {
                shouldCheckSelector = YES;
            }
        }
        else
        {
            shouldCheckSelector = YES;
        }
        
        if (shouldCheckSelector)
        {
            if (selector != nil)
            {
                if (selSelector == selector)
                {
                    shouldCheckControlEvent = YES;
                }
            }
            else
            {
                shouldCheckControlEvent = YES;
            }
        }
        
        if (shouldCheckControlEvent)
        {
            if (controlEvent == PPButtonControlEventAllEvents)
            {
                shouldRemove = YES;
            }
            else
            {
                if (selControlEvent == controlEvent)
                {
                    shouldRemove = YES;
                }
            }
        }
        
        if (shouldRemove)
        {
            [arrSelectors removeObject:dicSelector];
            i--; //To make sure the next item is checked
        }
    }
    
    marrSelectors = arrSelectors;
}

-(void)removeAllTargets
{
    [marrSelectors removeAllObjects];
}

-(void)controlEventOccured:(PPButtonControlEvent)controlEvent
{
    for (NSDictionary *dicSelector in marrSelectors)
    {
        if ([[dicSelector objectForKey:@"controlEvent"]intValue] == controlEvent)
        {
            id target = [dicSelector objectForKey:@"target"];
            
            SEL selector = [[dicSelector objectForKey:@"selector"]pointerValue];
            
            id object = [dicSelector objectForKey:@"object"];
            
            if (object == nil) {
                NSLog(@"按钮name不能为空");
            }
            
            IMP imp = [target methodForSelector:selector];
            
            if (object)
            {
                void (*func)(id, SEL, id) = (void*)imp;
                func (target, selector, object);
            }
            else
            {
                void (*func)(id, SEL) = (void *)imp;
                func(target, selector);
            }
        }
    }
}



@end
