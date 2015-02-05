
#import "PPNewsScene.h"

@implementation PPNewsScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size])
    {
        [self setBackTitleText:@"新闻" andPositionY:360.0f];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
