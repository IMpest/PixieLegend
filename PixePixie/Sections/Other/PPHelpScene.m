
#import "PPHelpScene.h"

@implementation PPHelpScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self addTitle:@"帮助" andBackButton:360];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
