
#import "PPSkillNode.h"
#import "PPPixie.h"
#import "PPBuff.h"

@interface PPBallBattleScene : PPBasicScene < SkillShowEndDelegate >
{
    int roundIndex;
    int roundActionNum;
    BOOL roundRuning;
    
    int enemyCombos;    // 怪物连击数
    int petCombos;      // 宠物连击数
    
    int petAssimSameEleNum;     // 宠物吸收己方元素球个数
    int petAssimDiffEleNum;     // 宠物吸收敌方方元素球个数
    int enemyAssimSameEleNum;   // 怪物吸收怪物方元素球个数
    int enemyAssimDiffEleNum;   // 怪物吸收宠物方元素球个数
    int currentPhysicsAttack;   // 当前攻击方的标记 1：玩家攻击 2：敌方攻击
    BOOL isHPZero;
    CGPoint origtinTouchPoint;
    CGFloat interCoefficient;   // 宠物与对手之间属性克制关系
    
    int petCombosCount[5];
    int enemyCombosCount[5];
    
@public
    int currentEnemyIndex;
    BOOL isTutorial;

}
@property (nonatomic,retain)NSArray *enmeysArray;

/**
 * @brief 初始化场景
 * @param pixieA 我方战斗宠物
 * @param pixieB 敌方战斗宠物
 * @param sceneType 战斗场景类型
 */
-(id)initWithSize:(CGSize)size
      PixiePlayer:(PPPixie *)pixieA
       PixieEnemy:(PPPixie *)pixieB
     andSceneType:(PPElementType)sceneType andIndex:(int)enemyIndex withTutorial:(BOOL)isTutorialValue;
/**
 * @brief 设置本次战斗怪物。
 */
-(void)setEnemyAtIndex:(int)index;

//-(void)physicsAttackAnimationEnd:(NSString *)stringSide;

@end
