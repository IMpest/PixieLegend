
#import "PPCookingScene.h"

static NSString * monsterBtnTitle [] = {
    @"清空",
    @"食材",
    @"烹饪"
};

@implementation PPCookingScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self addDefaultBackground];
        [self addTitle:@"Cooking" andBackButton:360.0f];
        
        SKSpriteNode *contentSpriteNode = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(280, 200)];
        contentSpriteNode.position = CGPointMake(160, 220);
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
        
        for (int i = 0; i < 3; i++) {
            PPSpriteButton * handleButton = [PPSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(70, 40)];
            [handleButton addChild:[PPNodeTools getButtonDefault:handleButton.size]];
            [handleButton setLabelWithText:monsterBtnTitle[i] andFont:[UIFont systemFontOfSize:11] withColor:[UIColor blackColor]];
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
                    handleButton.position = CGPointMake(260, 40);
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
{}

-(void)monsterBoxButtonClick:(NSString *)stringName
{}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}

@end
