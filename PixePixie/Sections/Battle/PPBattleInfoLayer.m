
#import "PPBattleInfoLayer.h"
#import "PPAtlasManager.h"

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

// 设置技能
//-(void)setSideSkillsBtn:(PPPixie *)ppixie andSceneString:(NSString *)sceneString
//{
//    self.currentPPPixie = ppixie;
//    NSLog(@"pixieSkills count=%lu", (unsigned long)[ppixie.pixieSkills count]);
//    
//    // 添加技能槽
////    for (int i = 0; i < 4; i++) {
////        
////        NSDictionary * dictSkill = nil;
////        if ([ppixie.pixieSkills count]>i) {
////            dictSkill=[ppixie.pixieSkills objectAtIndex:i];
////        }
////        
////        NSString * stringSkillStatus = [dictSkill objectForKey:@"skillstatus"];
////        
////        NSString * stringSkillBtn = [dictSkill objectForKey:@"skillbtntexture"];
////        PPSpriteButton * passButton = nil;
////        
////        if (![stringSkillStatus isEqualToString:@"valid"]) {
////            stringSkillBtn = [NSString stringWithFormat:@"%@_none",kElementTypeString[ppixie.pixieElement]];
////            passButton = [PPSpriteButton buttonWithTexture:[[PPAtlasManager skill_icon] textureNamed:stringSkillBtn]
////                                                   andSize:CGSizeMake(50.0f, 50.0f)];
////            //            [passButton setLabelWithText:@"不可用" andFont:[UIFont boldSystemFontOfSize:14.0f] withColor:[UIColor whiteColor]];
////            passButton.PPBallSkillStatus = [dictSkill objectForKey:@"skillcdrounds"];
////            passButton.userInteractionEnabled = NO;
////            [passButton addTarget:self selector:@selector(skillInvalidClick:)
////                       withObject:passButton forControlEvent:PPButtonControlEventTouchUp];
////            
////            
////            SKLabelNode *cdLabel = [SKLabelNode labelNodeWithFontNamed:PP_WORDS_FONT_NAME];
////            cdLabel.fontSize = 10;
////            cdLabel.name = PP_SKILL_CD_LABEL_NODE_NAME;
////            cdLabel.position = CGPointMake(0,0.0f);
////            [cdLabel setColor:[UIColor orangeColor]];
////            [cdLabel setText:[NSString stringWithFormat:@"%@",[dictSkill objectForKey:@"skillcdrounds"]]];
////            [passButton addChild:cdLabel];
////            
////            
////        } else {
////            
////            passButton = [PPSpriteButton buttonWithTexture:[[PPAtlasManager skill_icon] textureNamed:stringSkillBtn]
////                                                   andSize:CGSizeMake(80.0f, 80.0f)];
////            [passButton addTarget:self selector:@selector(skillSideClick:)
////                       withObject:passButton forControlEvent:PPButtonControlEventTouchUp];
////            
////          
////            
////            
////        }
////        
////        passButton.name = [NSString stringWithFormat:@"%d",PP_SKILLS_CHOOSE_BTN_TAG+i];
////        passButton.position = CGPointMake(65*i - 112.0f, 0.0f);
////        [self addChild:passButton];
////        
////        
////        if ([ppixie.pixieSkills count] > i && [stringSkillStatus isEqualToString:@"valid"]) {
////            
////            SKLabelNode * skillName = [[SKLabelNode alloc] init];
////            skillName.fontSize = 12;
////            [skillName setText:[[ppixie.pixieSkills objectAtIndex:i] objectForKey:@"skillname"]];
////            [skillName setPosition:CGPointMake(passButton.position.x,
////                                               passButton.position.y-30.0f-skillName.frame.size.height/2.0f)];
////            [self addChild:skillName];
////            
////        }
////    }
//    
//    //暂停按钮
////    PPSpriteButton *  stopBtn = [PPSpriteButton buttonWithTexture:[[PPAtlasManager ui_fighting] textureNamed:[NSString stringWithFormat:@"%@_footer_pause",sceneString]]
////                                                          andSize:CGSizeMake(32.5, 32.5)];
//    PPSpriteButton *  stopBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"fight_btn_pause"] andSize:CGSizeMake(32.5, 32.5)];
//    //fight_btn_pause
//    stopBtn.position = CGPointMake(130.0f, 0.0f);
//    stopBtn.name = @"stopBtn";
//    [stopBtn addTarget:self selector:@selector(stopBtnClick:)
//            withObject:stopBtn.name forControlEvent:PPButtonControlEventTouchUpInside];
//    [self addChild:stopBtn];
//}

-(void)setSideElements:(PPPixie *)petppixie andEnemy:(PPPixie *)enemyppixie andSceneString:(NSString *)sceneString andIndex:(int)index
{
    
//    switch (index) {
//        case 0:
//            originX = -65.0f;
//            break;
//        case 1:
//            originX = -35.0f;
//            break;
//        case 2:
//            originX = 0.0f;
//            break;
//        case 3:
//            originX = 35.0f;
//            break;
//            
//        default:
//            break;
//    }
    originX = -65.0f;
    originEnemyX = 90.0f;
    originY = 40.0f;
    
    self.currentPPPixie = petppixie;
    self.currentPPPixieEnemy = enemyppixie;
    isHaveDead = NO;
    
    // 添加上方背景图片
    SKSpriteNode * bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"fight_back"];
    bgSprite.size = CGSizeMake(320.0f, 160.0f);
    bgSprite.position = CGPointMake(0.0f,0.0f);
    [self addChild:bgSprite];
    
    // 己方头像
    ppixiePetBtn = [[SKSpriteNode alloc] init];
    ppixiePetBtn.size = CGSizeMake(PP_PET_ENEMY_SIZE_VALUE, PP_PET_ENEMY_SIZE_VALUE);
    [ppixiePetBtn setPosition: CGPointMake(originX, originY)];
    [self addChild:ppixiePetBtn];
    
    [ppixiePetBtn runAction:[SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_stop",kElementTypeString[petppixie.pixieElement]]]]];
    NSLog(@"plantname=%@",[NSString stringWithFormat:@"%@3_stop",kElementTypeString[enemyppixie.pixieElement]]);
    
    
    // 己方连击数
    SKLabelNode *ppixiePetBtnLabel = [[SKLabelNode alloc] init];
    ppixiePetBtnLabel.fontSize = 10;
    ppixiePetBtnLabel.name = PP_PET_COMBOS_NAME;
    [ppixiePetBtnLabel setColor:[SKColor redColor]];
    NSLog(@"pixieName = %@",petppixie.pixieName);
    [ppixiePetBtnLabel setText:@"连击:0"];
    ppixiePetBtnLabel.position = CGPointMake(ppixiePetBtn.position.x,ppixiePetBtn.position.y - 80);
    [self addChild:ppixiePetBtnLabel];

    // 己方生命条
    petPlayerHP = [PPValueShowNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 10)];
    [petPlayerHP setMaxValue:petppixie.pixieHPmax andCurrentValue:petppixie.currentHP
                 andShowType:PP_HPTYPE andAnchorPoint:CGPointMake(0.0f, 0.5f)
        andElementTypeString:kElementTypeString[petppixie.pixieElement]];
    petPlayerHP->target = self;
    petPlayerHP->animateEnd = @selector(animatePetHPEnd:);
    petPlayerHP.anchorPoint = CGPointMake(0.5, 0.5);
    petPlayerHP.position = CGPointMake(ppixiePetBtn.position.x,ppixiePetBtn.position.y-60.0f);
    [self addChild:petPlayerHP];


    // 敌方头像
    ppixieEnemyBtn = [[SKSpriteNode alloc] init];
    ppixieEnemyBtn.size = CGSizeMake(PP_PET_ENEMY_SIZE_VALUE, PP_PET_ENEMY_SIZE_VALUE);
    [ppixieEnemyBtn setPosition:CGPointMake(originEnemyX,ppixiePetBtn.position.y)];
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
    enemyPlayerHP.position = CGPointMake(ppixieEnemyBtn.position.x,ppixieEnemyBtn.position.y-60.0f);
    [self addChild:enemyPlayerHP];
    
    
    // 敌方连击数
    SKLabelNode *ppixieBtnLabel = [[SKLabelNode alloc] init];
    ppixieBtnLabel.fontSize = 10;
    ppixieBtnLabel.name = PP_ENEMY_COMBOS_NAME;
    NSLog(@"pixieName=%@",enemyppixie.pixieName);
    [ppixieBtnLabel setText:@"连击:0"];
    ppixieBtnLabel.position = CGPointMake(ppixieEnemyBtn.position.x, ppixiePetBtnLabel.position.y);
    [self addChild:ppixieBtnLabel];
    
    
    //暂停按钮
//    PPSpriteButton *  stopBtn = [PPSpriteButton buttonWithTexture:[[PPAtlasManager ui_fighting] textureNamed:[NSString stringWithFormat:@"%@_footer_pause",sceneString]]
//                                                          andSize:CGSizeMake(32.5, 32.5)];
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
        SKSpriteNode * additonLabel = [self getNumber:fabsf(HPValue) AndColor:@"white"];
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
        SKSpriteNode * additonLabel = [self getNumber:fabsf(HPValue) AndColor:@"white"];
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

//-(void)shakeHeadPortrait:(NSString *)stringSide andCompletion:(PPBallBattleScene *)sceneBattle
//{
//    if ([stringSide isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
//        
//        SKAction * actionLeft = [SKAction moveByX:-10 y:0.0f duration:0.1];
//        SKAction * actionRight = [SKAction moveByX:20 y:0.0f duration:0.1];
//        SKAction * actionOrigin = [SKAction moveTo:ppixieEnemyBtn.position duration:0.1];
//        SKAction * actionTotal = [SKAction sequence:[NSArray arrayWithObjects:actionLeft,actionRight,actionOrigin,nil]];
//        
//        [ppixieEnemyBtn runAction:actionTotal completion:^{
//            
//            [sceneBattle physicsAttackAnimationEnd:stringSide];
//            
//        }];
//    } else {
//        SKAction * actionLeft = [SKAction moveByX:-10 y:0.0f duration:0.1];
//        SKAction * actionRight = [SKAction moveByX:20 y:0.0f duration:0.1];
//        SKAction * actionOrigin = [SKAction moveTo:ppixiePetBtn.position duration:0.1];
//        SKAction * actionTotal = [SKAction sequence:[NSArray arrayWithObjects:actionLeft,actionRight,actionOrigin,nil]];
//        
//        [ppixiePetBtn runAction:actionTotal completion:^{
//            [sceneBattle physicsAttackAnimationEnd:stringSide];
//            
//        }];
//    }
//}

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
    
    SKSpriteNode * tNode = [[SKSpriteNode alloc] init];
    if (number < 1 || color == nil) return tNode;
    
    float width = 13.0f;
    
    // 拼接数字图片
    int i = 0;
    while (number > 0) {
        i++;
        int tNum = number % 10;
        number /= 10;
        
        NSString * tNumName = [NSString stringWithFormat:@"%@_%d.png", color, tNum];
        SKSpriteNode * tNumNode = [SKSpriteNode spriteNodeWithTexture:[[PPAtlasManager ui_number] textureNamed:tNumName]];
        tNumNode.position = CGPointMake(-width * i, 0);
        tNumNode.xScale = 0.5;
        tNumNode.yScale = 0.5;
        [tNode addChild:tNumNode];
    }
    
    // 调整位置居中
    for (SKSpriteNode * numNode in [tNode children]) {
        numNode.position = CGPointMake(numNode.position.x + (i+1) * width / 2, numNode.position.y);
    }
    return tNode;
}

//-(void)addBuffShow:(PPBuff *)buffShow andSide:(NSString *)stringSide{
//    if ([stringSide isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
//        PPSpriteButton * buffBtnFirstEmpty = nil;
//        for (int i = 0; i < 3; i++) {
//            PPSpriteButton * petBuffBtn = (PPSpriteButton *)[self childNodeWithName:[NSString stringWithFormat:@"%d",PP_BUFF_SHOW_BTN_TAG + i]];
//            if ([petBuffBtn.PPBallSkillStatus isEqualToString:buffShow.buffId]) {
//                return;
//            } else if([petBuffBtn.PPBallSkillStatus isEqualToString:@"0"]) {
//                if (buffBtnFirstEmpty==nil) {
//                    buffBtnFirstEmpty = petBuffBtn;
//                }
//                break;
//            } else {
//                continue;
//            }
//        }
//        [buffBtnFirstEmpty runAction:[SKAction setTexture:[[PPAtlasManager skill_buff] textureNamed:kBuffNameList[[buffShow.buffId intValue]]]]];
//        buffBtnFirstEmpty.PPBallSkillStatus = buffShow.buffId;
//    } else {
//        PPSpriteButton *buffBtnFirstEmpty=nil;
//        for (int i = 0; i < 3; i++) {
//            PPSpriteButton *enemyBuffBtn=(PPSpriteButton *)[self childNodeWithName:[NSString stringWithFormat:@"%d",PP_BUFF_SHOW_BTN_TAG + i +10]];
//            if ([enemyBuffBtn.PPBallSkillStatus isEqualToString:buffShow.buffId]) {
//                return;
//            }else if([enemyBuffBtn.PPBallSkillStatus isEqualToString:@"0"])
//            {
//                
//                if (buffBtnFirstEmpty==nil) {
//                    buffBtnFirstEmpty = enemyBuffBtn;
//                }
//                break;
//            }else
//            {
//                continue;
//            }
//        }
//        
//        //        [buffBtnFirstEmpty addChild:[SKSpriteNode spriteNodeWithTexture:[[PPAtlasManager skill_buff] textureNamed:kBuffNameList[[buffShow.buffId intValue]]]]];
//        
//        [buffBtnFirstEmpty runAction:[SKAction setTexture:[[PPAtlasManager skill_buff] textureNamed:kBuffNameList[[buffShow.buffId intValue]]]]];
//        buffBtnFirstEmpty.PPBallSkillStatus = buffShow.buffId;
//        
//    }
//    
//    
//}

//-(void)removeBuffShow:(PPBuff *)buffShow andSide:(NSString *)stringSide{
//
//    
//    if ([stringSide isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
//        PPSpriteButton *buffBtnFirstEmpty=nil;
//        
//        for (int i=0; i<3; i++) {
//            PPSpriteButton *petBuffBtn=(PPSpriteButton *)[self childNodeWithName:[NSString stringWithFormat:@"%d",PP_BUFF_SHOW_BTN_TAG + i]];
//            
//            SKTexture *defaultTexture=[[PPAtlasManager ui_fighting] textureNamed:[NSString stringWithFormat:@"%@_header_buffbar%d",kElementTypeString[currentPPPixie.pixieElement],i+1]];
//            
//            if (defaultTexture) {
//                
//                [petBuffBtn runAction:[SKAction setTexture:defaultTexture]];
//                petBuffBtn.PPBallSkillStatus = @"0";
//            }
//        }
//        
//        [buffBtnFirstEmpty runAction:[SKAction setTexture:[[PPAtlasManager skill_buff] textureNamed:kBuffNameList[[buffShow.buffId intValue]]]]];
//        buffBtnFirstEmpty.PPBallSkillStatus = buffShow.buffId;
//        
//    }else
//    {
//        
//        for (int i=0; i<3; i++) {
//            
//            PPSpriteButton *enemyBuffBtn=(PPSpriteButton *)[self childNodeWithName:[NSString stringWithFormat:@"%d",PP_BUFF_SHOW_BTN_TAG + i +10]];
//            if ([enemyBuffBtn.PPBallSkillStatus isEqualToString:buffShow.buffId]) {
//                SKTexture *defaultTexture=[[PPAtlasManager ui_fighting] textureNamed:[NSString stringWithFormat:@"%@_header_buffbar%d",kElementTypeString[currentPPPixieEnemy.pixieElement],i+1]];
//                
//                if (defaultTexture) {
//                    
//                    [enemyBuffBtn runAction:[SKAction setTexture:defaultTexture]];
//                    enemyBuffBtn.PPBallSkillStatus = @"0";
//                }
//                
//                
//                return;
//            }
//        }
//    }    
//}

-(void)startAttackAnimation:(BOOL)isPetAttack
{

    if (isPetAttack) {
        SKSpriteNode * spriteNodeMoving = [SKSpriteNode spriteNodeWithImageNamed:@"moving_0000"];
        spriteNodeMoving.name = @"spriteNodeMoving";
        spriteNodeMoving.position = ppixiePetBtn.position;
        [self addChild:spriteNodeMoving];
        
        SKAction * actionMove = [SKAction moveToX:91.5f duration:1];
        spriteNodeMoving.size = CGSizeMake(spriteNodeMoving.size.width / 2, spriteNodeMoving.size.height / 2);
        SKAction * actionEffect = [SKAction repeatAction:[[PPAtlasManager battle_fight_effect] getAnimation:@"moving"] count:2];
        [spriteNodeMoving runAction:[SKAction group:[NSArray arrayWithObjects:actionMove,actionEffect, nil]] completion:^{
            spriteNodeMoving.hidden = YES;

            [spriteNodeMoving removeFromParent];
        }];
        ppixiePetBtn.position = CGPointMake(ppixieEnemyBtn.position.x-40.0f, originY);
        
        [ppixieEnemyBtn runAction:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_beated",kElementTypeString[currentPPPixieEnemy.pixieElement]]] completion:^{
            
        }];
        
        NSLog(@"beated=%@",kElementTypeString[currentPPPixie.pixieElement]);
        
    } else {
        SKSpriteNode * spriteNodeMoving = [SKSpriteNode spriteNodeWithImageNamed:@"moving_0000"];
        spriteNodeMoving.position = ppixieEnemyBtn.position;
        spriteNodeMoving.name = @"spriteNodeMoving";
        spriteNodeMoving.size = CGSizeMake(spriteNodeMoving.size.width/2.0f, spriteNodeMoving.size.height/2.0f);
        spriteNodeMoving.xScale = -1;

        [self addChild:spriteNodeMoving];
        
        SKAction * actionMove = [SKAction moveToX:-61.5f duration:1];
        SKAction * actionEffect = [SKAction repeatAction:[[PPAtlasManager battle_fight_effect] getAnimation:@"moving"] count:2];
        [spriteNodeMoving runAction:[SKAction group:[NSArray arrayWithObjects:actionMove,actionEffect, nil]] completion:^{
            spriteNodeMoving.hidden = YES;
            [spriteNodeMoving removeFromParent];
        }];
        
        ppixieEnemyBtn.position = CGPointMake(originX + 20, ppixieEnemyBtn.position.y);

        SKAction * actionBeated = [[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_beated",kElementTypeString[currentPPPixie.pixieElement]]];
        
        NSLog(@"beated=%@",kElementTypeString[currentPPPixie.pixieElement]);
        
        [ppixiePetBtn runAction:actionBeated completion:^{
            
        }];
        
    }
}

-(void)startAttackShowAnimation:(BOOL)isPetAttack
{
    
    if (isPetAttack) {

        [ppixiePetBtn runAction:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_hit",kElementTypeString[currentPPPixie.pixieElement]]] completion:^{
            
        }];
        
    }else
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
    
    if (isPetShow) {
        
        SKSpriteNode *buffRatShowNode =[[SKSpriteNode alloc] init];
        buffRatShowNode.size = CGSizeMake(50.0f, 50.0f);
        
        [buffRatShowNode setPosition:CGPointMake(-25.0f, 0.0f)];
        buffRatShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine];
        
        
        [ppixiePetBtn addChild:buffRatShowNode];
        
        SKAction *actionReprat = [SKAction repeatActionForever:[[PPAtlasManager battle_fight_skill] getAnimation:@"03_rattantwine"]];
        [buffRatShowNode runAction:actionReprat];
    }else
    {
        
        
        SKSpriteNode *buffShowNode= [PPAtlasManager createSpriteImageName:@"buff_rooted_dis_0000" withPos:CGPointMake(0.0f, 0.0f) withSize:CGSizeMake(115.0f, 107.0f) withName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine]];
        SKAction *actionRep = [[PPAtlasManager battle_table_buff] getAnimation:@"buff_rooted_apr"];
        [ppixieEnemyBtn addChild:buffShowNode];

        [buffShowNode runAction:actionRep completion:^{
            
            
        }];


    }
    
}
@end
