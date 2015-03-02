

@interface PPBallBattleSkillInfo : NSObject

@property(nonatomic,assign) int petHitRecoverHP;
@property(nonatomic,assign) int enemyPoisoningHP;
@property(nonatomic,assign) int rattanTwineState;
@property(nonatomic,assign) float nightJudgeValue;
-(void)resetBattleSkillInfo;//重置所有战斗信息
-(void)resetCurrentTemporarySkillInfo;//重置临时性技能信息。例如黑夜审判。
-(void)resetCurrentContinueSkillInfo;//重置持续性技能信息。

@end
