
#import "PPActivityDetailScene.h"

@implementation PPActivityDetailScene

-(id)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        [self addDefaultBackground];
        [self addTitle:@"日常任务" andBackButton:360.0f];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
