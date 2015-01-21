

// 每个宠物的技能数（旧版参数）
static const int kSkillCountMax = 8;
// 技能对应英文名（旧版参数）
static NSString * kSkillEnglishName[kElementTypeMax+1][kSkillCountMax+1] =
{
    {@"",@"",@"",@"",@"",@"",@"",@""},
    {@"",@"",@"",@"",@"",@"",@"",@""},
    {@"grow",@"huge",@"root",@"",@"",@"",@"",@""},
    {@"",@"",@"",@"",@"",@"",@"",@""},
    {@"arrow",@"blade",@"burn",@"dance",@"purgatory",@"shield",@"smoke",@"spout"}
};

// 总共技能数
static const int kSkillCountTotal = 10;

// 技能名（与图片名对应）
static NSString * kSkillName[kSkillCountTotal+1] =
{
    @"NONE",
    
    @"devilrebirth",
    @"devilbreath",
    @"rattantwine",
    @"nightjudge",
    @"devilgrill",
    
    @"devilskin",
    @"devilanger",
    @"devilextinction"
};

// 技能id
typedef NS_ENUM(int, PPPetSkillId)
{
    kPPPetSkillNone = 0,
    kPPPetSkillDevilRebirth,        // 恶魔重生
    kPPPetSkillDevilBreath,         // 恶魔呼吸
    kPPPetSkillRattanTwine,         // 魔藤缠绕
    kPPPetSkillRattanTwineEffect,   // 魔藤缠绕状态效果
    kPPPetSkillNightJudge,          // 黑夜审判
    kPPPetSkillDevilGrill,          // 恶魔拷问
    kPPPetSkillDevilSkin,           // 恶魔之肤
    kPPPetSkillDevilAnger,          // 愤怒
    kPPPetSkillDevilExtinction      // 灭绝
};

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

@interface PPSkill : NSObject

@property (nonatomic, assign) NSInteger skillId;
@property (nonatomic, retain) NSString * skillName;
@property (nonatomic, retain) NSMutableArray * animateTextures;
@property (nonatomic, assign) CGFloat HPChangeValue;

@property (nonatomic, assign) int skillType;    // 0:被动 1:主动
@property (nonatomic, assign) int skillObject;  // 0:作用于自身 1:作用于对方
@property (nonatomic, assign) int skillLevel;   // 技能等级
@property (nonatomic, assign) int skillCD;      // 技能固有CD
@property (nonatomic, assign) int currentCD;    // 技能当前剩余CD

-(NSString *)getSkillPicName;
+(PPSkill *)skillWithId;
+(PPSkill *)skillWithName;

@end
