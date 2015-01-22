
#import "PPOptionsScene.h"

@implementation PPOptionsScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size])
    {
        [self setBackTitleText:@"Options" andPositionY:360.0f];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
