
#import "PPHelpScene.h"

@implementation PPHelpScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self setBackTitleText:@"帮助" andPositionY:360];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
