

#import "PPHelpScene.h"

@implementation PPHelpScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self setBackTitleText:@"Help" andPositionY:360.0f];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
