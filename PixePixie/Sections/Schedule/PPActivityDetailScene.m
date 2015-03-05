
#import "PPActivityDetailScene.h"

@implementation PPActivityDetailScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self addDefaultBackground];
        [self addTitle:@"日常任务" andBackButton:360.0f];
        
        [self addTurnWheel];
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

-(void)addTurnWheel
{
    PPSpriteButton * turnTable = [PPSpriteButton buttonWithImageNamed:@"round.png"];
    turnTable.position = CGPointMake(160, PP_FIT_TOP_SIZE + 130);
    turnTable.size = CGSizeMake(260, 260);
    [self addChild:turnTable];
}

@end
