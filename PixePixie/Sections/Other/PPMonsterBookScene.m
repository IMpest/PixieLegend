
#import "PPMonsterBookScene.h"

@implementation PPMonsterBookScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size])
    {
        [self setBackTitleText:@"图鉴" andPositionY:360];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
