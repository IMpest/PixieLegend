
#include"stdio.h"
#import "PPBallBattleScene.h"
#import "PPBallBattleSkillInfo.h"

#define PP_ENEMY_DEAD_CONTENT_NAME       @"enemydeadcontent"

#define SPACE_BOTTOM 0
#define BALL_RANDOM_X (kBallSize / 2 + arc4random() % (int)(320 - kBallSizePixie))
#define BALL_RANDOM_Y (kBallSize / 2 + arc4random() % (int)(320 - kBallSizePixie) + SPACE_BOTTOM)

// 物理实体类型
typedef NS_OPTIONS (int, EntityCategory)
{
    EntityCategoryBall    =  0x1 << 0,
    EntityCategoryWall    =  0x1 << 1,
};

typedef NS_OPTIONS (int, HitTypeValue)
{
    kPetHitWallTypeValue    =  0x1 << 0,
    kEnemyHitWallTypeValue    =  0x1 << 1,
    kPetAndEnemyHitTypeValue    =  0x1 << 2,
};

// 计算两点间距离
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt( deltaX * deltaX + deltaY * deltaY );
};

// 计算向量长度
CGFloat vectorLength (CGVector vector) {
    return sqrt( vector.dx * vector.dx + vector.dy * vector.dy );
};

// 向量角度计算
CGFloat vector2angel(CGVector vector){
    CGFloat rotation = atan(vector.dy / vector.dx);
    return vector.dx > 0 ? rotation : rotation + 3.1415926;
}

@interface PPBallBattleScene () < SKPhysicsContactDelegate, UIAlertViewDelegate >
{
    long frameFlag;
    BOOL isNotSkillRun;
    NSString * sceneTypeString;
    BOOL isNotSkillShowTime;
    BOOL isTouchPetBall;
    BOOL isShowingSkillBar;
    SKSpriteNode *spriteArrow;
    SKSpriteNode *petSkillBar;
    PPBallBattleSkillInfo *battleSkillInfo;
    PPElementType currentElementType;
}

@property (nonatomic, retain) PPPixie * pixiePlayer;
@property (nonatomic, retain) PPPixie * pixieEnemy;

@property (nonatomic) BOOL isBallDragging;
@property (nonatomic) BOOL isBallRolling;
@property (nonatomic) PPBall * ballPlayer;
@property (nonatomic) PPBall * ballShadow;
@property (nonatomic) PPBall * ballEnemy;

@property (nonatomic, retain) NSMutableArray * ballsElement;
@property (nonatomic, retain) NSMutableArray * ballsCombos;
@property (nonatomic, retain) NSMutableArray * battleBuffArray;
@property (nonatomic, retain) PPBattleInfoLayer * playerSkillSide;
@property (nonatomic, retain) PPBattleInfoLayer * playerAndEnemySide;

@property (nonatomic) SKSpriteNode * btSkill;
@property (nonatomic) BOOL isTrapEnable;
@end

@implementation PPBallBattleScene
@synthesize ballsCombos;
@synthesize enmeysArray;
@synthesize battleBuffArray;

#pragma mark Initilization

-(id)initWithSize:(CGSize)size
      PixiePlayer:(PPPixie *)pixieA
       PixieEnemy:(PPPixie *)pixieB
     andSceneType:(PPElementType)sceneType andIndex:(int)enemyIndex{
    
    if (self = [super initWithSize:size]) {
        
        // 处理参数
        self.pixiePlayer = pixieA;
        self.ballPlayer = pixieA.pixieBall;
        self.pixieEnemy = pixieB;
        sceneTypeString = kElementTypeString[sceneType];
        currentElementType = sceneType;
        _isTrapEnable = NO;
        isTouchPetBall = NO;
        isShowingSkillBar = NO;
        currentEnemyIndex = enemyIndex;
        
        // 帧数间隔计数
        frameFlag = 0;
        
        battleSkillInfo = [[PPBallBattleSkillInfo alloc] init];
        battleSkillInfo.enemyPoisoningHP = 0;
        battleSkillInfo.petHitRecoverHP = 0;
        battleSkillInfo.rattanTwineState = 0;
        battleSkillInfo.nightJudgeValue = 0.0f;
        
        self.battleBuffArray = [[NSMutableArray alloc] init];
        
        // 初始化宠物基础数据
        petCombos = 0;
        petAssimSameEleNum = 0;
        petAssimDiffEleNum = 0;
        enemyCombos = 0;
        enemyAssimDiffEleNum = 0;
        enemyAssimSameEleNum = 0;
        currentPhysicsAttack = 0;
        
        // 设置敌我元素属性
        PPElementType petElement = pixieA.pixieBall.ballElementType;
        PPElementType enemyElement = pixieB.pixieBall.ballElementType;
        interCoefficient = kElementInhibition[petElement][enemyElement];
        
        // 设置场景物理属性
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        // 添加弹珠台图片
        SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"table_back"];
        bg.size = CGSizeMake(320, 320);
        bg.position = CGPointMake(CGRectGetMidX(self.frame), 160 + SPACE_BOTTOM + PP_FIT_TOP_SIZE);
        [self addChild:bg];
        
        SKSpriteNode * bgWall = [SKSpriteNode spriteNodeWithImageNamed:@"table_wall"];
        bgWall.size = CGSizeMake(320, 320);
        bgWall.position = CGPointMake(CGRectGetMidX(self.frame), 160 + SPACE_BOTTOM + PP_FIT_TOP_SIZE);
        [self addChild:bgWall];
        
        // 添加状态条
        
        //        self.playerSkillSide = [[PPBattleInfoLayer alloc] init];
        //        self.playerSkillSide.position = CGPointMake(self.size.width/2, 40 + PP_FIT_TOP_SIZE);
        //        self.playerSkillSide.size =  CGSizeMake(self.size.width, 80);
        //        self.playerSkillSide.name = PP_PET_PLAYER_SIDE_NODE_NAME;
        //        self.playerSkillSide.target = self;
        //        self.playerSkillSide.skillSelector = @selector(skillPlayerShowBegin:);
        //        self.playerSkillSide.pauseSelector = @selector(pauseBtnClick:);
        //        self.playerSkillSide.hpBeenZeroSel = @selector(hpBeenZeroMethod:);
        //        self.playerSkillSide.skillInvalidSel = @selector(skillInvalidBtnClick:);
        //        [self.playerSkillSide setColor:[UIColor grayColor]];
        //        [self.playerSkillSide setSideSkillsBtn:pixieA andSceneString:sceneTypeString];
        //        [self addChild:self.playerSkillSide];
        
        // 添加围墙
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        CGFloat tWidth = 320.0f;
        CGFloat tHeight = 320.0f;
        [self addWalls:CGSizeMake(tWidth, kWallThick) atPosition:CGPointMake(tWidth / 2, tHeight + SPACE_BOTTOM + PP_FIT_TOP_SIZE)];
        [self addWalls:CGSizeMake(tWidth, kWallThick) atPosition:CGPointMake(tWidth / 2, 0 + SPACE_BOTTOM + PP_FIT_TOP_SIZE)];
        [self addWalls:CGSizeMake(kWallThick,tWidth) atPosition:CGPointMake(0, tHeight / 2 + SPACE_BOTTOM + PP_FIT_TOP_SIZE)];
        [self addWalls:CGSizeMake(kWallThick,tWidth) atPosition:CGPointMake(self.size.width, tHeight / 2 + SPACE_BOTTOM + PP_FIT_TOP_SIZE)];
        
        [self initComboBalls];
        [self initPlayerBalls];
        [self initEnemyBall];
        
    }
    return self;
}

// 添加己方玩家球
-(void)initPlayerBalls{
    
    float xPlayer = BALL_RANDOM_X;
    float yPlayer = BALL_RANDOM_Y + PP_FIT_TOP_SIZE;
    
    // 修正位置防止越界
    if (xPlayer < 20) xPlayer = 20;
    if (xPlayer > self.size.width - 20) xPlayer = self.size.width - 20;
    if (yPlayer < 64) yPlayer = 64;
    if (yPlayer > 344) yPlayer = 344;
    
    self.ballPlayer.name = @"ball_player";
    self.ballPlayer.position = CGPointMake(xPlayer, yPlayer);
    //    self.ballPlayer.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20.0f];
    self.ballPlayer.physicsBody.allowsRotation = NO;
    self.ballPlayer.physicsBody.categoryBitMask = EntityCategoryBall;
    self.ballPlayer.physicsBody.contactTestBitMask = EntityCategoryBall;
    self.ballPlayer.physicsBody.density = 1.0f;
    self.ballPlayer->battleCurrentScene = self;
    [self addChild:self.ballPlayer];
}

-(void)initEnemyBall
{
    if(self.ballEnemy != nil){
        [self.ballEnemy removeFromParent];
        self.ballEnemy = nil;
    }
    
    // 添加 Ball of Enemey
    self.ballEnemy = self.pixieEnemy.pixieBall;
    self.ballEnemy.position = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y + PP_FIT_TOP_SIZE);
    self.ballEnemy->battleCurrentScene = self;
    if (fabsf(self.ballEnemy.position.x)>=290) {
        self.ballEnemy.position = CGPointMake(290.0f, self.ballPlayer.position.y);
    }
    if (fabsf(self.ballEnemy.position.y)>380) {
        self.ballEnemy.position = CGPointMake(self.ballPlayer.position.x, 380);
        
    }
    self.ballEnemy.physicsBody.categoryBitMask = EntityCategoryBall;
    self.ballEnemy.physicsBody.contactTestBitMask = EntityCategoryBall;
    [self addChild:self.ballEnemy];
}

// 添加连击球
-(void)initComboBalls{
    
    self.ballsElement = [[NSMutableArray alloc] init];
    self.ballsCombos = [[NSMutableArray alloc] init];
    
    // 8选5方式决定位置
    const int tmax = 8;
    BOOL cb[tmax] = {NO, NO, NO, NO, NO, NO, NO, NO};
    int cx[tmax] = {40, 40, 40, 160, 160, 280, 280, 280};
    int cy[tmax] = {40, 160, 280, 40, 280, 40, 160, 280};
    
    for (int i = 0; i < 5; i++) {
        
        PPBall * comboBall = [PPBall ballWithCombo];
        
        int t = arc4random() % tmax;
        while (cb[t] == YES) t = arc4random() % tmax;
        cb[t] = YES;
        NSLog(@"%d %d %d", t, cx[t], cy[t]);
        comboBall.position = CGPointMake(cx[t], cy[t] + PP_FIT_TOP_SIZE);
        
        // 调整随机尺寸结果防止重叠
        //        BOOL isRequred = NO;
        //        while (!isRequred) {
        //            isRequred = YES;
        //            CGPoint pointCombo = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y + PP_FIT_TOP_SIZE);
        //            for (PPBall * ballAdded in self.ballsCombos) {
        //                CGFloat distanceValue = distanceBetweenPoints(ballAdded.position,pointCombo);
        //                if (distanceValue <= 30) {
        //                    isRequred = NO;
        //                    break;
        //                }
        //            }
        //            comboBall.position = pointCombo;
        //            NSLog(@"%f %f", pointCombo.x, pointCombo.y);
        //        }
        
        // 添加连击球
        comboBall.name = PP_BALL_TYPE_COMBO_NAME;
        comboBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25];
        comboBall.physicsBody.categoryBitMask = EntityCategoryBall;
        comboBall.physicsBody.contactTestBitMask = EntityCategoryBall|EntityCategoryWall;
        comboBall.physicsBody.collisionBitMask = EntityCategoryBall|EntityCategoryWall;
        comboBall.physicsBody.dynamic = YES;
        comboBall.physicsBody.mass = 10000;
        comboBall.physicsBody.PPBallPhysicsBodyStatus = [NSNumber numberWithInt:i];
        comboBall.PPBallSkillStatus = 0;
        [self addChild:comboBall];
        [self.ballsCombos addObject:comboBall];
        
    }
}

-(void)setComboBallSkillStatusOrigin
{
    [self enumerateChildNodesWithName:PP_BALL_TYPE_COMBO_NAME usingBlock:^(SKNode *node,BOOL * stop){
        
        node.PPBallSkillStatus = 0;
        //        [node removeAllChildren];
        
        SKNode * nodeShowBuff = [node childNodeWithName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine]];
        if (nodeShowBuff) [nodeShowBuff removeFromParent];
    }];
}

#pragma mark BallAnimation

-(void)addBallMoveAnimation:(CGPoint)positionAni
{
    SKSpriteNode * actionNode = [SKSpriteNode spriteNodeWithImageNamed:@"ball_pixie_start_0000"];
    actionNode.position = self.ballPlayer.position;
    [self addChild:actionNode];
    SKAction * action1 = [SKAction repeatAction:[[PPAtlasManager battle_table_ball] getAnimation:@"ball_pixie_start"] count:5];
    SKAction * action2 = [SKAction group:[NSArray arrayWithObjects:action1, [SKAction fadeAlphaTo:0 duration:2], nil]];
    [actionNode runAction:action2 completion:^{
        [actionNode removeFromParent];
    }];
}

//更新技能CD回合
-(void)changeSkillBtnCdRounds
{
    for (int i = 0; i < 4; i++) {
        if(petSkillBar)
        {
            PPSpriteButton * spriteBtn = (PPSpriteButton *)
            [petSkillBar childNodeWithName:[NSString stringWithFormat:@"%d",PP_SKILLS_CHOOSE_BTN_TAG+i]];
            NSLog(@"PPBallPhysicsBodyStatus=%@",spriteBtn.PPBallPhysicsBodyStatus);
            
            if ([spriteBtn.PPBallPhysicsBodyStatus  isEqual: @1]) {
                SKLabelNode *labelNode = (SKLabelNode *)[spriteBtn childNodeWithName:PP_SKILL_CD_LABEL_NODE_NAME];
                spriteBtn.PPBallSkillStatus = [NSNumber numberWithInt:[spriteBtn.PPBallSkillStatus intValue] -1];
                [labelNode setText:[NSString stringWithFormat:@"%@",spriteBtn.PPBallSkillStatus]];
                if (petSkillBar.hidden==NO) {
                    
                    if ([spriteBtn.PPBallSkillStatus intValue]<=0) {
                        
                        spriteBtn.color = [UIColor blackColor];
                        spriteBtn.colorBlendFactor = 0.0;
                        spriteBtn.userInteractionEnabled = YES;
                        
                    }
                }
                
            }
            
            //恶魔重生
            battleSkillInfo.petHitRecoverHP = 0;
            SKNode * node = [self.playerAndEnemySide->ppixiePetBtn childNodeWithName:[NSString stringWithFormat:
                                                                                      @"%@%d",
                                                                                      PP_BUFF_ANIMATION_NODE_NAME,
                                                                                      PPBuffTypeDevilRebirth]];
            //            [node removeActionForKey:PP_BUFF_ANIMATION_ACTION_KEY];
            [node removeFromParent];
        }
    }
}

-(void)changeBallStatus:(NSString *)stringSide
{
    if ([stringSide isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
        self.ballEnemy.physicsBody.dynamic = NO;
        self.ballPlayer.physicsBody.dynamic = YES;
    } else {
        self.ballPlayer.physicsBody.dynamic = NO;
        self.ballEnemy.physicsBody.dynamic = YES;
    }
}

#pragma mark Deal ball contact

//处理人物球与连击球碰撞
-(NSNumber *)dealPixieBallContactComboBall:(SKPhysicsContact *)contact andPetBall:(PPBall *)pixieball
{
    NSNumber * elementBodyStatus = nil;
    PPBall * elementBallTmp = nil;
    if (contact.bodyA == pixieball.physicsBody) {
        elementBodyStatus = contact.bodyB.PPBallPhysicsBodyStatus;
        elementBallTmp = (PPBall *)contact.bodyB.node ;
    } else {
        elementBodyStatus = contact.bodyA.PPBallPhysicsBodyStatus;
        elementBallTmp = (PPBall *)contact.bodyA.node ;
    }
    NSLog(@"elementBodyStatus=%@",elementBodyStatus);
    
    if (self.ballPlayer == pixieball) {
        [self.playerAndEnemySide changeEnemyHPValue:-50];
        [self.playerAndEnemySide startAttackShowAnimation:YES];
        [self.playerAndEnemySide changePetMPValue:200];
    } else {
        [self.playerAndEnemySide changePetHPValue:-100];
        [self.playerAndEnemySide startAttackShowAnimation:NO];
        [self.playerAndEnemySide changeEnemyMPValue:200];
    }
    return elementBodyStatus;
    
}
//处理人物球与元素球碰撞
-(NSNumber *)dealPixieBallAndElementBall:(SKPhysicsContact *)contact andPetBall:(PPBall *)pixieball
{
    NSNumber * elementBodyStatus = nil;
    PPBall * elementBallTmp = nil;
    if (contact.bodyA == pixieball.physicsBody) {
        elementBodyStatus = contact.bodyB.PPBallPhysicsBodyStatus;
        elementBallTmp = (PPBall *)contact.bodyB.node ;
        
    } else {
        
        elementBodyStatus = contact.bodyA.PPBallPhysicsBodyStatus;
        elementBallTmp = (PPBall *)contact.bodyA.node ;
        
    }
    NSLog(@"elementBodyStatus=%@",elementBodyStatus);
    
    if ([elementBodyStatus intValue] >= PP_ELEMENT_NAME_TAG) {
        
        if (self.ballPlayer == pixieball) {
            
            if (self.ballPlayer.ballElementType == elementBallTmp.ballElementType) {
                
                if (self.playerAndEnemySide.currentPPPixie.currentHP < self.playerAndEnemySide.currentPPPixie.pixieHPmax) {
                    [self.playerAndEnemySide changePetHPValue:200];
                    [self addValueChangeLabel:200 position:pixieball.position andColor:@"green"];
                    [self.ballPlayer startPixieHealAnimation];
                    
                    petAssimSameEleNum ++;
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:YES andScene:self];
                    
                } else {
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:NO andScene:self];
                }
            } else {
                if (self.playerAndEnemySide.currentPPPixie.currentHP >= 0.0f) {
                    [self.playerAndEnemySide changePetHPValue:-200];
                    
                    petAssimDiffEleNum ++;
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:YES andScene:self];
                    [self addValueChangeLabel:200 position:self.ballPlayer.position andColor:@"red"];
                    
                    
                } else {
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:NO andScene:self];
                }
            }
        } else {
            if (self.ballEnemy.ballElementType == elementBallTmp.ballElementType) {
                if (self.playerAndEnemySide.currentPPPixieEnemy.currentHP <self.playerAndEnemySide.currentPPPixieEnemy.pixieHPmax) {
                    [self.playerAndEnemySide changeEnemyHPValue:200];
                    [self addValueChangeLabel:200 position:pixieball.position andColor:@"green"];
                    [self.ballEnemy startPixieHealAnimation];
                    
                    enemyAssimSameEleNum ++;
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:YES andScene:self];
                    
                }else
                {
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:NO andScene:self];
                }
            } else {
                if (self.playerAndEnemySide.currentPPPixieEnemy.currentHP >= 0.0f) {
                    
                    [self.playerAndEnemySide changeEnemyHPValue:-100];
                    
                    enemyAssimDiffEleNum ++;
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:YES andScene:self];
                    [self addValueChangeLabel:100 position:self.ballEnemy.position andColor:@"red"];
                } else {
                    [elementBallTmp startElementBallHitAnimation:self.ballsElement isNeedRemove:YES andScene:self];
                }
            }
        }
    }
    return elementBodyStatus;
}

//处理弹珠台技能
-(NSNumber *)dealPallMoveSkillStatus:(SKPhysicsContact *)contact andPetBall:(PPBall *)pixieball
{
    NSNumber *skillStatus = nil;
    
    if (pixieball.physicsBody == contact.bodyA) {
        skillStatus = contact.bodyB.PPBallSkillStatus;
        
    }else
    {
        skillStatus = contact.bodyA.PPBallSkillStatus;
        
    }
    return skillStatus;
}

#pragma mark BackAlert

//返回按钮
-(void)backButtonClick:(NSString *)backName
{
    
    [self.view presentScene:previousScene transition:[SKTransition doorsOpenVerticalWithDuration:1]];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [(PPFightingMainView *)self.view changeToPassScene];
        [[NSNotificationCenter defaultCenter] postNotificationName:PP_BACK_TO_MAIN_VIEW object:PP_BACK_TO_MAIN_VIEW_FIGHTING];
    }
}

#pragma mark PauseButton

//暂停游戏按钮点击事件
-(void)pauseBtnClick:(NSString *)stringName
{
    
    
    self.paused = YES;
    
    PPCustomAlertNode *alertNode = [[PPCustomAlertNode alloc] initWithFrame:CGRectMake(self.size.width / 2,
                                                                                       self.size.height / 2,
                                                                                       self.size.width, self.size.height)];
    alertNode->target = self;
    alertNode->btnClickSel = @selector(pauseMenuBtnClick:);
    [alertNode setColor:[UIColor yellowColor]];
    alertNode.zPosition = 10;
    [alertNode showPauseMenuAlertWithTitle:@"游戏暂停" andMessage:nil];
    [self addChild:alertNode];
}

//
-(void)pauseMenuBtnClick:(NSString *)btnStr
{
    NSLog(@"btnStr= %@",btnStr);
    
    if ([btnStr isEqualToString:@"button1"]) {
        self.paused = NO;
    }
    
    if ([btnStr isEqualToString:@"button2"]) {
        [self backButtonClick:nil];
    }
}

#pragma mark Custom Method

// 是否所有的球都停止了滚动
-(BOOL)isAllStopRolling{
    
    // 首先检查是否该停止特效
    [self.ballPlayer startPixieAccelerateAnimation:self.ballPlayer.physicsBody.velocity andType:@"stop"];
    [self.ballEnemy startPixieAccelerateAnimation:self.ballPlayer.physicsBody.velocity andType:@"stop"];
    
    if (vectorLength(self.ballPlayer.physicsBody.velocity) > kStopThreshold ) {
        return NO;
    } else {
        self.ballPlayer.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
        self.ballPlayer.physicsBody.resting = YES;
    }
    
    if (vectorLength(self.ballEnemy.physicsBody.velocity) > kStopThreshold) {
        return NO;
    } else {
        self.ballEnemy.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
        self.ballEnemy.physicsBody.resting = YES;
    }
    
    for (PPBall * tBall in self.ballsElement) {
        if (vectorLength(tBall.physicsBody.velocity) > kStopThreshold) {
            return NO;
        } else {
            tBall.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
            tBall.physicsBody.resting = YES;
        }
    }
    
    for (PPBall * tBall in self.ballsCombos) {
        if (vectorLength(tBall.physicsBody.velocity) > kStopThreshold) {
            return NO;
        } else {
            tBall.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
            tBall.physicsBody.resting = YES;
        }
    }
    return YES;
}

//检查球体是否都停止了
-(void)checkingBallsMove
{
    // 如果球都停止了
    if (_isBallRolling && [self isAllStopRolling]) {
        
        NSLog(@"Doing Attack and Defend");
        _isBallRolling = NO;
        
        // 刷新技能
        _isTrapEnable = NO;
        for (PPBall * tBall in self.ballsElement) [tBall setToDefaultTexture];
        
        [self.playerAndEnemySide resetPetAndEnemyPosition];
        
        if(currentPhysicsAttack == 1)
        {
            [self roundRotateMoved:PP_PET_PLAYER_SIDE_NODE_NAME];
            //            [self  showPhysicsAttackAnimation:PP_PET_PLAYER_SIDE_NODE_NAME];
        } else
        {
            [self roundRotateMoved:PP_ENEMY_SIDE_NODE_NAME];
            //            [self  showPhysicsAttackAnimation:PP_ENEMY_SIDE_NODE_NAME];
        }
    } else
        //速度小于临界点 停止
    {
        if (vectorLength(self.ballPlayer.physicsBody.velocity) < kStopThreshold) {
            self.ballPlayer.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
        }
        
        if (vectorLength(self.ballEnemy.physicsBody.velocity) < kStopThreshold) {
            self.ballEnemy.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
        }
        
        for (SKNode *obj in self.ballsCombos) {
            if (vectorLength(obj.physicsBody.velocity) < kStopThreshold)
            {
                obj.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
            }
        }
    }
}

// 设置战斗对象
-(void)setEnemyAtIndex:(int)index
{
    [self addEnemySide:PP_FIT_TOP_SIZE];
    currentEnemyIndex =index;

}

// 战斗结束过程
-(void)hpBeenZeroMethod:(NSString *)battlesideName
{
    if ([battlesideName isEqualToString:PP_ENEMY_SIDE_NODE_NAME])
    {
        
        self.paused = YES;
        
        SKSpriteNode *enemyDeadContent=[[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(320, 240)];
        [enemyDeadContent setPosition:CGPointMake(160.0f, 300)];
        enemyDeadContent.zPosition =  PPZ_FIGHT_EFFECT_ATT;
        enemyDeadContent.name = PP_ENEMY_DEAD_CONTENT_NAME;
        [self addChild:enemyDeadContent];
        
        NSDictionary *alertInfo = @{@"title":[NSString stringWithFormat:@"打倒怪物%d号",currentEnemyIndex], @"context":@"下一个怪物"};
        
        SKLabelNode * titleNameLabel=[[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        titleNameLabel.fontSize = 13;
        titleNameLabel.fontColor = [UIColor blueColor];
        titleNameLabel.text = [alertInfo objectForKey:@"title"];
        titleNameLabel.position = CGPointMake(0.0f,50);
        [enemyDeadContent addChild:titleNameLabel];
        
        
        SKLabelNode * textContentLabel=[[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        textContentLabel.fontColor = [UIColor blueColor];
        textContentLabel.text = [alertInfo objectForKey:@"context"];
        textContentLabel.fontSize = 13;
        textContentLabel.position = CGPointMake(0.0f,-20);
        [enemyDeadContent addChild:textContentLabel];
        
        
        
        PPSpriteButton *goButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(45, 30)];
        [goButton setLabelWithText:@"下一个" andFont:[UIFont systemFontOfSize:15] withColor:nil];
        goButton.zPosition = PP_BACK_BUTTON_ZPOSITION;
        goButton.position = CGPointMake(0.0f,-60);
        [goButton addTarget:self selector:@selector(goNextEnemy)
                 withObject:nil forControlEvent:PPButtonControlEventTouchUpInside];
        [enemyDeadContent addChild:goButton];
        
       
//        [self performSelectorOnMainThread:@selector(goNextEnemy) withObject:nil afterDelay:2];
//            
        
    } else {
        
        NSDictionary * dict = @{@"title":@"您的宠物已被打倒", @"context":@"请选择其他宠物出战"};
        PPCustomAlertNode * alertCustom=[[PPCustomAlertNode alloc] initWithFrame:CustomAlertFrame];
        [alertCustom showCustomAlertWithInfo:dict];
        [self addChild:alertCustom];
        
    }
}
-(void)goNextScene
{
    [self.view presentScene:previousScene];

}
//进入下一怪物遭遇动画
-(void)goNextEnemy
{
#warning TODO 这里现在改成上边推进进入下一个战斗画面或者结算画面
    
    //    [self.hurdleReady setCurrentHurdle:currentEnemyIndex];
    //    [self.view presentScene:self.hurdleReady transition:[SKTransition doorwayWithDuration:1]];
    
    
    if ([self.enmeysArray count]<=currentEnemyIndex+1) {
        
        
        
        SKSpriteNode *enemyDeadContent=[[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(320, 240)];
        [enemyDeadContent setPosition:CGPointMake(160.0f, 300)];
        enemyDeadContent.zPosition =  PPZ_FIGHT_EFFECT_ATT;
        enemyDeadContent.name = PP_ENEMY_DEAD_CONTENT_NAME;
        [self addChild:enemyDeadContent];
        
        NSDictionary *alertInfo = @{@"title":@"所有怪物都已打完", @"context":@""};
        
        SKLabelNode * titleNameLabel=[[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        titleNameLabel.fontSize = 13;
        titleNameLabel.fontColor = [UIColor blueColor];
        titleNameLabel.text = [alertInfo objectForKey:@"title"];
        titleNameLabel.position = CGPointMake(0.0f,50);
        [enemyDeadContent addChild:titleNameLabel];
        
        
//        SKLabelNode * textContentLabel=[[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
//        textContentLabel.fontColor = [UIColor blueColor];
//        textContentLabel.text = [alertInfo objectForKey:@"context"];
//        textContentLabel.fontSize = 13;
//        textContentLabel.position = CGPointMake(0.0f,-50);
//        [enemyDeadContent addChild:textContentLabel];
        
        
        PPSpriteButton *goButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(45, 30)];
        [goButton setLabelWithText:@"确定" andFont:[UIFont systemFontOfSize:15] withColor:nil];
        goButton.zPosition = PP_BACK_BUTTON_ZPOSITION;
        goButton.position = CGPointMake(0.0f,-60);
        [goButton addTarget:self selector:@selector(goNextScene)
                   withObject:nil forControlEvent:PPButtonControlEventTouchUpInside];
        [enemyDeadContent addChild:goButton];
        
        
        
        return ;
    }
    
    NSDictionary * pixiesInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PixiesInfo"
                                                                                                           ofType:@"plist"]];
    
    NSDictionary * petsChoosedInfo = [[pixiesInfo objectForKey:@"userpetinfo"] objectAtIndex:0];
    PPPixie * playerPixie = [PPPixie pixieWithData:petsChoosedInfo];
    
//    if ([self.enmeysArray count]<=currentEnemyIndex) {
//        
//        
//        
//        [self.view presentScene:previousScene];
//        
//        
//    }
    
    NSDictionary * enemyDicInfo = [self.enmeysArray objectAtIndex:currentEnemyIndex + 1];
    PPPixie * enemyPixie = [PPPixie pixieWithData:enemyDicInfo];
    
    // 创建战斗场景并显示
    PPBallBattleScene * ballScene = [[PPBallBattleScene alloc] initWithSize:CurrentDeviceRealSize
                                                                PixiePlayer:playerPixie
                                                                 PixieEnemy:enemyPixie
                                                               andSceneType:currentElementType
                                                                   andIndex:currentEnemyIndex+1];
    ballScene.scaleMode = SKSceneScaleModeAspectFill;
    ballScene.enmeysArray = self.enmeysArray;
    ballScene->previousScene = previousScene;
    [ballScene setEnemyAtIndex:currentEnemyIndex + 1];
    [self.view presentScene:ballScene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    
//    SKNode * node = [self childNodeWithName:PP_ENEMY_DEAD_CONTENT_NAME];
//    if (node) [node removeFromParent];
//    
//    NSLog(@"count =%lu,current=%d", (unsigned long)[self.enmeysArray count], currentEnemyIndex);
//    
//    NSDictionary * enemyDicInfo = [self.enmeysArray objectAtIndex:currentEnemyIndex];
//    PPPixie * enemyPixie = [PPPixie pixieWithData:enemyDicInfo];
//    self.pixieEnemy = enemyPixie;
//    
//    [self setEnemyAtIndex:currentEnemyIndex + 1];
}

// 添加敌方单位各个元素
-(void)addEnemySide:(CGFloat)direct
{
    if(self.playerAndEnemySide != nil){
        [self.playerAndEnemySide removeFromParent];
        self.playerAndEnemySide = nil;
    }
    
    if(self.ballEnemy != nil){
        [self.ballEnemy removeFromParent];
        self.ballEnemy = nil;
    }
    
    // 添加 Ball of Enemey
    self.ballEnemy = self.pixieEnemy.pixieBall;
    self.ballEnemy.position = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y + PP_FIT_TOP_SIZE);
    self.ballEnemy->battleCurrentScene = self;
    if (fabsf(self.ballEnemy.position.x) >= 290) {
        self.ballEnemy.position = CGPointMake(290.0f, self.ballPlayer.position.y);
    }
    if (fabsf(self.ballEnemy.position.y) > 380) {
        self.ballEnemy.position = CGPointMake(self.ballPlayer.position.x, 380);
    }
    self.ballEnemy.physicsBody.categoryBitMask = EntityCategoryBall;
    self.ballEnemy.physicsBody.contactTestBitMask = EntityCategoryBall;
    [self addChild:self.ballEnemy];
    
    self.playerAndEnemySide = [[PPBattleInfoLayer alloc] init];
    self.playerAndEnemySide.color = [UIColor purpleColor];
    self.playerAndEnemySide.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height-80-direct);
    self.playerAndEnemySide.name = PP_ENEMY_SIDE_NODE_NAME;
    self.playerAndEnemySide.size = CGSizeMake(self.size.width, 160.0f);
    self.playerAndEnemySide.target = self;
    self.playerAndEnemySide.hpBeenZeroSel = @selector(hpBeenZeroMethod:);
    self.playerAndEnemySide.hpChangeEnd = @selector(hpChangeEndAnimate:);
    self.playerAndEnemySide.skillSelector = @selector(skillPlayerShowBegin:);
    self.playerAndEnemySide.pauseSelector = @selector(pauseBtnClick:);
    //    self.playerAndEnemySide.showInfoSelector = @selector(showCurrentEnemyInfo:);
    [self.playerAndEnemySide setSideElements:self.pixiePlayer andEnemy:self.pixieEnemy
                              andSceneString:sceneTypeString andIndex:currentEnemyIndex];
    [self addChild:self.playerAndEnemySide];
}

// 添加四周的墙
-(void)addWalls:(CGSize)nodeSize atPosition:(CGPoint)nodePosition
{
    SKSpriteNode * wall = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:nodeSize];
    wall.position = nodePosition;
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
    wall.physicsBody.affectedByGravity = NO;
    wall.physicsBody.dynamic = NO;
    wall.physicsBody.friction = 0.1;
    wall.physicsBody.categoryBitMask = EntityCategoryWall;
    wall.physicsBody.contactTestBitMask = EntityCategoryBall;
    wall.physicsBody.collisionBitMask = 0;
    
    [self addChild:wall];
}

-(void)addHitAnimationNodes:(CGPoint)pointNode andType:(HitTypeValue)hitType
{
    
    switch (hitType) {
        case kPetHitWallTypeValue:
        {
            
            SKSpriteNode *hitAniNode=[[SKSpriteNode alloc] init];
            hitAniNode.size = CGSizeMake(50.0f, 50.0f);
            [hitAniNode setPosition:pointNode];
            [self addChild:hitAniNode];
            
            [hitAniNode runAction:[[PPAtlasManager battle_table_ball] getAnimation:@"ball_pixie_wall"]
                       completion:^{[hitAniNode removeFromParent];}];
        }
            break;
        case kEnemyHitWallTypeValue:
        {
            
            SKSpriteNode *hitAniNode=[[SKSpriteNode alloc] init];
            hitAniNode.size = CGSizeMake(50.0f, 50.0f);
            [hitAniNode setPosition:pointNode];
            [self addChild:hitAniNode];
            
            [hitAniNode runAction:[[PPAtlasManager battle_table_ball] getAnimation:@"ball_pixie_wall"]
                       completion:^{[hitAniNode removeFromParent];}];
            
        }
            break;
        case kPetAndEnemyHitTypeValue:
        {
            
            SKSpriteNode *hitAniNode=[[SKSpriteNode alloc] init];
            hitAniNode.size = CGSizeMake(100.0f, 100.0f);
            [hitAniNode setPosition:pointNode];
            [self addChild:hitAniNode];
            
            [hitAniNode runAction:[[PPAtlasManager battle_table_ball] getAnimation:@"ball_pixie_hit"]
                       completion:^{[hitAniNode removeFromParent];}];
            
            SKSpriteNode *hitFiledAniNode=[[SKSpriteNode alloc] init];
            hitFiledAniNode.size = CGSizeMake(50.0f, 50.0f);
            [hitFiledAniNode setPosition:pointNode];
            [self addChild:hitFiledAniNode];
            
            [hitFiledAniNode runAction:[[PPAtlasManager battle_fight_effect] getAnimation:@"shield_break"]
                            completion:^{[hitFiledAniNode removeFromParent];}];
            
        }
            break;
        default:
            break;
    }
    
}
-(void)addPetSkillBar
{
    
    //    [self removeSkillBar];
    
    if (petSkillBar) {
        petSkillBar.zPosition = 1;
        petSkillBar.hidden = NO;
        for (int i=0; i<4; i++) {
            NSDictionary * dictSkill = nil;
            if ([self.pixiePlayer.pixieSkills count] > i) {
                dictSkill = [self.pixiePlayer.pixieSkills objectAtIndex:i];
            }
           
            if(petSkillBar)
            {
                PPSpriteButton *spriteBtn = (PPSpriteButton *)[petSkillBar childNodeWithName:[NSString stringWithFormat:@"%d",PP_SKILLS_CHOOSE_BTN_TAG+i]];
                if ([spriteBtn.PPBallSkillStatus intValue]<=0) {
                    
                    spriteBtn.PPBallSkillStatus = [dictSkill objectForKey:@"skillcdrounds"];
                    spriteBtn.color = [UIColor blackColor];
                    spriteBtn.colorBlendFactor = 0.0;
                    spriteBtn.userInteractionEnabled = YES;
                    SKLabelNode *label=(SKLabelNode *)[spriteBtn childNodeWithName:PP_SKILL_CD_LABEL_NODE_NAME];
                    [label setText:[NSString stringWithFormat:@"%@",spriteBtn.PPBallSkillStatus]];
                }
            }
        }
        return;
    }
    
    petSkillBar = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, self.size.height)];
    //    petSkillBar.color =[UIColor blackColor];
    //    petSkillBar.colorBlendFactor = 0.6;
    
    // 添加技能槽
    for (int i = 0; i < 4; i++) {
        
        NSDictionary * dictSkill = nil;
        if ([self.pixiePlayer.pixieSkills count] > i) {
            dictSkill = [self.pixiePlayer.pixieSkills objectAtIndex:i];
        }
        
        NSString * stringSkillStatus = [dictSkill objectForKey:@"skillstatus"];
        NSString * stringSkillBtn = [dictSkill objectForKey:@"skillbtntexture"];
        
#warning 这里改了技能图标
        PPSpriteButton *  passButton = [PPSpriteButton buttonWithImageNamed:stringSkillBtn];
        passButton.size = CGSizeMake(50, 50);
        passButton.zPosition = PPZ_TABLE_BUTTON;
        
        if (![stringSkillStatus isEqualToString:@"valid"]) {
            stringSkillBtn = [NSString stringWithFormat:@"%@_none",kElementTypeString[self.pixiePlayer.pixieElement]];
            
            passButton.userInteractionEnabled = YES;
            [passButton addTarget:self selector:@selector(skillInvalidBtnClick:)
                       withObject:passButton forControlEvent:PPButtonControlEventTouchUp];
            
        } else {
            
            [passButton addTarget:self selector:@selector(skillPlayerShowBegin:)
                       withObject:passButton forControlEvent:PPButtonControlEventTouchUp];
            
            //            SKLabelNode *cdLabel = [SKLabelNode labelNodeWithFontNamed:PP_WORDS_FONT_NAME];
            //            cdLabel.fontSize = 10;
            //            cdLabel.name = PP_SKILL_CD_LABEL_NODE_NAME;
            //            cdLabel.position = CGPointMake(0,0.0f);
            //            [cdLabel setColor:[UIColor orangeColor]];
            //            [cdLabel setText:[NSString stringWithFormat:@"%@",[dictSkill objectForKey:@"skillcdrounds"]]];
            //            [passButton addChild:cdLabel];
        }
        passButton.PPBallPhysicsBodyStatus = @1;
        
        passButton.color = [UIColor blackColor];
        passButton.colorBlendFactor = 0.0;
        passButton.userInteractionEnabled = YES;
        passButton.name = [NSString stringWithFormat:@"%d",PP_SKILLS_CHOOSE_BTN_TAG+i];
        passButton.position = CGPointMake(65*i - 112.0f, 0.0f);
        [petSkillBar addChild:passButton];
        
        
        SKLabelNode *cdLabel = [SKLabelNode labelNodeWithFontNamed:PP_WORDS_FONT_NAME];
        cdLabel.fontSize = 19;
        cdLabel.name = PP_SKILL_CD_LABEL_NODE_NAME;
        cdLabel.position = CGPointMake(passButton.size.width/2.0f,10.0f);
        //        cdLabel.position = passButton.position;
        [cdLabel setColor:[UIColor orangeColor]];
        [cdLabel setFontColor:[UIColor redColor]];
        NSString *cdString = [NSString stringWithFormat:@"%@",[dictSkill objectForKey:@"skillcdrounds"]];
        passButton.PPBallSkillStatus = [dictSkill objectForKey:@"skillcdrounds"];
        [cdLabel setText:cdString];
        NSLog(@"cdString=%@",cdString);
        [passButton addChild:cdLabel];
    }
    
    petSkillBar.position = CGPointMake(self.size.width/2.0f, self.ballPlayer.position.y+50);
    [self addChild:petSkillBar];
    
    isShowingSkillBar = YES;
    [self setPlayerSideRoundRunState];
}

-(void)removeSkillBar
{
    if (petSkillBar) {
        petSkillBar.zPosition = -5;
        petSkillBar.hidden = YES;
        [self setPlayerSideRoundEndState];
        
    }
    isShowingSkillBar = NO;
}

// 结算combo添加元素球
-(void)creatCombosTotal:(NSString *)stringSide
{
    //    if ([stringSide isEqualToString:PP_BALL_TYPE_PET_ELEMENT_NAME]) {
    //        [self addRandomBalls:petCombos
    //                 withElement:self.pixiePlayer.pixieBall.ballElementType
    //                 andNodeName:stringSide];
    //        petCombos = 0;
    //
    //    }else
    //    {
    //
    //         [self addRandomBalls:enemyCombos withElement:self.pixieEnemy.pixieBall.ballElementType andNodeName:stringSide];
    //        enemyCombos = 0;
    //
    //    }
    //
    
    /*
     NSLog(@"pet element=%ld combos=%d  enemy element=%ld combos=%d",
     self.pixiePlayer.pixieBall.ballElementType,
     petCombos,
     self.pixieEnemy.pixieBall.ballElementType,
     enemyCombos);
     */
    
    [self.playerAndEnemySide setComboLabelText:petCombos withEnemy:enemyCombos];
}

// 添加随机的元素球
-(void)addRandomBalls:(int)number withElement:(PPElementType)element andNodeName:(NSString *)nodeName
{
    if (number <= 0) return;
    
    int countToGenerate=number/kBallSustainRounds;
    int lastBallSustainRounds = number%kBallSustainRounds;
    
    if (countToGenerate == 0 && lastBallSustainRounds != 0) {
        
        PPBall * tBall = [PPBall ballWithElement:element];
        tBall.position = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y+PP_FIT_TOP_SIZE);
        
        if (tBall.position.x >= 290) tBall.position = CGPointMake(290.0f, tBall.position.y);
        if (fabsf(tBall.position.y) > 380) tBall.position = CGPointMake(tBall.position.x, 380);
        tBall.ballElementType = element;
        tBall.name = nodeName;
        tBall.sustainRounds = lastBallSustainRounds;
        tBall->target = self;
        tBall->animationEndSel = @selector(elementBallAnimationEnd:);
        tBall.physicsBody.categoryBitMask = EntityCategoryBall;
        tBall.physicsBody.contactTestBitMask = EntityCategoryBall|EntityCategoryWall;
        tBall.physicsBody.collisionBitMask = EntityCategoryBall|EntityCategoryWall;
        tBall.physicsBody.PPBallPhysicsBodyStatus = [NSNumber numberWithInt:PP_ELEMENT_NAME_TAG + 1];
        
        [self addChild:tBall];
        [tBall setRoundsLabel:tBall.sustainRounds];
        [tBall startElementBirthAnimation];
        [self.ballsElement addObject:tBall];
        return;
    }
    
    if (lastBallSustainRounds != 0) {
        countToGenerate++;
    }
    
    if (countToGenerate > 5) {
        countToGenerate = 5;
        lastBallSustainRounds = kBallSustainRounds;
    }
    
    if (lastBallSustainRounds != 0) {
        
        for (int i = 0; i < countToGenerate; i++) {
            
            if (i != countToGenerate-1) {
                
                PPBall * tBall = [PPBall ballWithElement:element];
                tBall.position = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y+PP_FIT_TOP_SIZE);
                if (tBall.position.x>=290) {
                    tBall.position = CGPointMake(290.0f, tBall.position.y);
                }
                if (fabsf(tBall.position.y)>380) {
                    tBall.position = CGPointMake(tBall.position.x, 380);
                    
                }
                tBall.ballElementType = element;
                tBall.physicsBody.node.name = nodeName;
                tBall.name = nodeName;
                tBall->target = self;
                tBall->animationEndSel = @selector(elementBallAnimationEnd:);
                tBall.physicsBody.categoryBitMask = EntityCategoryBall;
                tBall.physicsBody.contactTestBitMask = EntityCategoryBall|EntityCategoryWall;
                tBall.physicsBody.collisionBitMask = EntityCategoryBall|EntityCategoryWall;
                tBall.sustainRounds = kBallSustainRounds;
                NSLog(@"kBallSustainRounds = %d",kBallSustainRounds);
                
                [tBall setRoundsLabel:tBall.sustainRounds];
                
                tBall.physicsBody.contactTestBitMask = EntityCategoryBall;
                tBall.physicsBody.PPBallPhysicsBodyStatus = [NSNumber numberWithInt:PP_ELEMENT_NAME_TAG+1];
                [self addChild:tBall];
                [tBall startElementBirthAnimation];
                
                
                [self.ballsElement addObject:tBall];
                
            } else {
                
                PPBall * tBall = [PPBall ballWithElement:element];
                tBall.position = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y+PP_FIT_TOP_SIZE);
                if (tBall.position.x>=290) {
                    tBall.position = CGPointMake(290.0f, tBall.position.y);
                }
                if (fabsf(tBall.position.y)>=380) {
                    tBall.position = CGPointMake(tBall.position.x, 380);
                    
                }
                
                tBall.ballElementType = element;
                tBall.physicsBody.node.name = nodeName;
                tBall.name = nodeName;
                tBall.physicsBody.categoryBitMask = EntityCategoryBall;
                tBall.physicsBody.contactTestBitMask = EntityCategoryBall|EntityCategoryWall;
                tBall.physicsBody.collisionBitMask = EntityCategoryBall|EntityCategoryWall;
                tBall->target = self;
                tBall->animationEndSel = @selector(elementBallAnimationEnd:);
                tBall.sustainRounds = lastBallSustainRounds;
                tBall.physicsBody.contactTestBitMask = EntityCategoryBall;
                NSLog(@"lastBallSustainRounds = %d",lastBallSustainRounds);
                
                [tBall setRoundsLabel:tBall.sustainRounds];
                tBall.physicsBody.PPBallPhysicsBodyStatus = [NSNumber numberWithInt:PP_ELEMENT_NAME_TAG+1];
                
                [self addChild:tBall];
                [self.ballsElement addObject:tBall];
                
                [tBall startElementBirthAnimation];
                
                
                
            }
            
        }
    } else {
        for (int i = 0; i < countToGenerate; i++) {
            
            PPBall * tBall = [PPBall ballWithElement:element];
            tBall.position = CGPointMake(BALL_RANDOM_X, BALL_RANDOM_Y+PP_FIT_TOP_SIZE);
            if (tBall.position.x>=290) {
                tBall.position = CGPointMake(290.0f, tBall.position.y);
            }
            if (fabsf(tBall.position.y)>380) {
                tBall.position = CGPointMake(tBall.position.x, 380);
                
            }
            tBall.ballElementType = element;
            tBall.physicsBody.node.name = nodeName;
            tBall.name = nodeName;
            tBall->target = self;
            tBall->animationEndSel = @selector(elementBallAnimationEnd:);
            tBall.physicsBody.categoryBitMask = EntityCategoryBall;
            tBall.physicsBody.contactTestBitMask = EntityCategoryBall|EntityCategoryWall;
            tBall.physicsBody.collisionBitMask = EntityCategoryBall|EntityCategoryWall;
            tBall.sustainRounds = kBallSustainRounds;
            NSLog(@"kBallSustainRounds = %d",kBallSustainRounds);
            
            [tBall setRoundsLabel:tBall.sustainRounds];
            
            tBall.physicsBody.contactTestBitMask = EntityCategoryBall;
            tBall.physicsBody.PPBallPhysicsBodyStatus = [NSNumber numberWithInt:PP_ELEMENT_NAME_TAG+1];
            
            [self addChild:tBall];
            [tBall startElementBirthAnimation];
            
            [self.ballsElement addObject:tBall];
        }
    }
}

//改变元素球持续回合数
-(void)changeBallsRoundsEnd
{
    
    NSLog(@"ballsElement count=%d",(int)[self.ballsElement count]);
    
    [self enumerateChildNodesWithName:PP_BALL_TYPE_PET_ELEMENT_NAME usingBlock:^(SKNode *node,BOOL *stop){
        PPBall *tBall=(PPBall *)node;
        tBall.sustainRounds--;
        [tBall setRoundsLabel:tBall.sustainRounds];
        
        if (tBall.sustainRounds <= 0) {
            [self.ballsElement removeObject:tBall];
            [tBall startRemoveAnimation:self.ballsElement andScene:self];
        }
        //
        //        if ([tBall.physicsBody.PPBallSkillStatus intValue]==1) {
        //            [tBall startMagicballAnimation];
        //        }
        
    }];
    
    [self enumerateChildNodesWithName:PP_BALL_TYPE_ENEMY_ELEMENT_NAME usingBlock:^(SKNode *node,BOOL *stop){
        PPBall *tBall = (PPBall *)node;
        tBall.sustainRounds--;
        [tBall setRoundsLabel:tBall.sustainRounds];
        
        if (tBall.sustainRounds <= 0) {
            [self.ballsElement removeObject:tBall];
            [tBall startRemoveAnimation:self.ballsElement andScene:self];
        }
    }];
    
    [self changeBuffRound];
}

//设置元素球标记值
-(void)setPhysicsTagValue
{
    
    for (int i = 0; i < [self.ballsElement count]; i++) {
        PPBall * tBall = [self.ballsElement objectAtIndex:i];
        tBall.physicsBody.PPBallPhysicsBodyStatus=[NSNumber numberWithInt:PP_ELEMENT_NAME_TAG+i];
    }
    
}
-(PPBuff *)getBuff:(NSString *)buffId{
    PPBuff *buffTmp=[[PPBuff alloc] init];
    buffTmp.buffId = buffId;
    return buffTmp;
}

//获取图片拼接node
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

#pragma mark Rounds and Turns

//回合开始
-(void)roundRotateBegin
{
    roundActionNum = 0;
    roundIndex += 1;
    petCombos = 0;
    enemyCombos = 0;
    [self setRoundNumberLabel:@"回合开始" begin:YES];
    
}

//回合推进
-(void)roundRotateMoved:(NSString *)nodeName
{
    [self setPlayerSideRoundRunState];
    
    roundActionNum += 1;
    
    //如果回合的一半
    if(roundActionNum==1)
    {
        if ([nodeName isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
            
            [self enemyAttackDecision];
        }else
        {
            
            [self setPlayerSideRoundEndState];
            [self creatCombosTotal:PP_BALL_TYPE_PET_ELEMENT_NAME];
            
            
        }
    }else
    {
        [self roundRotateEnd];
    }
}

//回合结束
-(void)roundRotateEnd
{
    roundActionNum = 0;
    
    [self setRoundNumberLabel:@"回合结束" begin:NO];
    [self changeSkillBtnCdRounds];
    
    [self performSelectorOnMainThread:@selector(roundRotateBegin) withObject:nil afterDelay:3];
    
}

#pragma mark Battle Procceed

//敌方攻击方式AI
-(void)enemyAttackDecision
{
    
    int decision = 0;
//    int decision = arc4random() % 2;
    [self setPlayerSideRoundRunState];
    
    NSLog(@"ppballskillStatus=%d",[self.ballEnemy.physicsBody.PPBallSkillStatus intValue]);
    
    switch ([self.ballEnemy.PPBallSkillStatus intValue]) {
        case PPBuffTypeRattanTwineEffect:
        {
            [self roundRotateMoved:PP_ENEMY_SIDE_NODE_NAME];
        }
            break;
            
        default:
        {
            
            [self creatCombosTotal:PP_BALL_TYPE_ENEMY_ELEMENT_NAME];
            [self performSelector:@selector(executeEnemyRoundAction:) withObject:[NSNumber numberWithInt:decision] afterDelay:1];
            
        }
            break;
    }
}

//进行敌方攻击
-(void)executeEnemyRoundAction:(NSNumber *)decision
{
    
    switch ([decision intValue]) {
        case 0:
        {
            
            [self physicsAttackBegin:PP_ENEMY_SIDE_NODE_NAME];
        }
            break;
        case 1:
        {
            [self showEnemySkillEventBegin:[self.playerAndEnemySide.currentPPPixieEnemy.pixieSkills objectAtIndex:0]];
        }
            break;
        default:
        {
        }
    }
    
}
//敌方弹球攻击
-(void)enemyDoPhysicsAttack
{
    
    [self changeBallStatus:PP_ENEMY_SIDE_NODE_NAME];
    
    
    currentPhysicsAttack = 2;
    float randomX = arc4random() % (int)(kAutoAttackMax * 2) - kAutoAttackMax;
    float randomY = arc4random() % (int)(kAutoAttackMax * 2) - kAutoAttackMax;
    [self.ballEnemy.physicsBody applyImpulse:CGVectorMake(randomX, randomY)];
    [self addBallMoveAnimation:self.ballEnemy.position];
    
    [self.ballEnemy startPixieAccelerateAnimation:CGVectorMake(randomX, randomY) andType:@"step"];
    [self setPlayerSideRoundRunState];
    _isBallRolling = YES;
    
    
    
}

//增加连击数显示
-(void)addComboValueChangeCombos:(int)value position:(CGPoint)labelPosition
{
    SKSpriteNode *contentSprite= [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)];
    contentSprite.position = labelPosition;
    
    SKSpriteNode *xSpriteNode=[SKSpriteNode spriteNodeWithTexture:[[PPAtlasManager ui_number] textureNamed:@"orange_x"]];
    xSpriteNode.position = CGPointMake(-7.5, 0.0f);
    xSpriteNode.size = CGSizeMake(14.0f, 13.0f);
    
    [contentSprite addChild:xSpriteNode];
    
    SKSpriteNode *labelCombos=[self getNumber:value AndColor:@"orange"];
    labelCombos.position=CGPointMake(7.5, 0.0f);
    labelCombos.size = CGSizeMake(14.0f, 13.0f);
    [contentSprite addChild:labelCombos];
    
    [self addChild:contentSprite];
    
    
    SKAction *actionScale = [SKAction scaleBy:1.5 duration:0.2];
    SKAction *actionFade = [SKAction fadeAlphaTo:0.0f duration:0.3];
    SKAction *showAction = [SKAction sequence:[NSArray arrayWithObjects:actionScale, actionFade, nil]];
    
    [contentSprite runAction:showAction completion:^{
        [contentSprite removeFromParent];
    }];
}

//增加血量变化显示
-(void)addValueChangeLabel:(int)value position:(CGPoint)labelPosition andColor:(NSString *)string
{
    
    //    SKLabelNode *additonLabel= [[SKLabelNode alloc] init];
    SKSpriteNode * additonLabel = [self getNumber:value AndColor:string];
    additonLabel.name  = @"hpchange";
    //    additonLabel.fontColor = [UIColor redColor];
    additonLabel.position = labelPosition;
    [self addChild:additonLabel];
    
    SKAction *actionScale = [SKAction scaleBy:1.5 duration:0.2];
    SKAction *actionFade = [SKAction fadeAlphaTo:0.0f duration:0.3];
    SKAction *showAction = [SKAction sequence:[NSArray arrayWithObjects:actionScale, actionFade, nil]];
    
    [additonLabel runAction:showAction completion:^{
        [additonLabel removeFromParent];
    }];
}


//设置回合数显示 isBegin YES：回合开始 NO：回合结束
-(void)setRoundNumberLabel:(NSString *)text begin:(BOOL)isBegin
{
    if (isBegin) {
        
        SKSpriteNode *roundLabelContent=[[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(320, 240)];
        [roundLabelContent setPosition:CGPointMake(160.0f, 300)];
        roundLabelContent.zPosition =  PPZ_FIGHT_EFFECT_ATT;
        [self addChild:roundLabelContent];
        roundLabelContent.alpha = 0.0f;
        
        SKSpriteNode *numberNode=[self getNumber:roundIndex AndColor:@"blue"];
        numberNode.size = CGSizeMake(50.0f, 50.0f);
        numberNode.xScale = 1.0f;
        numberNode.yScale = 1.0f;
        numberNode.position = CGPointMake(-30.0f, 0);
        [roundLabelContent addChild:numberNode];
        
        SKLabelNode *additonLabel= [[SKLabelNode alloc] init];
        additonLabel.name  = @"RoundLabel";
        additonLabel.fontColor = [UIColor redColor];
        additonLabel.position = CGPointMake(numberNode.position.x+numberNode.size.width/2.0f+10.0f, -6.0f);
        [additonLabel setFontSize:15];
        [additonLabel setText:text];
        [roundLabelContent addChild:additonLabel];
        
        SKAction *actionScale1 = [SKAction scaleBy:2.0 duration:0.5];
        SKAction *actionFade1 = [SKAction fadeAlphaTo:1.0 duration:0.5];
        SKAction *actionFirst = [SKAction group:[NSArray arrayWithObjects:actionScale1,actionFade1, nil]];
        SKAction *actionScale2 = [SKAction fadeAlphaTo:1.0 duration:1];
        SKAction *actionFade2 = [SKAction fadeAlphaTo:0.0 duration:1.0f];
        SKAction *actionResult = [SKAction sequence:[NSArray arrayWithObjects:actionFirst,actionScale2,actionFade2,nil]];
        
        [roundLabelContent runAction:actionResult completion:^{
            [roundLabelContent removeFromParent];
//            [self enemyAttackDecision];
            [self setPlayerSideRoundEndState];
            [self creatCombosTotal:PP_BALL_TYPE_PET_ELEMENT_NAME];
        }];
        [self changeBallsRoundsEnd];
    } else {
        SKSpriteNode * roundLabelContent = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(320, 240)];
        [roundLabelContent setPosition:CGPointMake(160.0f, 300)];
        [self addChild:roundLabelContent];
        roundLabelContent.alpha = 0.0f;
        
        SKSpriteNode * numberNode = [self getNumber:roundIndex AndColor:@"blue"];
        numberNode.size = CGSizeMake(50.0f, 50.0f);
        numberNode.xScale = 1.0f;
        numberNode.yScale = 1.0f;
        numberNode.position = CGPointMake(-30.0f, 0);
        [roundLabelContent addChild:numberNode];
        
        SKLabelNode *additonLabel= [[SKLabelNode alloc] init];
        additonLabel.name  = @"RoundLabel";
        additonLabel.fontColor = [UIColor redColor];
        additonLabel.position = CGPointMake(numberNode.position.x+numberNode.size.width/2.0f+10.0f, -6.0f);
        [additonLabel setFontSize:15];
        [additonLabel setText:text];
        [roundLabelContent addChild:additonLabel];
        
        SKAction * actionScale1 = [SKAction scaleBy:2.0 duration:0.5];
        SKAction * actionFade1 = [SKAction fadeAlphaTo:1.0 duration:0.5];
        SKAction * actionFirst = [SKAction group:[NSArray arrayWithObjects:actionScale1,actionFade1, nil]];
        SKAction * actionScale2 = [SKAction fadeAlphaTo:1.0 duration:1];
        SKAction * actionFade2 = [SKAction fadeAlphaTo:0.0 duration:1.0f];
        SKAction * actionResult = [SKAction sequence:[NSArray arrayWithObjects:actionFirst,actionScale2,actionFade2,nil]];
        
        [roundLabelContent runAction:actionResult completion:^{
            [roundLabelContent removeFromParent];
        }];
        
        battleSkillInfo.rattanTwineState = 0;
    }
}

//回合进行状态 玩家不能操作技能及弹球
-(void)setPlayerSideRoundRunState
{
    isNotSkillRun = YES;
    [self.ballPlayer closeActiveStatus];
    
    //    [self.playerSkillSide setSideSkillButtonDisable];
}

//回合结束状态 玩家可进行操作
-(void)setPlayerSideRoundEndState
{
    isNotSkillRun = NO;
    [self.ballPlayer startActiveStatus];
    
    //    [self.playerSkillSide setSideSkillButtonEnable];
}

//物理攻击开始提示
-(void)physicsAttackBegin:(NSString *)nodeName
{
    NSLog(@"nodeName=%@",nodeName);
    
    if ([nodeName isEqual:PP_PET_PLAYER_SIDE_NODE_NAME]) {
        
    } else {
        
        SKLabelNode * labelNode = (SKLabelNode *)[self childNodeWithName:@"EnemyPhysics"];
        if (labelNode) [labelNode removeFromParent];
        
        SKLabelNode * additonLabel= [[SKLabelNode alloc] init];
        additonLabel.name  = @"EnemyPhysics";
        additonLabel.position = CGPointMake(160.0f, 200.0f);
        [additonLabel setText:@"敌方弹球攻击"];
        [self addChild:additonLabel];
        
        SKAction * actionScale = [SKAction scaleBy:2.0 duration:1];
        [additonLabel runAction:actionScale completion:^{
            [additonLabel removeFromParent];
            [self enemyDoPhysicsAttack];
        }];
    }
}

//物理攻击技术（暂废弃）
-(void)ballAttackEnd:(NSInteger)ballsCount
{
    [self physicsAttackBegin:PP_PET_PLAYER_SIDE_NODE_NAME];
    
    SKLabelNode * skillNameLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    [skillNameLabel setFontSize:20];
    skillNameLabel.fontColor = [UIColor whiteColor];
    skillNameLabel.text = @"弹球攻击";
    skillNameLabel.position = CGPointMake(100.0f,221);
    [self addChild:skillNameLabel];
    
    SKLabelNode * ballsLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    [ballsLabel setFontSize:20];
    ballsLabel.fontColor = [UIColor whiteColor];
    ballsLabel.text = [NSString stringWithFormat:@"吸收球数:%d",(int)ballsCount];
    ballsLabel.position = CGPointMake(200.0f,221);
    [self addChild:ballsLabel];
    
    SKAction * action = [SKAction fadeAlphaTo:0.0f duration:5];
    [skillNameLabel runAction:action];
    [ballsLabel runAction:action];
}

#pragma mark skill btn click

//技能不可用按钮点击
-(void)skillInvalidBtnClick:(PPSpriteButton *)skillInvalidButton
{
    
    //       NSDictionary *skillChoosed = [self.ballPlayer.pixie.pixieSkills objectAtIndex:[skillInvalidButton.name intValue] - PP_SKILLS_CHOOSE_BTN_TAG];
    
    SKLabelNode * labelNode = (SKLabelNode *)[self childNodeWithName:@"mpisnotenough"];
    if (labelNode) [labelNode removeFromParent];
    
    SKLabelNode * additonLabel= [[SKLabelNode alloc] init];
    additonLabel.name  = @"mpisnotenough";
    additonLabel.fontColor = [UIColor redColor];
    additonLabel.position = CGPointMake(160.0f, 200.0f);
    [additonLabel setText:@"技能不可用"];
    [self addChild:additonLabel];
    
    SKAction * actionScale = [SKAction scaleBy:2.0 duration:1];
    [additonLabel runAction:actionScale completion:^{
        [additonLabel removeFromParent];
        isNotSkillShowTime = NO;
        [self setPlayerSideRoundEndState];
    }];
}

//技能动画展示开始
-(void)skillPlayerShowBegin:(PPSpriteButton *)skillButton
{
    NSDictionary * skillInfo = [self.ballPlayer.pixie.pixieSkills objectAtIndex:
                                [skillButton.name intValue] - PP_SKILLS_CHOOSE_BTN_TAG];
    CGFloat mpToConsume = [[skillInfo objectForKey:@"skillmpchange"] floatValue];
    NSLog(@"currentMP=%f mptoConsume=%f",self.playerAndEnemySide.currentPPPixie.currentMP,mpToConsume);
    NSLog(@"skillInfo=%@",skillInfo);
    [self setPlayerSideRoundRunState];
    
    if (self.playerAndEnemySide.currentPPPixie.currentMP < fabsf(mpToConsume)) {
        
        SKLabelNode * labelNode = (SKLabelNode *)[self childNodeWithName:@"mpisnotenough"];
        if (labelNode) [labelNode removeFromParent];
        
//        SKLabelNode * additonLabel = [[SKLabelNode alloc] init];
//        additonLabel.name  = @"mpisnotenough";
//        additonLabel.fontColor = [UIColor redColor];
//        additonLabel.position = CGPointMake(160.0f, 200.0f);
//        [self addChild:additonLabel];
//        
//        
//        [additonLabel setText:[NSString stringWithFormat:@"%@已释放",[skillInfo objectForKey:@"skillname"]]];
        [self removeSkillBar];
        
        
        switch ([[skillInfo objectForKey:@"skillid"] intValue]) {
            case PPBuffTypeDevilRebirth:
            {
                battleSkillInfo.petHitRecoverHP = 10;
                [self addBuffAnimation:PPBuffTypeDevilRebirth];
            }
                break;
            case PPBuffTypeDevilBreath:
            {
                [self addBuffAnimation:PPBuffTypeDevilBreath];
                [self addSkillBuff:PPBuffTypeDevilBreath skillInfo:skillInfo];
            }
                break;
            case PPBuffTypeRattanTwine:
            {
                [self addBuffAnimation:PPBuffTypeRattanTwine];
                [self addSkillBuff:PPBuffTypeRattanTwine skillInfo:skillInfo];
            }
                break;
            case PPBuffTypeNightJudge:
            {
                [self addBuffAnimation:PPBuffTypeNightJudge];
                [self addSkillBuff:PPBuffTypeNightJudge skillInfo:skillInfo];
            }
                break;
                
            default:
                break;
        }
        
        SKAction * actionScale = [SKAction scaleBy:2.0 duration:1];
//        [additonLabel runAction:actionScale completion:^{
//            [additonLabel removeFromParent];
//            isNotSkillShowTime = NO;
//            [self setPlayerSideRoundEndState];
//        }];
        isNotSkillShowTime = NO;
        [self setPlayerSideRoundEndState];
        skillButton.color = [UIColor blackColor];
        skillButton.colorBlendFactor = 0.6;
        skillButton.userInteractionEnabled = NO;
        skillButton.PPBallPhysicsBodyStatus = @1;
        
        return ;
    } else {
        [self.playerAndEnemySide changePetMPValue:mpToConsume];
    }
    
    //    if (isNotSkillShowTime) return;
    
    NSLog(@"skillInfo=%@",skillInfo);
    
    switch ([[skillInfo objectForKey:@"skilltype"] intValue]) {
            
        case 0:
        {
            [self showSkillEventBegin:skillInfo];
        }
            break;
            
        case 1:
        {
            isNotSkillShowTime = YES;
            isNotSkillRun = NO;
            
            if ([[skillInfo objectForKey:@"skillname"] isEqualToString:@"森林瞬起"]) {
                
                
                //                NSMutableArray *animanArryay = [[NSMutableArray alloc] init];
                //
                //                for (int i=0; i <10; i++) {
                //                    SKTexture * temp = [[PPAtlasManager ball_magic] textureNamed:[NSString stringWithFormat:@"magic_ball_00%02d",i]];
                //                    [animanArryay addObject:temp];
                //                }
                
                
                for (PPBall * tBall in self.ballsElement) {
                    if (tBall.ballElementType == PPElementTypePlant) {
                        if ([tBall.physicsBody.PPBallSkillStatus intValue] != 1) {
                            tBall.physicsBody.PPBallSkillStatus = @1;
                            [tBall startMagicballAnimation];
                        }
                    }
                }
            }
            
            if ([[skillInfo objectForKey:@"skillname"] isEqualToString:@"木系掌控"]) {
                for (PPBall * tBall in self.ballsElement) {
                    if ([tBall.name isEqualToString:@"ball_plant"]) {
                        
                        //                    [tBall runAction:[SKAction moveTo:CGPointMake(tBall.position.x-10, tBall.position.y-20) duration:2]];
                        
                        [tBall runAction:[SKAction moveBy:CGVectorMake((self.ballPlayer.position.x - tBall.position.x)/2.0f,
                                                                       (self.ballPlayer.position.y - tBall.position.y)/2.0f)
                                                 duration:2]];
                    }
                }
            }
            
            //            [self roundRotateMoved:PP_PET_PLAYER_SIDE_NODE_NAME];
            
        }
            break;
            
        case 2:
        {
            [self showSkillEventBegin:skillInfo];
        }
            break;
            
        case 3:
        {
            [self showSkillEventBegin:skillInfo];
        }
            break;
            
        default:
            break;
    }
}

-(void)addBuffAnimation:(int)skillID
{
    
    switch (skillID) {
        case PPBuffTypeDevilRebirth:
        {
            
//            SKAction *actionDisplaySkill =[SKAction setTexture:[SKTexture textureWithImageNamed:@"01_devilrebirth.png"]];
//            SKSpriteNode *buffShowNode =[[SKSpriteNode alloc] init];
//            buffShowNode.size = CGSizeMake(115.0f, 107.0f);
//            //            [buffShowNode setPosition:self.playerAndEnemySide->ppixiePetBtn.position];
//            [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
//            
//            buffShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilRebirth];
            
           SKSpriteNode * buffShowNode = [PPAtlasManager createSpriteImageName:nil
                                                                       withPos:CGPointMake(0.0f, 0.0f)
                                                                      withSize:CGSizeMake(115.0f, 107.0f)
                                                                      withName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilRebirth]];
            [self.playerAndEnemySide->ppixiePetBtn addChild:buffShowNode];
            
//            SKAction *actionRep = [SKAction repeatAction:[[PPAtlasManager battle_fight_skill] getAnimation:@"01_devilrebirth"] count:0];
            SKAction *actionRep = [SKAction repeatActionForever:[[PPAtlasManager battle_fight_skill]
                                                                 getAnimation:@"01_devilrebirth"]];
            [buffShowNode runAction:actionRep];
        }
            break;
        case PPBuffTypeDevilBreath:
        {
            
            //            SKAction *actionDisplaySkill =[SKAction setTexture:[SKTexture textureWithImageNamed:@"02_devilbreath.png"]];
            
//            SKSpriteNode *buffShowNode =[[SKSpriteNode alloc] init];
//            buffShowNode.size = CGSizeMake(115.0f, 107.0f);
//            //            [buffShowNode setPosition:self.playerAndEnemySide->ppixiePetBtn.position];
//            [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
//            
            //            buffShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilBreath];
            
            SKSpriteNode * buffShowNode = [PPAtlasManager createSpriteImageName:nil
                                                                        withPos:CGPointMake(0.0f, 0.0f)
                                                                       withSize:CGSizeMake(115.0f, 107.0f)
                                                                       withName:[NSString stringWithFormat:@"%@%d", PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilBreath]];
            [self.playerAndEnemySide->ppixieEnemyBtn addChild:buffShowNode];
            SKAction *actionRep = [SKAction repeatActionForever:[[PPAtlasManager battle_fight_skill] getAnimation:@"02_devilbreath"]];
            
            [buffShowNode runAction:actionRep];
            
            
            
            //            SKSpriteNode *buffShowNode =[[SKSpriteNode alloc] init];
            //            buffShowNode.size = CGSizeMake(115.0f, 107.0f);
            //            [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
            //            [self.ballPlayer addChild:buffShowNode];
            //            SKAction *actionRep = [SKAction repeatAction:[[PPAtlasManager battle_fight_skill] getAnimation:@"02_devilbreath"] count:10];
            //
            //            [buffShowNode runAction:actionRep completion:^{
            //                //                if (buffShowNode) {
            //                //                    [buffShowNode removeFromParent];
            //                //                }
            //
            //            }];
            
            
        }
            break;
        case PPBuffTypeRattanTwine:
        {
            
            [self changeBallStatus:PP_PET_PLAYER_SIDE_NODE_NAME];
            
            
//            currentPhysicsAttack = 1;
//            float randomX = arc4random() % (int)(kAutoAttackMax * 2) - kAutoAttackMax;
//            float randomY = arc4random() % (int)(kAutoAttackMax * 2) - kAutoAttackMax;
//            NSLog(@"randomX=%f randomY=%f",randomX,randomY);
//            
//            [self.ballPlayer.physicsBody applyImpulse:CGVectorMake(30, 30)];
//            [self addBallMoveAnimation:self.ballPlayer.position];
//            
//            [self.ballPlayer startPixieAccelerateAnimation:CGVectorMake(randomX, randomY) andType:@"step"];
//            [self setPlayerSideRoundRunState];
//            _isBallRolling = YES;
            

            
            battleSkillInfo.rattanTwineState = 1;
            
            //            SKAction *actionDisplaySkill =[SKAction setTexture:[SKTexture textureWithImageNamed:@"02_devilbreath.png"]];
            
            //            SKSpriteNode *buffShowNode =[[SKSpriteNode alloc] init];
            //            buffShowNode.size = CGSizeMake(115.0f, 107.0f);
            //            //            [buffShowNode setPosition:self.playerAndEnemySide->ppixiePetBtn.position];
            //            [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
            //            buffShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilBreath];
            //
            //
            //
            //            [self.playerAndEnemySide->ppixiePetBtn addChild:buffShowNode];
            //
            //            //            SKAction *actionRep = [SKAction repeatAction:[[PPAtlasManager battle_fight_skill] getAnimation:@"01_devilrebirth"] count:0];
            //            SKAction *actionRep = [SKAction repeatActionForever:[[PPAtlasManager ball_elements] getAnimation:@"plant_aura"]];
            //
            //            [buffShowNode runAction:actionRep];
            
            
            
            //            SKSpriteNode *buffShowNode =[[SKSpriteNode alloc] init];
            //            buffShowNode.size = CGSizeMake(115.0f, 107.0f);
            //            [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
            //            [self.ballPlayer addChild:buffShowNode];
            //            SKAction *actionRep = [SKAction repeatAction:[[PPAtlasManager battle_fight_skill] getAnimation:@"02_devilbreath"] count:10];
            //
            //            [buffShowNode runAction:actionRep completion:^{
            //                //                if (buffShowNode) {
            //                //                    [buffShowNode removeFromParent];
            //                //                }
            //
            //            }];
            
        }
            break;
            case PPBuffTypeNightJudge:
        {
        
            SKSpriteNode *buffShowNode = [PPAtlasManager createSpriteImageName:nil withPos:CGPointMake(0.0f, 30.0f) withSize:CGSizeMake(300.0f, 50.0f) withName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeNightJudge]];
            [self.playerAndEnemySide->ppixiePetBtn addChild:buffShowNode];
            SKAction *actionRep = [SKAction repeatActionForever:[[PPAtlasManager battle_fight_skill] getAnimation:@"04_nightjudge"]];
            
            [buffShowNode runAction:actionRep];
        
        
        
        }
            break;
        default:
            break;
    }
}


-(void)addSkillBuff:(int) buffId skillInfo:(NSDictionary *)skillInfo
{
    
    
    switch (buffId) {
        case 1:
        {
        }
            break;
            
        case PPBuffTypeDevilBreath:
        {
            battleSkillInfo.enemyPoisoningHP = 50;
            PPBuff *buffId1 = [[PPBuff alloc] init];
            buffId1.continueRound = [[skillInfo objectForKey:@"skillcontinue"] intValue];
            buffId1.buffId =[NSString stringWithFormat:@"%d",PPBuffTypeDevilBreath];
            [self.battleBuffArray addObject:buffId1];
        }
            break;
            
        case PPBuffTypeRattanTwine:
        {
            battleSkillInfo.enemyPoisoningHP = 50;
            PPBuff * buffId1 = [[PPBuff alloc] init];
            buffId1.continueRound = [[skillInfo objectForKey:@"skillcontinue"] intValue];
            NSLog(@"buff.continueRound=%d skill=%@",buffId1.continueRound,skillInfo);
            buffId1.buffId =[NSString stringWithFormat:@"%d",PPBuffTypeRattanTwine];
            [self.battleBuffArray addObject:buffId1];
        }
            break;
            case PPBuffTypeNightJudge:
        {
            
            battleSkillInfo.nightJudgeValue = 1.5;
            PPBuff * buffId1 = [[PPBuff alloc] init];
            buffId1.continueRound = [[skillInfo objectForKey:@"skillcontinue"] intValue];
            NSLog(@"buff.continueRound=%d skill=%@",buffId1.continueRound,skillInfo);
            buffId1.buffId =[NSString stringWithFormat:@"%d",PPBuffTypeNightJudge];
            [self.battleBuffArray addObject:buffId1];
            
        }
        default:
            break;
    }
}

-(void)changeBuffRound
{
    for (int i = 0; i < [self.battleBuffArray count]; i++) {
        PPBuff * buff = [self.battleBuffArray objectAtIndex:i];
        buff.continueRound--;
        NSLog(@"continueRound =%d",buff.continueRound);
        
        if (buff.continueRound <= 0) {
            [self removeBuff:buff];
        } else {
            [self.playerAndEnemySide startAttackShowAnimation:YES];
            
            SKNode * buffshowNode = [self.playerAndEnemySide->ppixieEnemyBtn childNodeWithName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilBreath]];
            
            [buffshowNode runAction:[[PPAtlasManager battle_fight_skill] getAnimation:@"02_devilbreath_buff"] completion:^{
                [buffshowNode removeFromParent];
                [self addBuffAnimation:PPBuffTypeDevilBreath];
            }];
            
            [self.playerAndEnemySide changeEnemyHPValue:battleSkillInfo.enemyPoisoningHP];
        }
    }
}

-(void)removeBuff:(PPBuff *)buff
{
    switch ([buff.buffId intValue]) {
        case PPBuffTypeDevilBreath:
        {
            
            [[self.playerAndEnemySide->ppixieEnemyBtn childNodeWithName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeDevilBreath]] removeFromParent];
            battleSkillInfo.enemyPoisoningHP = 0;
            
        }
            break;
        case PPBuffTypeRattanTwine:
        {
            
            [self setComboBallSkillStatusOrigin];

            
        }
            break;
        case PPBuffTypeRattanTwineEffect:
        {
            
            self.ballEnemy.PPBallSkillStatus = 0;
            SKNode *nodeBuff = [self.ballEnemy childNodeWithName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine]];
            if (nodeBuff) {
                [nodeBuff removeFromParent];
            }
                                
            
        }
            break;
            case PPBuffTypeNightJudge:
        {
            
            battleSkillInfo.nightJudgeValue = 0.0f;
            [[self.playerAndEnemySide->ppixiePetBtn childNodeWithName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeNightJudge]] removeFromParent];
            
        }
            break;
            
        default:
            break;
    }
    if (buff) {
        
        [self.battleBuffArray removeObject:buff];
        
    }
    
}

//血条动画结束
-(void)hpChangeEndAnimate:(NSString *)battlesideName
{
    NSLog(@"battlesideName=%@",battlesideName);
}

-(void)removeBuff:(PPBuff *)buffToRemove andSide:(NSString *)stringSide
{
    [self.playerAndEnemySide removeBuffShow:buffToRemove andSide:stringSide];
}

#pragma mark Physics Attack show

//计算物理伤害
-(int)physicsAttackHPChangeValueCalculate:(NSString *)stringSide
{
    float hpChange = 0.0f;
    if ([stringSide isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
        hpChange = kHurtBasicValue * (1.0f + petCombos*petCombos / 100.0f);
    } else {
        hpChange = kHurtBasicValue * (1.0f + enemyCombos*enemyCombos / 100.0f);
    }
    NSLog(@"hpChange=%f petCombos=%d  enemyCombos=%d",hpChange,petCombos,enemyCombos);
    
    return (int)hpChange;
}

//物理 头像晃动结束
-(void)physicsAttackAnimationEnd:(NSString *)stringSide
{
    if ([stringSide isEqualToString:PP_PET_PLAYER_SIDE_NODE_NAME]) {
        [self.playerAndEnemySide changeEnemyHPValue:-[self physicsAttackHPChangeValueCalculate:stringSide]];
        [self roundRotateMoved:stringSide];
    } else {
        [self.playerAndEnemySide changePetHPValue:-[self physicsAttackHPChangeValueCalculate:stringSide]];
        [self roundRotateMoved:stringSide];
    }
}

//展示物理攻击动画  头像晃动
-(void)showPhysicsAttackAnimation:(NSString *)attackSide
{
    [self.playerAndEnemySide shakeHeadPortrait:attackSide andCompletion:self];
}

#pragma mark SkillBeginAnimateDelegate

//敌方技能动画
-(void)showEnemySkillEventBegin:(NSDictionary *)skillInfo
{
    [self setPlayerSideRoundRunState];
    
    PPSkillNode * skillNode = [PPSkillNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.size.width, 300)];
    skillNode.name = PP_ENEMY_SKILL_SHOW_NODE_NAME;
    skillNode.delegate = self;
    skillNode.position = CGPointMake(self.size.width/2.0f, 250.0f+PP_FIT_TOP_SIZE);
    [self addChild:skillNode];
    
    [skillNode showSkillAnimate:skillInfo andElement:PPElementTypeFire];
}

//我方技能动画
-(void)showSkillEventBegin:(NSDictionary *)skillInfo
{
    isNotSkillShowTime = YES;
    [self setPlayerSideRoundRunState];
    
    PPSkillNode * skillNode = [PPSkillNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.size.width, 300)];
    skillNode.delegate = self;
    skillNode.name = PP_PET_SKILL_SHOW_NODE_NAME;
    skillNode.position = CGPointMake(self.size.width/2, 250 + PP_FIT_TOP_SIZE);
    [self addChild:skillNode];
    
    [skillNode showSkillAnimate:skillInfo andElement:PPElementTypeFire];
}

#pragma mark SkillEndAnimateDelegate

//技能动画播放结束
-(void)skillEndEvent:(PPSkill *)skillInfo withSelfName:(NSString *)nodeName
{
    isNotSkillShowTime = NO;
    
    if ([nodeName isEqualToString:PP_ENEMY_SKILL_SHOW_NODE_NAME]){
        if (skillInfo.skillObject == 1) {
            [self.playerAndEnemySide changePetHPValue:skillInfo.HPChangeValue];
        } else {
            
            [self.playerAndEnemySide changeEnemyHPValue:skillInfo.HPChangeValue];
        }
        [self roundRotateMoved:PP_ENEMY_SIDE_NODE_NAME];
    } else {
        if (skillInfo.skillObject == 1) {
#warning 去掉旧版的技能Buff
//            if ([skillInfo.skillName isEqualToString:@"狼焰斩"]) {
//                [self.playerAndEnemySide addBuffShow:[self getBuff:@"1"] andSide:PP_ENEMY_SIDE_NODE_NAME];
//            }
            [self.playerAndEnemySide changeEnemyHPValue:skillInfo.HPChangeValue];
        } else {
            [self.playerAndEnemySide changePetHPValue:skillInfo.HPChangeValue];
        }
        [self roundRotateMoved:PP_PET_PLAYER_SIDE_NODE_NAME];
    }
}

#pragma mark ball delegate

-(void)elementBallAnimationEnd:(PPBall *)ball
{
    //    [ball removeFromParent];
    //    [self.ballsElement removeObject:ball];
    //    ball = nil;
}
#pragma mark SKScene  delegate

// 开始碰撞事件监测
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    if (!_isBallRolling) return;
    
    if((contact.bodyA == self.ballPlayer.physicsBody || contact.bodyB == self.ballPlayer.physicsBody))
        //如果我方人物球撞击到物体
    {
        
        if ((contact.bodyA == self.ballEnemy.physicsBody || contact.bodyB == self.ballEnemy.physicsBody))
        {
            
            [self addHitAnimationNodes:contact.contactPoint andType:kPetAndEnemyHitTypeValue];
            
            return;
        }
        
       
        
        //我方球体撞墙
        if ((contact.bodyA.categoryBitMask == EntityCategoryWall || contact.bodyB.categoryBitMask == EntityCategoryWall)) {
            
            NSLog(@"ballPlayer vec x=%f y=%f",self.ballPlayer.physicsBody.velocity.dx,self.ballPlayer.physicsBody.velocity.dy);
            NSLog(@"contact x=%f y=%f", contact.contactPoint.x,contact.contactPoint.y);
            
            [self addHitAnimationNodes:contact.contactPoint andType:kPetHitWallTypeValue];
            
            return;
            
        };
        
        if ([contact.bodyB.node.name isEqualToString:PP_BALL_TYPE_COMBO_NAME]||[contact.bodyA.node.name isEqualToString:PP_BALL_TYPE_COMBO_NAME])
            //我方碰到连击球
        {
            
            if(currentPhysicsAttack==0||currentPhysicsAttack==2){
                return ;
            }
            
            if (battleSkillInfo.petHitRecoverHP!=0) {
                
                
                SKSpriteNode *addHPAnimation = [self  getNumber:battleSkillInfo.petHitRecoverHP AndColor:@"green"];
                [addHPAnimation setPosition:CGPointMake(20.0f, 20.0f)];
                [self.playerAndEnemySide->ppixiePetBtn addChild:addHPAnimation];
                //                SKAction *actionDisplaySkill =[SKAction setTexture:[SKTexture textureWithImageNamed:@"01_devilrebirth.png"]];
                
                
                SKSpriteNode *nodeSkillBuffer=[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"01_devilrebirth.png"]];
                nodeSkillBuffer.position = contact.contactPoint;
                nodeSkillBuffer.size = CGSizeMake(nodeSkillBuffer.size.width/4.0f, nodeSkillBuffer.size.height/4.0f);
                [self addChild:nodeSkillBuffer];
                
                
                SKAction *actionRemove = [SKAction fadeAlphaTo:1.0f duration:0.5];
                
                [nodeSkillBuffer runAction:actionRemove completion:^{
                    
                    [nodeSkillBuffer removeFromParent];
                    
                }];
                
                
                [addHPAnimation runAction:[SKAction scaleTo:2.0f duration:1] completion:^{
                    
                    [addHPAnimation removeFromParent];
                    
                }];
                
            }
            
            if (battleSkillInfo.nightJudgeValue != 0.0f) {
                
                SKSpriteNode *nodeSkillBuffer=[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"02_devilbreath.png"]];
                nodeSkillBuffer.position = contact.contactPoint;
                nodeSkillBuffer.size = CGSizeMake(25.0f, 25.0f);
                [self addChild:nodeSkillBuffer];
                
                
                SKAction *actionRemove = [SKAction fadeAlphaTo:1.0f duration:0.5];
                
                [nodeSkillBuffer runAction:actionRemove completion:^{
                    
                    [nodeSkillBuffer removeFromParent];
                    
                }];
                
                
                
                SKSpriteNode *buffShowNode = [PPAtlasManager createSpriteImageName:nil withPos:CGPointMake(0.0f, 0.0f) withSize:CGSizeMake(115.0f, 107.0f) withName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeNightJudge]];
                [self.playerAndEnemySide->ppixiePetBtn addChild:buffShowNode];
                //                SKAction *actionRep = [SKAction repeatAction:[[PPAtlasManager battle_fight_skill] getAnimation:@"02_devilbreath"] count:1:];
                SKAction *windEffect = [[PPAtlasManager battle_fight_skill] getAnimation:@"04_nightjudge_hit"];
                SKAction *moveAction=[SKAction moveByX:self.playerAndEnemySide->ppixieEnemyBtn.position.x-self.playerAndEnemySide->ppixiePetBtn.position.x  y:0 duration:1];
                SKAction *groupAct=[SKAction group:@[windEffect,moveAction]];
                
                
                [buffShowNode runAction:groupAct completion:^{
                    [buffShowNode removeFromParent];
                }];
                
                [self.playerAndEnemySide startAttackShowAnimation:YES];
                
                return;
                //                battleSkillInfo.nightJudgeValue= 0.0f;
                
            }
            PPBall * ballCombo = nil;
            if (contact.bodyA == self.ballPlayer.physicsBody) {
                
                
                ballCombo=[self.ballsCombos objectAtIndex:[contact.bodyB.PPBallPhysicsBodyStatus intValue]];
                [ballCombo startComboAnimation:CGVectorMake(self.ballPlayer.position.x-ballCombo.position.x,self.ballPlayer.position.y-ballCombo.position.y)];
                
                
                
            } else {
                
                ballCombo=[self.ballsCombos objectAtIndex:[contact.bodyA.PPBallPhysicsBodyStatus intValue]];
                [ballCombo startComboAnimation:CGVectorMake(self.ballPlayer.position.x-ballCombo.position.x,self.ballPlayer.position.y-ballCombo.position.y)];
                
            }
            
            petCombos++;
            
            //恶魔重生
            if (battleSkillInfo.petHitRecoverHP != 0) {
                [self.playerAndEnemySide changePetHPValue:battleSkillInfo.petHitRecoverHP];
                NSLog(@"恶魔重生=%d",battleSkillInfo.petHitRecoverHP);
                [self removeSkillBar];
                
            }
            
            if (battleSkillInfo.enemyPoisoningHP != 0) {
                battleSkillInfo.enemyPoisoningHP *= (1.1) ;
            }
            
            if (battleSkillInfo.rattanTwineState == 1) {
                
                SKNode * node = [ballCombo childNodeWithName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine]];
                if (node) {
                    [node removeFromParent];
                }
                
                SKAction * actionRep = [[PPAtlasManager ball_elements] getAnimation:@"plant_aura"];
                SKAction * actionRepForever =[SKAction repeatActionForever:actionRep];
                
                SKSpriteNode * buffShowNode =[[SKSpriteNode alloc] initWithImageNamed:@"plant_aura_0000"];
                buffShowNode.size = CGSizeMake(115.0f, 107.0f);
                //            [buffShowNode setPosition:self.playerAndEnemySide->ppixiePetBtn.position];
                [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
                
                buffShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine];
                ballCombo.PPBallSkillStatus =[NSNumber numberWithInt:PPBuffTypeRattanTwine];
                [ballCombo addChild:buffShowNode];
                
                [buffShowNode runAction:actionRepForever completion:^{
                    
                    
                   
                    
                }];
                
                
                SKSpriteNode *buffRatShowNode =[[SKSpriteNode alloc] init];
                buffRatShowNode.size = CGSizeMake(50.0f, 50.0f);
                //            [buffShowNode setPosition:self.playerAndEnemySide->ppixiePetBtn.position];
                [buffRatShowNode setPosition:CGPointMake(-25.0f, 0.0f)];
                buffRatShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine];
                
                
                [self.playerAndEnemySide->ppixiePetBtn addChild:buffRatShowNode];
                
                SKAction *actionReprat = [SKAction repeatActionForever:[[PPAtlasManager battle_fight_skill] getAnimation:@"03_rattantwine"]];
                [buffRatShowNode runAction:actionReprat];
                
                [self.playerAndEnemySide startAttackShowAnimation:YES];
                
             
                
            }
            
            
            [self.playerAndEnemySide setComboLabelText:petCombos withEnemy:enemyCombos];
            [self.playerAndEnemySide startAttackAnimation:YES];
            [self dealPixieBallContactComboBall:contact andPetBall:self.ballPlayer];
            
            [self addComboValueChangeCombos:petCombos position:self.ballPlayer.position];
            
            return;
            
        }
    } else if ((contact.bodyA == self.ballEnemy.physicsBody || contact.bodyB == self.ballEnemy.physicsBody))
        //如果敌方人物球撞击到物体
    {
      
        
        if ((contact.bodyA == self.ballPlayer.physicsBody || contact.bodyB == self.ballPlayer.physicsBody)){
            [self addHitAnimationNodes:contact.contactPoint andType:kPetAndEnemyHitTypeValue];
            
            return;
        }
        
        //敌方球体撞墙
        if ((contact.bodyA.categoryBitMask == EntityCategoryWall || contact.bodyB.categoryBitMask == EntityCategoryWall)) {
            
            NSLog(@"ballEnemy vec x=%f y=%f",self.ballEnemy.physicsBody.velocity.dx,self.ballEnemy.physicsBody.velocity.dy);
            
            [self addHitAnimationNodes:contact.contactPoint andType:kEnemyHitWallTypeValue];
        };
        
        
        if ([contact.bodyB.node.name isEqualToString:PP_BALL_TYPE_COMBO_NAME]||[contact.bodyA.node.name isEqualToString:PP_BALL_TYPE_COMBO_NAME])
            //敌方碰到连击球
        {
            
            if(currentPhysicsAttack==0||currentPhysicsAttack==1){
                return ;
            }
            
            NSLog(@"bodyStatus=%d",[contact.bodyB.PPBallPhysicsBodyStatus intValue]);
            [self.playerAndEnemySide resetPetAndEnemyPosition];
            PPBall *ballCombo = nil;
            
            if (contact.bodyA == self.ballEnemy.physicsBody) {
                ballCombo=[self.ballsCombos objectAtIndex:[contact.bodyB.PPBallPhysicsBodyStatus intValue]];
              
            } else {
                ballCombo=[self.ballsCombos objectAtIndex:[contact.bodyA.PPBallPhysicsBodyStatus intValue]];
//                [ballCombo startComboAnimation:CGVectorMake(self.ballEnemy.position.x-ballCombo.position.x,self.ballEnemy.position.y-ballCombo.position.y)];
            }
            if ([ballCombo.PPBallSkillStatus intValue] == PPBuffTypeRattanTwine) {
                
                [self changeBallStatus:PP_PET_PLAYER_SIDE_NODE_NAME];
                SKAction *actionRep = [[PPAtlasManager ball_buff] getAnimation:@"plant_root_appear"];
//                SKAction  *actionRepForever =[SKAction repeatActionForever:actionRep];
                
//                SKSpriteNode *buffShowNode =[[SKSpriteNode alloc] initWithImageNamed:@"plant_root_appear_0012"];
//                buffShowNode.size = CGSizeMake(115.0f, 107.0f);
//                //            [buffShowNode setPosition:self.playerAndEnemySide->ppixiePetBtn.position];
//                [buffShowNode setPosition:CGPointMake(0.0f, 0.0f)];
//                
//                buffShowNode.name = [NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine];
               SKSpriteNode *buffShowNode= [PPAtlasManager createSpriteImageName:@"plant_root_appear_0012" withPos:CGPointMake(0.0f, 0.0f) withSize:CGSizeMake(115.0f, 107.0f) withName:[NSString stringWithFormat:@"%@%d",PP_BUFF_ANIMATION_NODE_NAME,PPBuffTypeRattanTwine]];
                
                ballCombo.PPBallSkillStatus =[NSNumber numberWithInt:PPBuffTypeRattanTwine];
                [self.ballEnemy addChild:buffShowNode];
                
                [buffShowNode runAction:actionRep completion:^{
                    
                    
                }];
                
                
                PPBuff *buffId1 = [[PPBuff alloc] init];
                buffId1.continueRound = 2;
                buffId1.buffId =[NSString stringWithFormat:@"%d",PPBuffTypeRattanTwineEffect];
                [self.battleBuffArray addObject:buffId1];
                
                self.ballEnemy.PPBallSkillStatus = [NSNumber numberWithInt:PPBuffTypeRattanTwineEffect];
                
                [self setComboBallSkillStatusOrigin];
                
            }
            
              [ballCombo startComboAnimation:CGVectorMake(self.ballEnemy.position.x-ballCombo.position.x,self.ballEnemy.position.y-ballCombo.position.y)];
            
            enemyCombos++;
            [self.playerAndEnemySide startAttackAnimation:NO];
            [self.playerAndEnemySide setComboLabelText:petCombos withEnemy:enemyCombos];
            [self dealPixieBallContactComboBall:contact andPetBall:self.ballEnemy];
            [self addComboValueChangeCombos:enemyCombos position:self.ballEnemy.position];
            return;
        }
    } else return;
}

// 碰撞事件结束监测
- (void)didEndContact:(SKPhysicsContact *)contact{
    
    BOOL needPlayerRun = NO;
    BOOL needPlayerStep = NO;
    BOOL needEnemyRun = NO;
    BOOL needEnemyStep = NO;
    
    // 判断是否需要处理速度特效
    if((contact.bodyA == self.ballPlayer.physicsBody || contact.bodyB == self.ballPlayer.physicsBody))
        //如果我方人物球撞击到物体
    {
        if ((contact.bodyA == self.ballEnemy.physicsBody || contact.bodyB == self.ballEnemy.physicsBody))
        {
            if (currentPhysicsAttack == 1) needPlayerRun = YES;
            if (currentPhysicsAttack == 2) needEnemyRun = YES;
        } else needPlayerStep = YES;
    } else if ((contact.bodyA == self.ballEnemy.physicsBody || contact.bodyB == self.ballEnemy.physicsBody))
        //如果敌方人物球撞击到物体
    {
        if ((contact.bodyA == self.ballPlayer.physicsBody || contact.bodyB == self.ballPlayer.physicsBody))
        {
            if (currentPhysicsAttack == 1) needPlayerRun = YES;
            if (currentPhysicsAttack == 2) needEnemyRun = YES;
        } else needEnemyStep = YES;
    }
    
    if (needPlayerStep) {
        [self.ballPlayer startPixieAccelerateAnimation:self.ballPlayer.physicsBody.velocity andType:@"step"];
        return;
    }
    if (needPlayerRun) {
        [self.ballPlayer startPixieAccelerateAnimation:self.ballPlayer.physicsBody.velocity andType:@"run"];
        self.ballPlayer.physicsBody.velocity = CGVectorMake(self.ballPlayer.physicsBody.velocity.dx * kVelocityAddition,
                                                            self.ballPlayer.physicsBody.velocity.dy * kVelocityAddition);
        return;
    }
    if (needEnemyStep) {
        [self.ballEnemy startPixieAccelerateAnimation:self.ballEnemy.physicsBody.velocity andType:@"step"];
        return;
    }
    if (needEnemyRun) {
        [self.ballEnemy startPixieAccelerateAnimation:self.ballPlayer.physicsBody.velocity andType:@"run"];
        self.ballEnemy.physicsBody.velocity = CGVectorMake(self.ballEnemy.physicsBody.velocity.dx * kVelocityAddition,
                                                           self.ballEnemy.physicsBody.velocity.dy * kVelocityAddition);
        return;
    }
}

#pragma mark SKScene

-(void)didMoveToView:(SKView *)view
{
    [(PPFightingMainView *)self.view fullScreenForBattleScene];
    [self setPlayerSideRoundRunState];
    [self performSelectorOnMainThread:@selector(roundRotateBegin) withObject:nil afterDelay:1.0f];
}

-(void)willMoveFromView:(SKView *)view
{
}

-(void)update:(NSTimeInterval)currentTime
{
    frameFlag++;
    frameFlag %= 30;
}

-(void)didSimulatePhysics
{
    if (frameFlag == 15) [self checkingBallsMove];
}


#pragma mark UIResponder delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_isBallRolling == YES) return;
    if (touches.count > 1  || _isBallRolling) return;
    
    if (spriteArrow != nil) {
        [spriteArrow removeFromParent];
        spriteArrow = nil;
    }
    
    spriteArrow = [[SKSpriteNode alloc] initWithImageNamed:@"table_arrow"];
    spriteArrow.size = CGSizeMake(spriteArrow.size.width/2.0f, spriteArrow.size.height/2.0f);
    spriteArrow.xScale = 0.2;
    spriteArrow.yScale = 0.2;
    if (isTouchPetBall) {
        spriteArrow.hidden=YES;
    }
    spriteArrow.position = self.ballPlayer.position;
    [self addChild:spriteArrow];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    //    SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
    origtinTouchPoint = location;
    
    SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:PP_TOUCH_NODE_BALL_NAME]) {
        NSLog(@"touched pet begin");
        isTouchPetBall = YES;
    }
    
    if (isNotSkillRun || _isBallDragging) return;
    
    _isBallDragging = YES;
    
    _ballShadow = [PPBall ballWithPixie:self.pixiePlayer];
    _ballShadow.size = CGSizeMake(kBallSize, kBallSize);
    _ballShadow.position = location;
    _ballShadow.alpha = 0.5f;
    _ballShadow.physicsBody = nil;
    [self addChild:_ballShadow];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1) return;
    if (isNotSkillRun) return;
    
    if (_isBallDragging && !_isBallRolling) {
        
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        
        if (touchedNode == petSkillBar) {
            [self removeSkillBar];
            return;
        }
        
        if(distanceBetweenPoints(location, origtinTouchPoint) > 3)
        {
            spriteArrow.hidden = NO;
        } else {
            if (isTouchPetBall) {
                spriteArrow.hidden = YES;
            }
        }
        
        _ballShadow.position = location;
        CGVector angleVector = CGVectorMake((origtinTouchPoint.x - _ballShadow.position.x) * kBounceReduce,
                                            (origtinTouchPoint.y - _ballShadow.position.y) * kBounceReduce);
        
        if (!spriteArrow) {
            spriteArrow = [[SKSpriteNode alloc] initWithImageNamed:@"table_arrow"];
            spriteArrow.size = CGSizeMake(spriteArrow.size.width/2.0f, spriteArrow.size.height/2.0f);
            spriteArrow.xScale = 0.2;
            spriteArrow.yScale = 0.2;
            if (isTouchPetBall) {
                spriteArrow.hidden=YES;
            }
            spriteArrow.position = self.ballPlayer.position;
            [self addChild:spriteArrow];
        }
        spriteArrow.zRotation = vector2angel(angleVector);
        
        spriteArrow.hidden = NO;
        double scaleFactor = sqrt(angleVector.dx * angleVector.dx + angleVector.dy * angleVector.dy );
        float scaleChange = scaleFactor/20;
        if (scaleChange >=2) {
            scaleChange = 2;
        }
        
        spriteArrow.xScale = scaleChange;
        spriteArrow.yScale = scaleChange;
        NSLog(@"scaleFactor=%f",scaleFactor);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1) return;
    //    UITouch * touch = [touches anyObject];
    //    CGPoint location = [touch locationInNode:self];
    //    SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if (isShowingSkillBar) {
        [self removeSkillBar];
        return;
    }
    
    if (isNotSkillRun) {
        return;
    }
    
    if (_isBallDragging && !_isBallRolling) {
        
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode * touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        
        if (touchedNode == petSkillBar) {
            [self removeSkillBar];
            return;
        }
        
        NSLog(@"direct=%f",distanceBetweenPoints(location, origtinTouchPoint));
        
        if ([touchedNode.name isEqualToString:PP_TOUCH_NODE_BALL_NAME]
            && isTouchPetBall
            && distanceBetweenPoints(location, origtinTouchPoint) < 18)
        {
            NSLog(@"touched pet end");
            NSLog(@"touchedNode=%@ name =%@",touchedNode,touchedNode.name);
            [_ballShadow removeFromParent];
            [self addPetSkillBar];
            
        } else {
            
            [self changeBallStatus:PP_PET_PLAYER_SIDE_NODE_NAME];
            
            _isBallDragging = NO;
            [self.ballPlayer.physicsBody applyImpulse:
             CGVectorMake((origtinTouchPoint.x - _ballShadow.position.x) * kBounceReduce,
                          (origtinTouchPoint.y - _ballShadow.position.y) * kBounceReduce)];
            [self.ballPlayer startPixieAccelerateAnimation:
             CGVectorMake((origtinTouchPoint.x - _ballShadow.position.x) * kBounceReduce,
                          (origtinTouchPoint.y - _ballShadow.position.y) * kBounceReduce) andType:@"step"];
            currentPhysicsAttack = 1;
            //        _ballShadow.position = self.ballPlayer.position;
            
            [self setPlayerSideRoundRunState];
            if (_ballShadow) {
                [_ballShadow removeFromParent];
                _ballShadow = nil;
            }
            
            [self addBallMoveAnimation:self.ballPlayer.position];
            _isBallRolling = YES;
        }
    }
    
    if (spriteArrow) {
        spriteArrow.hidden = YES;
        [spriteArrow removeFromParent];
        spriteArrow = nil;
    }
}

@end
