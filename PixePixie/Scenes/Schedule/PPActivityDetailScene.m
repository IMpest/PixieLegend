
#import "PPActivityDetailScene.h"

@implementation PPActivityDetailScene

BOOL isRolling;
PPSpriteButton * turnWheel;
SKSpriteNode * turnArrow;

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self addDefaultBackground];
        [self addTitle:@"日常任务" andBackButton:360.0f];
        [self addTurnWheel];
        
        isRolling = NO;
    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

-(void)addTurnWheel
{
    turnWheel = [PPSpriteButton buttonWithImageNamed:@"round.png"];
    turnWheel.position = CGPointMake(160, PP_FIT_TOP_SIZE + 130);
    turnWheel.size = CGSizeMake(260, 260);
    turnWheel.name = @"turnWheel";
    [turnWheel addTarget:self selector:@selector(rollItem:) withObject:turnWheel.name
         forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:turnWheel];
    
    turnArrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    turnArrow.position = CGPointMake(160, PP_FIT_TOP_SIZE + 130);
    turnArrow.size = CGSizeMake(30, 60);
    turnArrow.anchorPoint = CGPointMake(0.5, 0.18);
    [self addChild:turnArrow];
}

-(void)rollItem:(id)sender
{
    if (isRolling) return;
    isRolling = YES;
    
    SKAction * roll = [SKAction rotateByAngle:-3.1415/4*(arc4random()%72) duration:0.5f];
    [turnArrow runAction:roll completion:^{isRolling = NO;}];
}

@end
