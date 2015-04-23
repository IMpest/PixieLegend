
#import "PPMenuScene.h"
#import "PPFightingMainView.h"

@implementation PPMenuScene

-(id)initWithSize:(CGSize)size andElement:(PPElementType)elementType{
    if (self = [super initWithSize:size]) {
        
        [self addTitle:@"场景菜单" andBackButton:440];
        
        // 添加背景
        NSString * mapName = [NSString stringWithFormat:@"%@.png", @"bg_menu"];
        SKSpriteNode *spriteBackNode = [SKSpriteNode spriteNodeWithImageNamed:mapName];
        spriteBackNode.position = CGPointMake(self.size.width/2.0f, self.size.height/2.0f);
        spriteBackNode.size = PP_FULLSCREEN_FRAME.size;
        [self addChild:spriteBackNode];
        
        
        // 添加按钮
        for (int i = 0; i < 5; i++) {
            
            PPSpriteButton *  passButton = [PPSpriteButton  buttonWithImageNamed:@"bt_dungeon"];
            [passButton setLabelWithText:[NSString stringWithFormat:@"关卡 %d", 5 - i]
                                 andFont:[UIFont systemFontOfSize:15] withColor:[UIColor blackColor]];
            passButton.size = CGSizeMake(120, 40);
            passButton.position = CGPointMake(160, i * 70 + 80);
            passButton.name = [NSString stringWithFormat:@"%d",i+PP_SECONDARY_PASSNUM_BTN_TAG];
            [passButton addTarget:self selector:@selector(menuDungeonGoForward:)
                       withObject:passButton.name forControlEvent:PPButtonControlEventTouchUpInside];
            [self addChild:passButton];
            
            
            PPSpriteButton * passIntroduceButton = [PPSpriteButton buttonWithImageNamed:@"bt_preview"];
            passIntroduceButton.position = CGPointMake(passButton.position.x + 60, passButton.position.y + 20);
            passIntroduceButton.size = CGSizeMake(30, 30);
            passIntroduceButton.name = [NSString stringWithFormat:@"副本%d介绍",5 - i];
            [passIntroduceButton addTarget:self selector:@selector(introduceInfoLabel:)
                                withObject:passIntroduceButton.name
                           forControlEvent:PPButtonControlEventTouchUpInside];
            [self addChild:passIntroduceButton];
        }
        
        
        PPSpriteButton *  passButton = [PPSpriteButton  buttonWithImageNamed:@"bt_dungeon"];
        [passButton setLabelWithText:@"新手教程"
                             andFont:[UIFont systemFontOfSize:15] withColor:[UIColor blackColor]];
        passButton.size = CGSizeMake(140, 40);
        passButton.position = CGPointMake(240, 440);
        passButton.name =@"newPlayerGuide";
        [passButton addTarget:self selector:@selector(newPlayerGuide:)
                   withObject:passButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:passButton];
        
        
    }
    return self;
}
-(void)newPlayerGuide:(NSString *)stringName
{
    
    NSDictionary * pixiesInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PixiesInfo"
                                                                                                           ofType:@"plist"]];
    
    NSDictionary * petsChoosedInfo = [[pixiesInfo objectForKey:@"userpetinfo"] objectAtIndex:0];
    PPPixie *playerPixie = [PPPixie pixieWithData:petsChoosedInfo];
    [playerPixie setPetSkillList:petsChoosedInfo];
    NSDictionary * enemyDicInfo = [[pixiesInfo objectForKey:@"enemysinfo"] objectAtIndex:0];
    NSLog(@"playerPixie = %lu",(unsigned long)[playerPixie.skillList count]);
    PPPixie *enemyPixie = [PPPixie pixieWithData:enemyDicInfo];
    
    
    if (playerPixie == nil || enemyPixie == nil) return;
    
    // 创建战斗场景并显示
    PPBallBattleScene * ballScene = [[PPBallBattleScene alloc] initWithSize:CURRENT_DEVICE_REAL_SIZE
                                                                PixiePlayer:playerPixie
                                                                 PixieEnemy:enemyPixie
                                                               andSceneType:PPElementTypeFire
andIndex:0 withTutorial:YES];
    ballScene.scaleMode = SKSceneScaleModeAspectFill;
    ballScene.enmeysArray = [pixiesInfo objectForKey:@"enemysinfo"];
    ballScene->previousScene = self;
    [ballScene setEnemyAtIndex:0];
    [self.view presentScene:ballScene];
    
}
// 介绍窗口
-(void)introduceInfoLabel:(NSString *)text
{
    SKSpriteNode *enemyDeadContent = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(320, 350)];
    [enemyDeadContent setPosition:CGPointMake(160, 200)];
    [self addChild:enemyDeadContent];
    
    SKLabelNode * labelNode = (SKLabelNode *)[self childNodeWithName:@"RoundLabel"];
    if (labelNode) [labelNode removeFromParent];
    
    SKLabelNode * additonLabel = PP_INSTANCE(SKLabelNode);
    additonLabel.name  = @"titleLabel";
    additonLabel.fontColor = [UIColor redColor];
    additonLabel.position = CGPointMake(0, 100);
    [additonLabel setText:text];
    [enemyDeadContent addChild:additonLabel];
    
    SKLabelNode * infoContentLabel = PP_INSTANCE(SKLabelNode);
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

// 直接进入战斗场景
-(void)menuDungeonGoForward:(NSString *)stringName
{
    NSDictionary * pixiesInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PixiesInfo"
                                                                                                            ofType:@"plist"]];
    
    NSDictionary * petsChoosedInfo = [[pixiesInfo objectForKey:@"userpetinfo"] objectAtIndex:0];
    PPPixie *playerPixie = [PPPixie pixieWithData:petsChoosedInfo];
    [playerPixie setPetSkillList:petsChoosedInfo];
    NSDictionary * enemyDicInfo = [[pixiesInfo objectForKey:@"enemysinfo"] objectAtIndex:0];
    NSLog(@"playerPixie = %lu",(unsigned long)[playerPixie.skillList count]);
    PPPixie *enemyPixie = [PPPixie pixieWithData:enemyDicInfo];
    
    
    NSLog(@"petsChoosedInfo = %@,enemyDicInfo = %@",petsChoosedInfo,enemyDicInfo);
    
    //    PPPixie *playerPixie = [PPPixie birthPixieWithPetsInfo:petsChoosedInfo];
    //    PPPixie *enemyPixie = [PPPixie birthEnemyPixieWithPetsInfo:enemyDicInfo];
    
    if (playerPixie == nil || enemyPixie == nil) return;
    
    // 创建战斗场景并显示
    PPBallBattleScene * ballScene = [[PPBallBattleScene alloc] initWithSize:CURRENT_DEVICE_REAL_SIZE
                                                                PixiePlayer:playerPixie
                                                                 PixieEnemy:enemyPixie
                                                               andSceneType:PPElementTypeFire
                                                                   andIndex:0 withTutorial:NO];
//    ballScene.hurdleReady = self;
    ballScene.scaleMode = SKSceneScaleModeAspectFill;
    ballScene.enmeysArray = [pixiesInfo objectForKey:@"enemysinfo"];
    ballScene->previousScene = self;
    [ballScene setEnemyAtIndex:0];
    [self.view presentScene:ballScene];
    
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
//    PPPixie *playerPixie = [PPPixie birthPixieWithPetsInfo:choosedPet];
//    PPPixie *enemyPixie = [PPPixie birthEnemyPixieWithPetsInfo:[enemysArray objectAtIndex:currentEnemyIndex]];
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
