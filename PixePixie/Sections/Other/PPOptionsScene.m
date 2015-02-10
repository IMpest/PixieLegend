
#import "PPOptionsScene.h"

@implementation PPOptionsScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]){
        [self addTitle:@"设置" andBackButton:360];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
