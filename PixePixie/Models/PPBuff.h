
//buff名称
//static NSString * kBuffNameList[10] =
//{
//    @"none",
//    @"fire_burn",  // buffid  1为灼烧
//    @"plant_root", // buffid  2为缠绕
//    @"stone"
//};


// 技能Buff标记常量组
typedef NS_ENUM(int, PPPetSkillBuffFlag)
{
    kPPPetSkillNone = 0,
    kPPPetSkillDevilRebirth,        // 恶魔重生
    kPPPetSkillDevilBreath,         // 恶魔呼吸
    kPPPetSkillRattanTwine,         // 魔藤缠绕
    kPPPetSkillRattanTwineEffect,   // 魔藤缠绕被缠绕状态效果
    kPPPetSkillNightJudge,          // 黑夜审判
};

@interface PPBuff : NSObject

@property (nonatomic, assign) BOOL isOverRole;   // 是否覆盖角色（涉及图层问题）
@property (nonatomic, assign) BOOL isBallBuff;   // 是否是球上的Buff

@property (nonatomic, retain) NSString * buffName;   // buff名称
@property (nonatomic, retain) NSString * buffId;     // buff的id标识
@property (nonatomic, retain) NSString * buffEffect; // 特效名称

@property (nonatomic, assign) int continueRound;     // 持续回合

@property (nonatomic, assign) NSInteger cdRoundsAttAdd;  // 伤害加成回合数
@property (nonatomic, assign) NSInteger cdRoundsDefAdd;  // 防御加成回合数
@property (nonatomic, assign) CGFloat attackAddition;    // 伤害加成
@property (nonatomic, assign) CGFloat defenseAddition;   // 防御加成

@end
