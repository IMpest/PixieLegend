
#import "PPMonsterInfoNode.h"

@implementation PPMonsterInfoNode

BOOL isAction;
PPSpriteButton * pixieNode;
PPPixie * pixieCurrent;

-(void)initMonsterInfo:(PPPixie *)pixie
{
    if (pixie == nil) return;
    pixieCurrent = pixie;
    isAction = NO;
    
    // 添加宠物
    pixieNode = [PPSpriteButton buttonWithImageNamed:[NSString stringWithFormat:@"%@_card", pixie.getTextureName]];
    pixieNode.size = CGSizeMake(100, 100);
    pixieNode.position = CGPointMake(0, 0);
    [pixieNode addTarget:self selector:@selector(clickPixie:) withObject:@"=w=凸" forControlEvent:PPButtonControlEventTouchUpInside];
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

-(void)clickPixie:(NSString *)words{
    
    if (isAction) return;
    isAction = YES;
    
    // 添加文字
    SKSpriteNode * wordsFrame = [[SKSpriteNode alloc] initWithImageNamed:@"bg_words.png"];
    wordsFrame.position = CGPointMake(0, 90);
    wordsFrame.alpha = 0.0f;
    wordsFrame.xScale = 0.5f;
    wordsFrame.yScale = 0.5f;
    [self addChild:wordsFrame];
    
    SKLabelNode * wordsContent = [[SKLabelNode alloc] init];
    wordsContent.position = CGPointMake(0, 0);
    wordsContent.text = words;
    wordsContent.fontColor = [UIColor blackColor];
    [wordsFrame addChild:wordsContent];
    
    SKAction * show = [SKAction sequence:@[[SKAction fadeInWithDuration:0.5f],
                                           [SKAction waitForDuration:3.0f],
                                           [SKAction fadeOutWithDuration:0.5f]]];
    [wordsFrame runAction:show completion:^{[wordsFrame removeFromParent];}];
    
    // 添加宠物跑步动画
    NSString * str = [NSString stringWithFormat:@"%@_move", pixieCurrent.getTextureName];
    SKAction * move = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
    [pixieNode runAction:move];
    
    SKAction * walk = [SKAction sequence:@[[SKAction moveByX:50 y:0 duration:1.0f],
                                           [SKAction waitForDuration:0.1f],
                                           [SKAction scaleXTo:-1 duration:0.0f],
                                           [SKAction moveByX:-100 y:0 duration:2.0f],
                                           [SKAction waitForDuration:0.1f],
                                           [SKAction scaleXTo:1 duration:0.0f],
                                           [SKAction moveByX:50 y:0 duration:1.0f]]];
    [pixieNode runAction:walk completion:^{
        // 恢复正常的站立动作
        [pixieNode removeAllActions];
        NSString * str = [NSString stringWithFormat:@"%@_stop", pixieCurrent.getTextureName];
        SKAction * stand = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
        [pixieNode runAction:stand];
        isAction = NO;
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
