
#import "PPMonsterInfoNode.h"

@implementation PPMonsterInfoNode

-(void)initMonsterInfo:(PPPixie *)pixie
{
    if (pixie == nil) return;
    
    // 添加宠物
    SKSpriteNode * pixieNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)];
    pixieNode.position = CGPointMake(-75, 0);
    [self addChild:pixieNode];
    
    NSString * str = [NSString stringWithFormat:@"%@_move", pixie.getTextureName];
    SKAction * stand = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
    SKAction * walk = [SKAction sequence:@[[SKAction moveByX:150 y:0 duration:8.0f],
                                           [SKAction waitForDuration:1.0f],
                                           [SKAction scaleXTo:-1 duration:0.0f],
                                           [SKAction moveByX:-150 y:0 duration:8.0f],
                                           [SKAction waitForDuration:1.0f],
                                           [SKAction scaleXTo:1 duration:0.0f]]];
    [pixieNode runAction:stand];
    [pixieNode runAction:[SKAction repeatActionForever:walk]];
    
    // 添加状态
    for (int i = 0; i < 3; i++) {
        PPSpriteButton * buffButton = [PPSpriteButton buttonWithImageNamed:@"buff_exp"];
        buffButton.position = CGPointMake(130, i * 40 + 20);
        buffButton.size = CGSizeMake(25, 25);
        [buffButton addTarget:self selector:@selector(buffButtonClick:)
                   withObject:buffButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:buffButton];
    }
    
    // 添加喂食按钮
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
