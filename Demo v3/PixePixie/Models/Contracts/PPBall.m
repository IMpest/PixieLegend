
#import "PPBall.h"
#import "PPAtlasManager.h"
#import "ConstantData.h"
#import "Configuration.h"

@class PPPixie;
@class PPBuff;
@class PPBasicScene;

@interface PPBall ()
@property (nonatomic) SKTexture * defaultTexture;
@end

@implementation PPBall
@synthesize
sustainRounds, pixie, ballElementType, pixieEnemy, ballStatus, ballBuffs,
comboBallTexture, comboBallSprite, plantrootAnimationNode;

#pragma mark Factory Method

// 创建玩家宠物的球
+(PPBall *)ballWithPixie:(PPPixie *)pixie
{
    if (pixie == nil) return nil;
//    PPBall * tBall = [PPBall spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 50.0f)];
    PPBall * tBall = PP_INSTANCE(PPBall);
    tBall.size = CGSizeMake(50.0f, 50.0f);
    
    SKTexture * comboBallBack = [[PPAtlasManager battle_table_ball] textureNamed:@"ball_all"];
    SKSpriteNode *nodeBack = [SKSpriteNode spriteNodeWithTexture:comboBallBack];
    nodeBack.zPosition = PPZ_FIGHT;
    nodeBack.size = CGSizeMake(50.0f, 50.0f);
//    [tBall insertChild:nodeBack atIndex:0];
    [tBall addChild:nodeBack];
    
    SKSpriteNode *touchBallNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 50.0)];
    touchBallNode.name = PP_TOUCH_NODE_BALL_NAME;
    touchBallNode.zPosition = PPZ_FIGHT_EFFECT;
    [tBall addChild:touchBallNode];
    
    
    SKSpriteNode *showSpriteNode = PP_INSTANCE(SKSpriteNode);
    showSpriteNode.size = CGSizeMake(50.0f, 50.0f);
    [showSpriteNode setPosition: CGPointMake(0.0f, 10.0f)];
    showSpriteNode.zPosition = PPZ_FIGHT_BUFF;
    [tBall addChild:showSpriteNode];
//    [tBall insertChild:showSpriteNode atIndex:1];
    
    [showSpriteNode runAction:[SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_stop",kElementTypeString[pixie.pixieElement]]]]];
    
    if (tBall){
        tBall.ballType = PPBallTypePlayer;
        tBall.ballElementType = pixie.pixieElement;
        tBall.size = CGSizeMake(kBallSizePixie, kBallSizePixie);
        [PPBall defaultBallPhysicsBody:tBall];
        tBall.pixie = pixie;
    }
    return tBall;
}

// 创建敌人宠物的球
+(PPBall *)ballWithPixieEnemy:(PPPixie *)pixieEnemy;
{
    
    if (pixieEnemy == nil) return nil;
//    NSString * imageName = [NSString stringWithFormat:@"%@%d_ball.png",
//                            kElementTypeString[pixieEnemy.pixieElement],pixieEnemy.pixieGeneration];
//    PPBall * tBall = [PPBall spriteNodeWithTexture:[SKTexture textureWithImageNamed:imageName]];
    PPBall * tBall = [PPBall spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 50.0f)];

    
    SKTexture *comboBallBack = [[PPAtlasManager battle_table_ball] textureNamed:@"ball_all"];
    SKSpriteNode *nodeBack= [SKSpriteNode spriteNodeWithTexture:comboBallBack];
    nodeBack.size = CGSizeMake(50.0f, 50.0f);
    [tBall addChild:nodeBack];
    
    
    SKSpriteNode *showSpriteNode = PP_INSTANCE(SKSpriteNode);
    showSpriteNode.size = CGSizeMake(50.0f, 50.0f);
    [showSpriteNode setPosition: CGPointMake(5.0f, 5.0f)];
    [tBall addChild:showSpriteNode];
    
    
    [showSpriteNode runAction:[SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_stop",kElementTypeString[pixieEnemy.pixieElement]]]]];
    NSLog(@"plantname = %@",[NSString stringWithFormat:@"%@3_stop",kElementTypeString[pixieEnemy.pixieElement]]);

    
    tBall.ballBuffs = PP_INSTANCE(NSMutableArray);
    
    if (tBall){
        tBall.ballType = PPBallTypeEnemy;
        tBall.ballElementType = pixieEnemy.pixieElement;
        tBall.size = CGSizeMake(kBallSizePixie, kBallSizePixie);
        [PPBall defaultBallPhysicsBody:tBall];
        tBall.pixieEnemy = pixieEnemy;
    }
    return tBall;
}

// 创建元素球
+(PPBall *)ballWithElement:(PPElementType)elementType{
    
    NSString * imageName = [NSString stringWithFormat:@"%@_ball.png", kElementTypeString[elementType]];
    SKTexture * tTexture = [SKTexture textureWithImageNamed:imageName];
    
    PPBall * tBall = [PPBall spriteNodeWithTexture:tTexture];
    
    if (tBall)
    {
        tBall.ballType = PPBallTypeElement;
        tBall.defaultTexture = tTexture;
        tBall.name = [NSString stringWithFormat:@"ball_%@", kElementTypeString[elementType]];
        tBall.ballElementType = elementType;
        tBall.size = CGSizeMake(kBallSize, kBallSize);
        [PPBall defaultBallPhysicsBody:tBall];
        tBall.pixie = nil;
        
    }
    
    
    SKLabelNode * roundsLabel = PP_INSTANCE(SKLabelNode);
    roundsLabel.name = @"roundsLabel";
    roundsLabel.fontColor = [UIColor redColor];
    roundsLabel.position = CGPointMake(10, 10);
    [roundsLabel setText:@"0"];
    roundsLabel.fontSize = 15;
    
    
    [tBall addChild:roundsLabel];
    return tBall;
    
}

// 创建连击球
+(PPBall *)ballWithCombo
{
    
//    NSString * imageName = @"ball_combo.png";
    NSString * imageName = @"ball_all.png";
    SKTexture * tTexture = [SKTexture textureWithImageNamed:imageName];
    PPBall * tBall = [PPBall spriteNodeWithTexture:tTexture];
    
    
    SKTexture *comboBallBack = [[PPAtlasManager battle_table_ball] textureNamed:@"ball_combo"];
    SKSpriteNode *nodeBack= [SKSpriteNode spriteNodeWithTexture:comboBallBack];
    nodeBack.zPosition = PPZ_FIGHT_EFFECT;
    nodeBack.size = CGSizeMake(30.0f, 30.0f);
    [tBall addChild:nodeBack];
    
    
    if (tBall)
    {
        tBall.ballType = PPBallTypeCombo;
        tBall.ballElementType = PPElementTypeNone;
        tBall.defaultTexture = tTexture;
        tBall.name = @"combo";
        tBall.size = CGSizeMake(kBallSize, kBallSize);
        [PPBall defaultBallPhysicsBody:tBall];
        tBall.pixie = nil;
    }
    
    return tBall;
    
}

// 设置元素球的持续回合
-(void)setRoundsLabel:(int)rounds
{
    SKLabelNode * roundsLabel = (SKLabelNode *)[self childNodeWithName:@"roundsLabel"];
    [roundsLabel setText:[NSString stringWithFormat:@"%d",rounds]];
}

// 改为默认皮肤
-(void)setToDefaultTexture
{
    [self runAction:[SKAction setTexture:_defaultTexture]];
}
#pragma mark buff manage

-(void)addBuffWithName:(NSString *)buffName andRoundNum:(int)continueRound
{
    
    PPBuff * buff = PP_INSTANCE(PPBuff);
    buff.buffName = buffName;
    buff.continueRound = continueRound;
    buff.buffId = @"2";
    
    [self.ballBuffs addObject:buff];
    
}
-(void)changeBuffRound
{
    for (int i = 0; i < [self.ballBuffs count]; i++) {
        PPBuff * buff = [self.ballBuffs objectAtIndex:i];
        buff.continueRound--;
        NSLog(@"continueRound = %d",buff.continueRound);
        if (buff.continueRound < 0) {
            [self removeBuff:buff];
        }
    }
}

-(void)removeBuff:(PPBuff *)buff
{
    switch ([buff.buffId intValue]) {
        case 2:
        {
            self.physicsBody.PPBallSkillStatus = 0;
            self.physicsBody.density = 1.0f;
            self.physicsBody.dynamic = YES;
//            [self startPlantrootAppearOrDisappear:NO];
//            [battleCurrentScene removeBuff:buff andSide:PP_ENEMY_SIDE_NODE_NAME];
        }
            break;
            
        default:
            break;
    }
    [self.ballBuffs removeObject:buff];
}

#pragma mark Animation  球体各种动画

-(void)startElementBallHitAnimation:(NSMutableArray *)ballArray isNeedRemove:(BOOL)isNeed andScene:(PPBasicScene *)battleScene
{
    
    SKAction * actionHit = [[PPAtlasManager ball_elements] getAnimation:[NSString stringWithFormat:@"%@_hit",kElementTypeString[self.ballElementType]]];
    
    if (self.comboBallSprite != nil) {
        [self.comboBallSprite removeFromParent];
        self.comboBallSprite = nil;
    }
    
    self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
    if (isNeed) {
        [self.comboBallSprite setPosition:self.position];
        [battleScene addChild:self.comboBallSprite];
        [self removeFromParent];
        [ballArray removeObject:self];
    } else {
        [self addChild:self.comboBallSprite];
    }
    
    [self.comboBallSprite runAction:actionHit
                         completion:^{
                             if (isNeed) {
                                 [self.comboBallSprite removeFromParent];
                             } else {
                                 [self startAuraAnimation];
                             }
                         }];
}

-(void)startRemoveAnimation:(NSMutableArray *)ballArray  andScene:(PPBasicScene *)battleScene
{
    NSMutableArray *textureArray = PP_INSTANCE(NSMutableArray);
    for (int i = 23; i >= 0; i--) {
        
        SKTexture * textureCombo = [[PPAtlasManager ball_table] textureNamed:[NSString stringWithFormat:@"element_birth_%04d",i]];
        [textureArray addObject:textureCombo];
        
    }
    
    [ballArray removeObject:self];
    [self runAction:[SKAction animateWithTextures:textureArray timePerFrame:0.05]
         completion:^{
             [self removeFromParent];
         }];
}


-(void)startPixieAccelerateAnimation:(CGVector)velocity andType:(NSString *)pose
{
    // 速度过低则移除
    if (sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy ) < kBallAccelerateMin) {
        if (self.comboBallSprite != nil) {
            [self.comboBallSprite removeFromParent];
            self.comboBallSprite = nil;
        }
        return;
    };
    
    // 如果变撞击加速效果则移除当前效果
    if (self.comboBallSprite != nil && [pose isEqualToString:@"run"]){
            [self.comboBallSprite removeFromParent];
            self.comboBallSprite = nil;
    }
    
    // 如果特效不在则创建
    if (self.comboBallSprite == nil && ([pose isEqualToString:@"run"] || [pose isEqualToString:@"step"])) {
        self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
        self.comboBallSprite.size = CGSizeMake(100, 100);
        [self.comboBallSprite setPosition:CGPointMake(0, 0)];
        [self addChild:self.comboBallSprite];
//        NSString * tName = [NSString stringWithFormat:@"%@_%@", kElementTypeString[self.ballElementType], pose];
        NSString * tName = [NSString stringWithFormat:@"%@_%@", @"plant", pose];

        SKAction * tAction = [SKAction repeatActionForever:[[PPAtlasManager ball_elements] getAnimation:tName]];
        [self.comboBallSprite runAction:tAction];
    }
    
    // 调整方向
    if (self.comboBallSprite != nil){
        if (velocity.dx != 0.0f) {
            CGFloat rotation = atan(velocity.dy / velocity.dx);
            rotation = velocity.dx > 0 ? rotation : rotation + 3.14159;
            NSLog(@"rotation = %f", rotation);
            self.comboBallSprite.zRotation = rotation;
        }
    }
}

// 治疗动画
-(void)startPixieHealAnimation
{
    NSMutableArray *textureArray = PP_INSTANCE(NSMutableArray);
    for (int i = 0; i < 15; i++) {
        SKTexture * textureCombo = [[PPAtlasManager ball_table] textureNamed:[NSString stringWithFormat:@"pixie_heal_%04d",i]];
        [textureArray addObject:textureCombo];
    }
    self.comboBallTexture = textureArray;
    
    
    if (self.comboBallSprite != nil) {
        [self.comboBallSprite removeFromParent];
        self.comboBallSprite = nil;
    }
    
    self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
    [self addChild:self.comboBallSprite];
    
    [self.comboBallSprite runAction:[SKAction animateWithTextures:self.comboBallTexture timePerFrame:kFrameInterval]
                         completion:^{
                             [self.comboBallSprite removeFromParent];
                         }];
}

// 连击能量动画
-(void)startComboAnimation:(CGPoint)vectorValue
{
    if (self.comboBallSprite != nil) {
        [self.comboBallSprite removeFromParent];
        self.comboBallSprite = nil;
    }
    
    self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
    [self.comboBallSprite setPosition:CGPointMake(vectorValue.x/2.0f, vectorValue.y/2.0f)];
    [self addChild:self.comboBallSprite];
    
    [self.comboBallSprite runAction:[[PPAtlasManager battle_table_ball] getAnimation:@"ball_pixie_hit"]
                         completion:^{[self.comboBallSprite removeFromParent];}];
}


// 变身陷阱动画
//-(void)startMagicballAnimation
//{
//    if (self.comboBallSprite != nil) {
//        [self.comboBallSprite removeFromParent];
//        self.comboBallSprite = nil;
//    }
//    
//    self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
//    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
//    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
//    [self addChild:self.comboBallSprite];
//    
//    //    [self.comboBallSprite runAction:[[PPAtlasManager ball_magic] getAnimation:@"magic_ball"]
//    //                         completion:^{[self.comboBallSprite removeFromParent];}];
//    
//    [self runAction:[[PPAtlasManager ball_magic] getAnimation:@"magic_ball"]
//         completion:^{
//             self.size = CGSizeMake(1.0f, 1.0f);
//             [self.comboBallSprite removeFromParent];
//             [self addStatusBall:@"plant"];
//         }];
//}
//
//-(void)addStatusBall:(NSString *)type
//{
//    
//    if (self.comboBallSprite != nil) {
//        [self.comboBallSprite removeFromParent];
//        self.comboBallSprite = nil;
//    }
//    
//    self.comboBallSprite = [[SKSpriteNode alloc] initWithTexture:[[PPAtlasManager ball_magic] textureNamed:@"plant_root"]];
//    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
//    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
//    [self addChild:self.comboBallSprite];
//}

//// 创建被缠绕动画
//-(void)startPlantrootAppearOrDisappear:(BOOL)isAppear
//{
//    
//    if (isAppear) {
// 
//        if (self.plantrootAnimationNode != nil)
//        {
//            [self.plantrootAnimationNode removeFromParent];
//            self.plantrootAnimationNode = nil;
//        }
//        
//        self.plantrootAnimationNode = PP_INSTANCE(SKSpriteNode);
//        self.plantrootAnimationNode.size = CGSizeMake(50.0f, 50.0f);
//        [self.plantrootAnimationNode setPosition:CGPointMake(0.0f, 0.0f)];
//        
//        [self addChild:self.plantrootAnimationNode];
//        
//        SKAction * action = [[PPAtlasManager ball_buff] getAnimation:@"plant_root_appear"];
//        [self.plantrootAnimationNode runAction:action
//                             completion:^{
//                                 
//                            }];
//        
//    } else {
//        SKAction * action = [[PPAtlasManager ball_buff] getAnimation:@"plant_root_disappear"];
//        [self.plantrootAnimationNode runAction:action
//                             completion:^{
//                                 [self.plantrootAnimationNode removeFromParent];
//                                 self.plantrootAnimationNode = nil;
//                             }];
//    }
//}

//-(void)startElementBirthAnimation
//{
//    if (self.comboBallSprite != nil) {
//        [self.comboBallSprite removeFromParent];
//        self.comboBallSprite = nil;
//    }
//    
//    self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
//    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
//    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
//    [self addChild:self.comboBallSprite];
//    
//    
//    [self.comboBallSprite runAction:[[PPAtlasManager ball_table] getAnimation:@"element_birth"]
//                         completion:^{
//                             [self.comboBallSprite removeFromParent];
//                             [self startAuraAnimation];
//                         }];
//}

-(void)startAuraAnimation
{
    
    if (self.comboBallSprite != nil) {
        [self.comboBallSprite removeFromParent];
        self.comboBallSprite = nil;
    }
    
    self.comboBallSprite = PP_INSTANCE(SKSpriteNode);
    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
    [self addChild:self.comboBallSprite];
    
    
    SKSpriteNode *textureNode = [SKSpriteNode spriteNodeWithTexture:self.texture];
    textureNode.size = CGSizeMake(kBallSize, kBallSize);
    [self.comboBallSprite addChild:textureNode];
    
    SKAction *actionAura = [[PPAtlasManager ball_elements] getAnimation:[NSString stringWithFormat:@"%@_aura",kElementTypeString[self.ballElementType]]];
    SKAction *actionAuraContray = [[PPAtlasManager ball_elements] getAnimationContrary:[NSString stringWithFormat:@"%@_aura",kElementTypeString[self.ballElementType]]];
    NSArray *arrayAnimation = [NSArray arrayWithObjects:actionAura,actionAuraContray, nil];
    SKAction *actionSqueues = [SKAction sequence:arrayAnimation];
    
    [self.comboBallSprite runAction:[SKAction repeatActionForever:actionSqueues]
                         completion:^{
                             [self.comboBallSprite removeFromParent];
                         }];
}

// 默认的球的物理属性
+(void)defaultBallPhysicsBody:(PPBall *)ball{
    
    if (ball.ballType == PPBallTypePlayer || ball.ballType == PPBallTypeEnemy){
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kBallSizePixie / 2];
    } else {
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kBallSize / 2];
    }
    
    ball.physicsBody.linearDamping = kBallLinearDamping;    // 线阻尼系数
    ball.physicsBody.angularDamping = kBallAngularDamping;  // 角阻尼系数
    ball.physicsBody.friction = kBallFriction;              // 表面摩擦力
    ball.physicsBody.restitution = kBallRestitution;        // 弹性恢复系数
    
    ball.physicsBody.dynamic = YES;                         // 说明物体是动态的
    ball.physicsBody.usesPreciseCollisionDetection = YES;   // 使用快速运动检测碰撞
}

-(void)startActiveStatus
{
    if (spriteNodeActive) {
        [spriteNodeActive removeFromParent];
        spriteNodeActive = nil;
    }
    
    spriteNodeActive = PP_INSTANCE(SKSpriteNode);
    spriteNodeActive.size = CGSizeMake(50.0f, 50.0f);
    [spriteNodeActive setPosition:CGPointMake(0.0f, 0.0f)];
    spriteNodeActive.zPosition = PPZ_FIGHT_BG;
    [self addChild:spriteNodeActive];
    
//    [self insertChild:spriteNodeActive atIndex:0];
    
    SKAction * activieAct = [SKAction repeatActionForever:[[PPAtlasManager battle_table_ball] getAnimation:@"ball_pixie_active"]];
    
    [spriteNodeActive runAction:activieAct];
}

-(void)closeActiveStatus
{
    if (spriteNodeActive) {
        [spriteNodeActive removeFromParent];
        spriteNodeActive = nil;
    }
}

@end
