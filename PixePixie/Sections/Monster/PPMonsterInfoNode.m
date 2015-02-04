
#import "PPMonsterInfoNode.h"

@implementation PPMonsterInfoNode

PPSpriteButton * pixieNode;
PPPixie * pixieCurrent;

-(void)initMonsterInfo:(PPPixie *)pixie
{
    if (pixie == nil) return;
    pixieCurrent = pixie;
    
    // 添加宠物
    pixieNode = [PPSpriteButton buttonWithImageNamed:[NSString stringWithFormat:@"%@_card", pixie.getTextureName]];
    pixieNode.size = CGSizeMake(100, 100);
    pixieNode.position = CGPointMake(0, 0);
    [pixieNode addTarget:self selector:@selector(clickPixie:) withObject:@"pixie" forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:pixieNode];
    
    NSString * str = [NSString stringWithFormat:@"%@_stop", pixie.getTextureName];
    SKAction * stand = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
    [pixieNode runAction:stand];
    
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

-(void)clickPixie:(NSString *)name{
    
    NSString * str = [NSString stringWithFormat:@"%@_move", pixieCurrent.getTextureName];
    SKAction * move = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
    [pixieNode runAction:move];
    
    SKAction * walk = [SKAction sequence:@[[SKAction moveByX:50 y:0 duration:1.0f],
                                           [SKAction waitForDuration:0.1f],
                                           [SKAction scaleXTo:-1 duration:0.0f],
                                           [SKAction moveByX:-50 y:0 duration:1.0f],
                                           [SKAction waitForDuration:0.1f],
                                           [SKAction scaleXTo:1 duration:0.0f]]];
    [pixieNode runAction:walk completion:^{
        [pixieNode removeAllActions];
        NSString * str = [NSString stringWithFormat:@"%@_stop", pixieCurrent.getTextureName];
        SKAction * stand = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
        [pixieNode runAction:stand];
    }];
    
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
