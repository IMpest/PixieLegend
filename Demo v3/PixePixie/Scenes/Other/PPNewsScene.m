
#import "PPNewsScene.h"

@implementation PPNewsScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size])
    {
        [self addTitle:@"新闻" andBackButton:360.0f];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
