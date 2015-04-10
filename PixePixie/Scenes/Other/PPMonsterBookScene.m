
#import "PPMonsterBookScene.h"

@implementation PPMonsterBookScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size])
    {
        [self addTitle:@"图鉴" andBackButton:360];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
