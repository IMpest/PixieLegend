
#import "PPBattleInfoLayer.h"
#import "PPAtlasManager.h"
#import "PPBattleInfoBgNode.h"

#define PP_PET_ENEMY_SIZE_VALUE 80

@implementation PPBattleInfoLayer

@synthesize target = _target;
@synthesize skillSelector = _skillSelector;
@synthesize currentPPPixie;
@synthesize currentPPPixieEnemy;
@synthesize showInfoSelector;
@synthesize hpBeenZeroSel;
@synthesize pauseSelector;
@synthesize hpChangeEnd;
@synthesize skillInvalidSel;

-(void)setSideElements:(PPPixie *)petppixie andEnemy:(PPPixie *)enemyppixie andSceneString:(NSString *)sceneString andIndex:(int)index
{
    
    originX = -65.0f;
    originEnemyX = 90.0f;
    originY = 40.0f;
    
    self.currentPPPixie = petppixie;
    self.currentPPPixieEnemy = enemyppixie;
    isHaveDead = NO;
    
    // 添加上方背景图片
//    SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"fight_back"];
//    bgSprite.size = CGSizeMake(320.0f, 160.0f);
//    bgSprite.position = CGPointMake(0.0f,0.0f);
//    [self addChild:bgSprite];
    
    battleBg = PPInstance(PPBattleInfoBgNode);
    battleBg.size = CGSizeMake(320.0f, 160.0f);
    battleBg.position = CGPointMake(0.0f,0.0f);
    [battleBg setColor:[UIColor orangeColor]];
    [self addChild:battleBg];
    
    
    
    // 己方头像
    ppixiePetBtn = PPInstance(SKSpriteNode);
    ppixiePetBtn.size = CGSizeMake(PP_PET_ENEMY_SIZE_VALUE, PP_PET_ENEMY_SIZE_VALUE);
    [ppixiePetBtn setPosition: CGPointMake(originX-120, originY)];
    [self addChild:ppixiePetBtn];
    
    [ppixiePetBtn runAction:[SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_stop",kElementTypeString[petppixie.pixieElement]]]]];
    NSLog(@"plantname =%@",[NSString stringWithFormat:@"%@3_stop",kElementTypeString[enemyppixie.pixieElement]]);
    


    // 己方生命条
    petPlayerHP = [PPValueShowNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 10)];
    [petPlayerHP setMaxValue:petppixie.pixieHPmax andCurrentValue:petppixie.currentHP
                 andShowType:PP_HPTYPE andAnchorPoint:CGPointMake(0.0f, 0.5f)
        andElementTypeString:kElementTypeString[petppixie.pixieElement]];
    petPlayerHP->target = self;
    petPlayerHP->animateEnd = @selector(animatePetHPEnd:);
    petPlayerHP.anchorPoint = CGPointMake(0.5, 0.5);
    petPlayerHP.position = CGPointMake(0.0f,20.0f);
    [ppixiePetBtn addChild:petPlayerHP];


    // 敌方头像
    ppixieEnemyBtn = PPInstance(SKSpriteNode);
    ppixieEnemyBtn.size = CGSizeMake(PP_PET_ENEMY_SIZE_VALUE, PP_PET_ENEMY_SIZE_VALUE);
    [ppixieEnemyBtn setPosition:CGPointMake(originEnemyX+100,ppixiePetBtn.position.y)];
    ppixieEnemyBtn.xScale = -1;
    
    
    [self addChild:ppixieEnemyBtn];
    [ppixieEnemyBtn runAction:[SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_stop",kElementTypeString[enemyppixie.pixieElement]]]]];

    
    
    // 敌方生命条
    enemyPlayerHP = [PPValueShowNode spriteNodeWithColor:[UIColor clearColor]
                                                    size:CGSizeMake(petPlayerHP.size.width, petPlayerHP.size.height)];
    [enemyPlayerHP setMaxValue:enemyppixie.pixieHPmax andCurrentValue:enemyppixie.currentHP
                   andShowType:PP_HPTYPE andAnchorPoint:CGPointMake(1.0f, 0.5f) andElementTypeString:kElementTypeString[enemyppixie.pixieElement]];
    enemyPlayerHP->target = self;
    enemyPlayerHP->animateEnd = @selector(animateEnemyHPEnd:);
    enemyPlayerHP.anchorPoint = CGPointMake(0.5, 0.5);
    enemyPlayerHP.position = CGPointMake(0.0f,20.0f);
    [ppixieEnemyBtn addChild:enemyPlayerHP];

    
    //暂停按钮
    
    PPSpriteButton *  stopBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"fight_btn_pause"] andSize:CGSizeMake(32.5, 32.5)];
    
    
    stopBtn.position = CGPointMake(-130.0f, 60.0f);
    stopBtn.name = @"stopBtn";
    [stopBtn addTarget:self selector:@selector(stopBtnClick:)
            withObject:stopBtn.name forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:stopBtn];
    
    
}

-(void)setComboLabelText:(int)petCombos withEnemy:(int)enemyCombos
{
    
    NSLog(@"combos:%d,%d",petCombos,enemyCombos);
    
    SKLabelNode *petCombosLabel = (SKLabelNode *)[self childNodeWithName:PP_PET_COMBOS_NAME];
    SKLabelNode *enemyCombosLabel = (SKLabelNode *)[self childNodeWithName:PP_ENEMY_COMBOS_NAME];
    
    [petCombosLabel setText:[NSString stringWithFormat:@"连击:%d", petCombos]];
    [enemyCombosLabel setText:[NSString stringWithFormat:@"连击:%d", enemyCombos]];
}

-(void)stopBtnClick:(NSString *)stringname
{
    
    
    
    if (self.target != nil && self.pauseSelector != nil &&
        [self.target respondsToSelector:self.pauseSelector])
    {
        [self.target performSelectorInBackground:self.pauseSelector withObject:self.name];
    }
}

-(void)physicsAttackClick:(PPCustomButton *)sender
{
    if (self.target != nil && self.showInfoSelector != nil && [self.target respondsToSelector:self.showInfoSelector])
    {
        [self.target performSelectorInBackground:self.showInfoSelector withObject:self.name];
    }
}
-(void)buffBtnClick:(NSString *)senderName
{
    
    
}
-(void)skillInvalidClick:(PPSpriteButton *)sender
{
    
    NSDictionary *skillChoosed = [self.currentPPPixie.pixieSkills objectAtIndex:[sender.name intValue] - PP_SKILLS_CHOOSE_BTN_TAG];
    
    if (self.target!=nil && self.skillInvalidSel!=nil && [self.target respondsToSelector:self.skillInvalidSel])
    {
        [self.target performSelectorInBackground:self.skillInvalidSel withObject:skillChoosed];
    }
    
}
-(void)skillSideClick:(PPSpriteButton *)sender
{
    
    NSDictionary *skillChoosed = [self.currentPPPixie.pixieSkills objectAtIndex:[sender.name intValue] - PP_SKILLS_CHOOSE_BTN_TAG];
    
    
    if (self.target!=nil && self.skillSelector!=nil && [self.target respondsToSelector:self.skillSelector])
    {
        [self.target performSelectorInBackground:self.skillSelector withObject:skillChoosed];
        
    }
    
}

-(void)enemyskillClick:(PPCustomButton *)sender
{
    NSDictionary * skillChoosed = [self.currentPPPixieEnemy.pixieSkills objectAtIndex:[sender.name intValue] - PP_SKILLS_CHOOSE_BTN_TAG];
    
    if (self.target != nil && self.skillSelector != nil && [self.target respondsToSelector:self.skillSelector])
    {
        [self.target performSelectorInBackground:self.skillSelector withObject:skillChoosed];
    }
}
-(void)updateSkllCDStatus
{
}

-(void)setSideSkillButtonDisable
{
    for (int i = 0; i < [currentPPPixie.pixieSkills count]; i++) {
        PPSpriteButton * ppixieSkillBtn  = (PPSpriteButton *)[self childNodeWithName:[NSString stringWithFormat:@"%d",PP_SKILLS_CHOOSE_BTN_TAG+i]];
        
        //        ppixieSkillBtn.alpha = 0.5;
        ppixieSkillBtn.color = [UIColor blackColor];
        ppixieSkillBtn.colorBlendFactor = 0.6;
        ppixieSkillBtn.userInteractionEnabled = NO;
    }
}

-(void)setSideSkillButtonEnable
{
    for (int i = 0; i < [currentPPPixie.pixieSkills count]; i++)
    {
        PPSpriteButton * ppixieSkillBtn  = (PPSpriteButton *)[self childNodeWithName:[NSString stringWithFormat:@"%d",PP_SKILLS_CHOOSE_BTN_TAG+i]];
        
        //        ppixieSkillBtn.alpha = 1.0;
        ppixieSkillBtn.color = [UIColor orangeColor];
        ppixieSkillBtn.colorBlendFactor = 0.0;
        ppixieSkillBtn.userInteractionEnabled = YES;
    }
}

-(void)setBufferBar:(NSArray *)buffs
{
}

-(void)animatePetMPEnd:(NSNumber *)currentMp
{
}

-(void)animateEnemyMPEnd:(NSNumber *)currentMp
{
}

-(void)animatePetHPEnd:(NSNumber *)currentHp
{
    if ([currentHp intValue] <= 0.0f) {
        if (!isHaveDead) {
            if (self.target != nil && self.hpBeenZeroSel != nil && [self.target respondsToSelector:self.hpBeenZeroSel]) {
                isHaveDead = YES;
                [self.target performSelectorInBackground:self.hpBeenZeroSel withObject:PP_PET_PLAYER_SIDE_NODE_NAME];
            }
        }
    } else {
        isHaveDead = NO;
        if (self.target != nil && self.hpChangeEnd != nil && [self.target respondsToSelector:self.hpChangeEnd]) {
            [self.target performSelectorInBackground:self.hpChangeEnd withObject:PP_PET_PLAYER_SIDE_NODE_NAME];
        }
    }
}

-(void)animateEnemyHPEnd:(NSNumber *)currentHp
{
    if ([currentHp intValue] <= 0.0f) {
        if (!isHaveDead) {
            if (self.target != nil && self.hpBeenZeroSel != nil && [self.target respondsToSelector:self.hpBeenZeroSel]) {
                isHaveDead = YES;
                [self.target performSelectorInBackground:self.hpBeenZeroSel withObject:PP_ENEMY_SIDE_NODE_NAME];
            }
        }
    } else {
        isHaveDead = NO;
        if (self.target != nil && self.hpChangeEnd != nil && [self.target respondsToSelector:self.hpChangeEnd]) {
            [self.target performSelectorInBackground:self.hpChangeEnd withObject:PP_ENEMY_SIDE_NODE_NAME];
        }
    }
}

-(void)changePetHPValue:(CGFloat)HPValue
{
    
    if (HPValue<0.0f) {
        SKSpriteNode *additonLabel = [self getNumber:fabsf(HPValue) AndColor:@"white"];
        //    additonLabel.name  = @"hpchange";
        //    additonLabel.fontColor = [UIColor redColor];
        additonLabel.position = ppixiePetBtn.position;
        
        [self addChild:additonLabel];
        
        SKAction * actionScale = [SKAction scaleBy:1.5 duration:0.2];
        SKAction * actionFade = [SKAction fadeAlphaTo:0.0f duration:0.3];
        SKAction * showAction = [SKAction sequence:[NSArray arrayWithObjects:actionScale, actionFade, nil]];
        
        [additonLabel runAction:showAction completion:^{
            if (additonLabel) {
                [additonLabel removeFromParent];

            }
        }];
    }
    self.currentPPPixie.currentHP = [petPlayerHP valueShowChangeMaxValue:0 andCurrentValue:HPValue];
}

-(void)changeEnemyHPValue:(CGFloat)HPValue
{
    if (HPValue < 0.0f) {
        SKSpriteNode *additonLabel = [self getNumber:fabsf(HPValue) AndColor:@"white"];
        //    additonLabel.name  = @"hpchange";
        //    additonLabel.fontColor = [UIColor redColor];
        additonLabel.position = ppixieEnemyBtn.position;
        [self addChild:additonLabel];
        
        SKAction * actionScale = [SKAction scaleBy:1.5 duration:0.2];
        SKAction * actionFade = [SKAction fadeAlphaTo:0.0f duration:0.3];
        SKAction * showAction = [SKAction sequence:[NSArray arrayWithObjects:actionScale, actionFade, nil]];
        
        [additonLabel runAction:showAction completion:^{
            if (additonLabel) {
                [additonLabel removeFromParent];

            }
        }];
    }
    
    
    self.currentPPPixieEnemy.currentHP =  [enemyPlayerHP valueShowChangeMaxValue:0 andCurrentValue:HPValue];
}

-(int)physicsAttackHPChangeValueCalculate
{
    return 300;
}
-(void)changePetMPValue:(CGFloat)MPValue
{
    self.currentPPPixie.currentMP = [petPlayerMP valueShowChangeMaxValue:0 andCurrentValue:MPValue];
}

-(void)changeEnemyMPValue:(CGFloat)MPValue
{
    self.currentPPPixieEnemy.currentMP =  [enemyPlayerMP valueShowChangeMaxValue:0 andCurrentValue:MPValue];
}

-(void)changeHPValue:(CGFloat)HPValue
{
}

-(SKSpriteNode *)getNumber:(int)number AndColor:(NSString *)color {
    
    NSLog(@"color=%@ number=%d",color,number);
    
    SKSpriteNode *tNode = PPInstance(SKSpriteNode);
    if (number < 1 || color == nil) return tNode;
    
    float width = 13.0f;
    
    // 拼接数字图片
    int i = 0;
    while (number > 0) {
        i++;
        int tNum = number % 10;
        number /= 10;
        
        NSString * tNumName = [NSString stringWithFormat:@"%@_%d.png", color, tNum];
        SKSpriteNode *tNumNode = [SKSpriteNode spriteNodeWithTexture:[[PPAtlasManager ui_number] textureNamed:tNumName]];
        tNumNode.position = CGPointMake(-width * i, 0);
        tNumNode.xScale = 0.5;
        tNumNode.yScale = 0.5;
        [tNode addChild:tNumNode];
    }
    
    // 调整位置居中
    for (SKSpriteNode *numNode in [tNode children]) {
        numNode.position = CGPointMake(numNode.position.x + (i+1) * width / 2, numNode.position.y);
    }
    return tNode;
}

-(void)startAttackAnimation:(BOOL)isPetAttack
{
    if (isPetAttack)
    {
        SKSpriteNode *spriteNodeMoving = [SKSpriteNode spriteNodeWithImageNamed:@"moving_0000"];
        spriteNodeMoving.name = @"spriteNodeMoving";
        spriteNodeMoving.position = ppixiePetBtn.position;
        [self addChild:spriteNodeMoving];
        
        SKAction * actionMove = [SKAction moveToX:91.5f duration:1];
        spriteNodeMoving.size = CGSizeMake(spriteNodeMoving.size.width / 2, spriteNodeMoving.size.height / 2);
        SKAction * actionEffect = [SKAction repeatAction:[[PPAtlasManager battle_fight_effect] getAnimation:@"moving"] count:2];
        [spriteNodeMoving runAction:[SKAction group:[NSArray arrayWithObjects:actionMove,actionEffect, nil]]
                         completion:
         ^{
            spriteNodeMoving.hidden = YES;
            [spriteNodeMoving removeFromParent];
         }];
        ppixiePetBtn.position = CGPointMake(ppixieEnemyBtn.position.x - 40.0f, originY);
        
        [ppixieEnemyBtn runAction:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_beated",kElementTypeString[currentPPPixieEnemy.pixieElement]]]];
    } else {
        SKSpriteNode *spriteNodeMoving = [SKSpriteNode spriteNodeWithImageNamed:@"moving_0000"];
        spriteNodeMoving.position = ppixieEnemyBtn.position;
        spriteNodeMoving.name = @"spriteNodeMoving";
        spriteNodeMoving.size = CGSizeMake(spriteNodeMoving.size.width/2.0f, spriteNodeMoving.size.height/2.0f);
        spriteNodeMoving.xScale = -1;

        [self addChild:spriteNodeMoving];
        
        SKAction * actionMove = [SKAction moveToX:-61.5f duration:1];
        SKAction * actionEffect = [SKAction repeatAction:[[PPAtlasManager battle_fight_effect] getAnimation:@"moving"] count:2];
        [spriteNodeMoving runAction:[SKAction group:[NSArray arrayWithObjects:actionMove,actionEffect, nil]] completion:
         ^{
            spriteNodeMoving.hidden = YES;
            [spriteNodeMoving removeFromParent];
         }];
        
        ppixieEnemyBtn.position = CGPointMake(originX + 20, ppixieEnemyBtn.position.y);

        SKAction * actionBeated = [[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_beated",kElementTypeString[currentPPPixie.pixieElement]]];
        
        NSLog(@"beated =%@",kElementTypeString[currentPPPixie.pixieElement]);
        
        [ppixiePetBtn runAction:actionBeated completion:^{
            
        }];
        
    }
}

-(void)startAttackShowAnimation:(BOOL)isPetAttack
{
    
    if (isPetAttack)
    {
        [ppixiePetBtn runAction:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_hit",kElementTypeString[currentPPPixie.pixieElement]]] completion:^{
            
        }];
    }
    else
    {
        [ppixieEnemyBtn runAction:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_hit",kElementTypeString[currentPPPixieEnemy.pixieElement]]] completion:^{
            
        }];
    }
}

-(void)resetPetAndEnemyPosition
{
    [ppixiePetBtn setPosition:CGPointMake(originX, originY)];
    [ppixieEnemyBtn setPosition:CGPointMake(originEnemyX,ppixiePetBtn.position.y)];
}

-(void)showRattanTwineAnimation:(BOOL)isPetShow
{
    if (isPetShow)
    {
        SKSpriteNode *buffRatShowNode = PPInstance(SKSpriteNode);
        buffRatShowNode.size = CGSizeMake(50.0f, 50.0f);
        
        [buffRatShowNode setPosition:CGPointMake(-25.0f, 0.0f)];
        buffRatShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine];
        
        [ppixiePetBtn addChild:buffRatShowNode];
        
        SKAction *actionReprat = [SKAction repeatActionForever:[[PPAtlasManager battle_fight_skill] getAnimation:@"03_rattantwine"]];
        [buffRatShowNode runAction:actionReprat];
    }
    else
    {
        SKSpriteNode *buffShowNode = [PPAtlasManager createSpriteImageName:@"buff_rooted_dis_0000" withPos:CGPointMake(0.0f, 0.0f) withSize:CGSizeMake(115.0f, 107.0f) withName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine]];
        SKAction *actionRep = [[PPAtlasManager battle_table_buff] getAnimation:@"buff_rooted_apr"];
        [ppixieEnemyBtn addChild:buffShowNode];
        [buffShowNode runAction:actionRep];
    }
}

#pragma mark show

-(void)beginTheBattle:(void(^)(void))complete
{
    SKAction *actionPetMove = [SKAction moveToX:originX duration:2];
    SKAction *actionEnemyMove = [SKAction moveToX:originEnemyX duration:2];

    [ppixiePetBtn runAction:actionPetMove completion:^{
        
    
    }];
    [ppixieEnemyBtn runAction:actionEnemyMove completion:^{
    
        complete();
    
    }];
}

-(void)moveBackGround:(CGFloat)speedValue
{
    [battleBg backgroundMove:speedValue];
}
@end
