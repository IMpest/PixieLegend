
#import "PPBallBattleSkillInfo.h"

@implementation PPBallBattleSkillInfo

@synthesize petHitRecoverHP;
@synthesize enemyPoisoningHP;
@synthesize rattanTwineState;
@synthesize nightJudgeValue;
-(void)resetBattleSkillInfo
{
    self.enemyPoisoningHP = 0;
    self.petHitRecoverHP = 0;
    self.rattanTwineState = 0;
    self.nightJudgeValue = 0.0f;
    
}
@end
