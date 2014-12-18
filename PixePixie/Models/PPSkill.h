

static const int kSkillCountMax = 10;               // 每个宠物拥有技能个数

// 技能类型定义
typedef NS_ENUM(NSInteger, PPSkillUniversalType)
{
    PPSkillTypePhysicalAttack = 0,     // 物理攻击
    PPSkillTypeBallAttack,             // 弹球攻击
    PPSkillTypeSubtractBlood,          // 耗血技能
    PPSkillTypeAppendBlood,            // 补血技能
    PPSkillTypeSubtractDefense,        // 削减对方防御
    PPSkillTypeAppendDefense,          // 增加本体防御
};

// 技能对应英文名（可用于图片）
static NSString * kSkillEnglishName[kElementTypeMax+1][kSkillCountMax+1] = {
    {@"",@"",@"",@"",@"",@"",@"",@""},
    {@"",@"",@"",@"",@"",@"",@"",@""},
    {@"grow",@"huge",@"root",@"",@"",@"",@"",@""},
    {@"",@"",@"",@"",@"",@"",@"",@""},
    {@"arrow",@"blade",@"burn",@"dance",@"purgatory",@"shield",@"smoke",@"spout"}
};

@interface PPSkill : NSObject

@property (nonatomic, retain) NSString * skillName;
@property (nonatomic, retain) NSMutableArray * animateTextures;
@property (nonatomic, assign) CGFloat HPChangeValue;

@property (nonatomic, assign) int skillType;    // 0:被动 1:主动
@property (nonatomic, assign) int skillLevel;   // 技能等级
@property (nonatomic, assign) int skillCD;      // 技能固有CD
@property (nonatomic, assign) int currentCD;    // 技能当前剩余CD


// 旧版逻辑
@property (nonatomic, assign) int skillObject;  // 0:作用于自身 1:作用于对方
@property (nonatomic, assign) CGFloat MPChangeValue;

@end
