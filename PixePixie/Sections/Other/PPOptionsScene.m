
#import "PPOptionsScene.h"

@implementation PPOptionsScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]){
        [self setBackTitleText:@"设置" andPositionY:360];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
