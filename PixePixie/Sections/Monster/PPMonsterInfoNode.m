
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
        SKSpriteNode * buffButton = [[SKSpriteNode alloc] initWithImageNamed:@"buff_exp"];
        buffButton.position = CGPointMake(140, i * 40 + 20);
        buffButton.size = CGSizeMake(25, 25);
        [self addChild:buffButton];
    }
    
    // 添加喂食按钮
    PPSpriteButton * feedButton = [PPSpriteButton buttonWithImageNamed:@"bt_monster_feed"];
    feedButton.name = @"btnFeed";
    feedButton.size = CGSizeMake(72, 22);
    feedButton.position = CGPointMake(0, -150);
    [feedButton setLabelWithText:@"FEED" andFont:[UIFont systemFontOfSize:12] withColor:nil];
    [feedButton addTarget:self selector:@selector(clickFeed:) withObject:feedButton.name
          forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:feedButton];
}

-(void)clickFeed:(NSString *)stringName
{}

-(void)clickPixie:(NSString *)words
{
    if (isAction) return;
    isAction = YES;
    
    // 开始卖萌
    CGFloat timeCost = [self letPixieDoAction:PPPixieActionTypeRun];
    [self showWords:words inSeconds:timeCost];
}

// 让宠物执行动作（返回动作需要花费的时间）
-(CGFloat)letPixieDoAction:(PPPixieActionType)pixieAction
{
    switch (pixieAction) {
        case PPPixieActionTypeRun:
        {
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
            [pixieNode runAction:walk completion:^{[self letPixieStand];}];
            return 4.0f;
        }
            break;
            
        default:
            break;
    }
    return 0.0;
}

// 显示宠物想说的语言
-(void)showWords:(NSString *)content inSeconds:(float)time
{
    if (time < 1.0) return;
    
    // 添加文字框
    SKSpriteNode * wordsFrame = [[SKSpriteNode alloc] initWithImageNamed:@"bg_words.png"];
    wordsFrame.position = CGPointMake(0, 90);
    wordsFrame.alpha = 0.0f;
    wordsFrame.xScale = 0.5f;
    wordsFrame.yScale = 0.5f;
    [self addChild:wordsFrame];
    
    // 添加文字内容
    SKLabelNode * wordsContent = [[SKLabelNode alloc] init];
    wordsContent.position = CGPointMake(0, 0);
    wordsContent.text = content;
    wordsContent.fontColor = [UIColor blackColor];
    [wordsFrame addChild:wordsContent];
    
    SKAction * show = [SKAction sequence:@[[SKAction fadeAlphaTo:0.8f duration:0.5f],
                                           [SKAction waitForDuration:time - 1.0f],
                                           [SKAction fadeOutWithDuration:0.5f]]];
    [wordsFrame runAction:show completion:^{[wordsFrame removeFromParent];}];
}


// 恢复正常的站立动作
-(void)letPixieStand{
    [pixieNode removeAllActions];
    NSString * str = [NSString stringWithFormat:@"%@_stop", pixieCurrent.getTextureName];
    SKAction * stand = [SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:str]];
    [pixieNode runAction:stand];
    isAction = NO;
}

@end
