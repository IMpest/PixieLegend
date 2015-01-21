
#import "PPMenuScene.h"
#import "PPFightingMainView.h"

@implementation PPMenuScene

-(id)initWithSize:(CGSize)size andElement:(PPElementType)elementType{
    if (self = [super initWithSize:size]) {
        currentElementType = elementType;
        [self setBackgroundColor:[UIColor purpleColor]];
        NSString * mapName = [NSString stringWithFormat:@"%@.png", @"bg_menu"];

        SKSpriteNode * spriteBackNode = [SKSpriteNode spriteNodeWithImageNamed:mapName];
        spriteBackNode.position = CGPointMake(self.size.width/2.0f, self.size.height/2.0f);
        spriteBackNode.size = CGSizeMake(320.0f, 480.0f);
        [self addChild:spriteBackNode];
        [self addPassChoose];
        
        [self setBackTitleText:@"小场景" andPositionY:420.0f];
    }
    return self;
}

// 介绍窗口
-(void)introduceInfoLabel:(NSString *)text
{
    SKSpriteNode * enemyDeadContent = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(320, 350)];
    [enemyDeadContent setPosition:CGPointMake(160, 200)];
    [self addChild:enemyDeadContent];
    
    SKLabelNode * labelNode = (SKLabelNode *)[self childNodeWithName:@"RoundLabel"];
    if (labelNode) [labelNode removeFromParent];
    
    SKLabelNode * additonLabel = [[SKLabelNode alloc] init];
    additonLabel.name  = @"titleLabel";
    additonLabel.fontColor = [UIColor redColor];
    additonLabel.position = CGPointMake(0, 100);
    [additonLabel setText:text];
    [enemyDeadContent addChild:additonLabel];
    
    SKLabelNode * infoContentLabel = [[SKLabelNode alloc] init];
    infoContentLabel.name  = @"contentLabel";
    infoContentLabel.fontColor = [UIColor redColor];
    infoContentLabel.position = CGPointMake(0, 0);
    [infoContentLabel setText:@"介绍内容"];
    [enemyDeadContent addChild:infoContentLabel];
    
    PPSpriteButton * confirmButton = [PPSpriteButton buttonWithColor:[UIColor blueColor] andSize:CGSizeMake(90, 60)];
    confirmButton.position = CGPointMake(0, -100);
    [confirmButton setLabelWithText:@"知道" andFont:[UIFont systemFontOfSize:15] withColor:nil];
    [confirmButton addTarget:self selector:@selector(confirmBtnClick:) withObject:enemyDeadContent
             forControlEvent:PPButtonControlEventTouchUpInside];
    [enemyDeadContent addChild:confirmButton];
}

// 确认按钮
-(void)confirmBtnClick:(SKSpriteNode *)contentNode
{
    if (contentNode != nil) {
        [contentNode removeFromParent];
        contentNode = nil;
    }
}

// 添加按钮
-(void)addPassChoose
{
    for (int i = 0; i < 5; i++) {
        PPSpriteButton *  passButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(90, 60)];
        
        [passButton setLabelWithText:[NSString stringWithFormat:@"副本 %d",5-i] andFont:[UIFont systemFontOfSize:15] withColor:nil];
        passButton.position = CGPointMake(160.0f,i*70+40);
        passButton.name = [NSString stringWithFormat:@"%d",i+PP_SECONDARY_PASSNUM_BTN_TAG];
        [passButton addTarget:self selector:@selector(menuDungeonGoForward:)
                   withObject:passButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:passButton];
        
        PPSpriteButton * passIntroduceButton = [PPSpriteButton buttonWithColor:[UIColor redColor] andSize:CGSizeMake(30, 30)];
        [passIntroduceButton setLabelWithText:[NSString stringWithFormat:@"%d信息",5-i]
                                      andFont:[UIFont systemFontOfSize:11] withColor:nil];
        passIntroduceButton.position = CGPointMake(passButton.position.x + 60.0f,passButton.position.y + 15.0f);
        passIntroduceButton.name = [NSString stringWithFormat:@"副本%d介绍",5-i];
        [passIntroduceButton addTarget:self selector:@selector(introduceInfoLabel:)
                            withObject:passIntroduceButton.name
                       forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:passIntroduceButton];
    }
}


// 直接进入战斗场景
-(void)menuDungeonGoForward:(NSString *)stringName
{
    NSDictionary * pixiesInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PixiesInfo"
                                                                                                            ofType:@"plist"]];
    
    NSDictionary * petsChoosedInfo = [[pixiesInfo objectForKey:@"userpetinfo"] objectAtIndex:0];
    PPPixie * playerPixie = [PPPixie pixieWithData:petsChoosedInfo];
    
    NSDictionary * enemyDicInfo = [[pixiesInfo objectForKey:@"enemysinfo"] objectAtIndex:0];
    PPPixie * enemyPixie = [PPPixie pixieWithData:enemyDicInfo];
    
    
    
    NSLog(@"petsChoosedInfo=%@,enemyDicInfo=%@",petsChoosedInfo,enemyDicInfo);
    
    //    PPPixie * playerPixie = [PPPixie birthPixieWithPetsInfo:petsChoosedInfo];
    //    PPPixie * enemyPixie = [PPPixie birthEnemyPixieWithPetsInfo:enemyDicInfo];
    
    if (playerPixie == nil || enemyPixie == nil) return;
    
    // 创建战斗场景并显示
    PPBallBattleScene * ballScene = [[PPBallBattleScene alloc] initWithSize:CurrentDeviceRealSize
                                                                PixiePlayer:playerPixie
                                                                 PixieEnemy:enemyPixie  andSceneType:currentElementType];
    ballScene.scaleMode = SKSceneScaleModeAspectFill;
    //    ballScene.hurdleReady = self;
    ballScene.enmeysArray = [pixiesInfo objectForKey:@"enemysinfo"];
    ballScene->previousScene = self;
    [ballScene setEnemyAtIndex:0];
    [self.view presentScene:ballScene];
//    [self enterHurdleReady];
}


// 返回到世界地图首页
-(void)backButtonClick:(NSString *)backName
{
//    backBtn.hidden = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:PP_BACK_TO_MAIN_VIEW object:PP_BACK_TO_MAIN_VIEW_FIGHTING];
    
    [(PPFightingMainView *)self.view normalScreenForMenu];
    [self.view presentScene:nil];
    [preiviousView setMenuContentScrollView];
}

// 这里直接进入战斗画面（旧版）
//-(void)spriteChooseClick
//{
//    NSArray * petsArray = nil;
//    NSArray * enemysArray = nil;
//
//    NSDictionary * petsChoosedInfo = [petsArray objectAtIndex:302 - PP_PETS_CHOOSE_BTN_TAG];
//    NSDictionary * choosedPet = [NSDictionary dictionaryWithDictionary:petsChoosedInfo];
//
//    // 初始化 ballScene
//    PPPixie * playerPixie = [PPPixie birthPixieWithPetsInfo:choosedPet];
//    PPPixie * enemyPixie = [PPPixie birthEnemyPixieWithPetsInfo:[enemysArray objectAtIndex:currentEnemyIndex]];
//    if (playerPixie == nil || enemyPixie == nil) return;
//
//    // 创建战斗场景并显示
//    PPBallBattleScene * ballScene = [[PPBallBattleScene alloc] initWithSize:CurrentDeviceRealSize
//                                                                PixiePlayer:playerPixie
//                                                                 PixieEnemy:enemyPixie  andSceneType:currentElementType];
//
//    ballScene.scaleMode = SKSceneScaleModeAspectFill;
//    ballScene.hurdleReady = self;
//    [ballScene setEnemyAtIndex:currentEnemyIndex];
//    [self.view presentScene:ballScene];
//}

// 进入推进场景（旧版）
//-(void)enterHurdleReady
//{
//    SKNode * spriteNode = [self childNodeWithName:PP_GOFORWARD_MENU_DUNGEON_FIGHTING];
//    if (spriteNode) [spriteNode removeFromParent];
//
//    NSDictionary * dictEnemy = [NSDictionary dictionaryWithContentsOfFile:
//                                [[NSBundle mainBundle]pathForResource:@"EnemyInfo" ofType:@"plist"]];
//
//    PPHurdleReadyScene * battleScene = [[PPHurdleReadyScene alloc] initWithSize:self.view.bounds.size];
//    battleScene.allEnemys = dictEnemy;
//    battleScene->chooseSceneType = currentElementType;
//    battleScene->previousScene = self;
//    [battleScene setEnemysArray];
//    [battleScene setCurrentHurdle:0];
//    [self.view presentScene:battleScene];
//}

@end
