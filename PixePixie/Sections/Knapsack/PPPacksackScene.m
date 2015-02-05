
#import "PPPacksackScene.h"

static NSString * monsterBtnTitle[] = {
    @"Clear",
    @"Acquire coins",
    @"Drop box",
    @"Sell monster",
    @"Cooking"
};

@implementation PPPacksackScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self setUsingDefaultBackground];
//        [self setBackTitleText:@"Knapsack" andPositionY:360];

        SKSpriteNode * contentSpriteNode = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(280, 200)];
        contentSpriteNode.position = CGPointMake(160, 230);
        contentSpriteNode.name = @"contentMonsterBox";
        SKTexture * boxTexture = nil;
        switch (0) {
            case 0:
            {
                boxTexture = [SKTexture textureWithImageNamed:@"skill_plant.png"];
            }
                break;
            case 1:
            {
                boxTexture = [SKTexture textureWithImageNamed:@"skill_plant.png"];
            }
                break;
            case 2:
            {
                boxTexture = [SKTexture textureWithImageNamed:@"skill_plant.png"];
                
            }
                break;
                
            default:
                break;
        }
        
        for (int i = 0; i < 15; i++) {
            PPSpriteButton *monsterButton = [PPSpriteButton buttonWithTexture:boxTexture andSize:CGSizeMake(40, 40)];
            monsterButton.position = CGPointMake((i % 5) * 55 - 110, (i / 5) * 60 - 50);
            monsterButton.name = [NSString stringWithFormat:@"%d",i];
            [monsterButton addTarget:self selector:@selector(monsterBoxButtonClick:)
                          withObject:monsterButton.name forControlEvent:PPButtonControlEventTouchUpInside];
            [contentSpriteNode addChild:monsterButton];
        }
        [self addChild:contentSpriteNode];
        
        for (int i = 0; i < 5; i++) {
            PPSpriteButton * handleButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(70, 40)];
            [handleButton setLabelWithText:monsterBtnTitle[i] andFont:[UIFont systemFontOfSize:11] withColor:nil];
            switch (i) {
                case 0:
                {
                    handleButton.position = CGPointMake(50, 40);
                }
                    break;
                case 1:
                {
                    handleButton.position = CGPointMake(160, 90);
                }
                    break;
                case 2:
                {
                    handleButton.position = CGPointMake(160, 30);
                }
                    break;
                case 3:
                {
                    handleButton.position = CGPointMake(260, 40);
                }
                    break;
                case 4:
                {
                    handleButton.position = CGPointMake(260, 360);
                }
                    break;
                    
                default:
                    break;
            }
            handleButton.name = [NSString stringWithFormat:@"%d",i];
            [handleButton addTarget:self selector:@selector(handleButtonClick:)
                         withObject:handleButton.name forControlEvent:PPButtonControlEventTouchUpInside];
            [self addChild:handleButton];
        }
    }
    return self;
}

-(void)handleButtonClick:(NSString *)stringName
{
    switch ([stringName intValue]) {
        case 0:
        {}
            break;
        case 1:
        {}
            break;
        case 2:
        {}
            break;
        case 3:
        {}
            break;
        case 4:
        {
            PPCookingScene * mainScene = [[PPCookingScene alloc] initWithSize:self.view.bounds.size];
            mainScene->previousScene = self;
            mainScene.scaleMode = SKSceneScaleModeFill;
            [self.view presentScene:mainScene];
        }
            break;
            
        default:
            break;
    }
}

-(void)monsterBoxButtonClick:(NSString *)stringName
{}

-(void)backButtonClick:(NSString *)backName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PP_BACK_TO_MAIN_VIEW object:nil];
}

@end
