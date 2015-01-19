
#import "PPMonsterInfoNode.h"

@implementation PPMonsterInfoNode

-(void)initMonsterInfo:(PPPixie *)pixie
{
    SKSpriteNode * pixieNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)];
    pixieNode.position = CGPointMake(0, 0);
    [self addChild:pixieNode];
    
    NSString * str = [NSString stringWithFormat:@"%@_stop", pixie.getTextureName];
    SKAction * stand = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
    [pixieNode runAction:stand];
    
    
    for (int i = 0; i < 3; i++) {
        PPSpriteButton * buffButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(30, 30)];
        buffButton.position = CGPointMake(130, i * 40 + 20);
        buffButton.name = [NSString stringWithFormat:@"%d",i];
        [buffButton setLabelWithText:@"状态" andFont:[UIFont systemFontOfSize:15] withColor:nil];
        [buffButton addTarget:self selector:@selector(buffButtonClick:)
                   withObject:buffButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:buffButton];
    }
    
    PPSpriteButton * feedButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(30, 30)];
    feedButton.position = CGPointMake(130, -125);
    feedButton.name = @"喂食";
    [feedButton setLabelWithText:@"喂食" andFont:[UIFont systemFontOfSize:15] withColor:nil];
    [feedButton addTarget:self selector:@selector(feedButtonClick:) withObject:feedButton.name
          forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:feedButton];

}

-(void)feedButtonClick:(NSString *)stringName
{}

-(void)hungryButtonClick:(NSString *)stringName
{}

-(void)moodButtonClick:(NSString *)stringName
{}

-(void)monsterTextureClick:(NSString *)stringName
{}

-(void)buffButtonClick:(NSString *)stringName
{}

@end
