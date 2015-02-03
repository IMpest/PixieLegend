
// 总共技能数
static const int kSkillCountTotal = 8;

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

@interface PPSkill : NSObject

// 旧版参数
@property (nonatomic, retain) NSMutableArray * animateTextures;
@property (nonatomic, assign) CGFloat HPChangeValue;

// 基础参数
@property (nonatomic, assign) NSInteger skillId;
@property (nonatomic, retain) NSString * skillName;
@property (nonatomic, assign) int skillType;    // 0:被动 1:主动
@property (nonatomic, assign) int skillObject;  // 0:作用于自身 1:作用于对方
@property (nonatomic, assign) int skillLevel;   // 技能等级
@property (nonatomic, assign) int skillCD;      // 技能固有CD
@property (nonatomic, assign) int currentCD;    // 技能当前剩余CD

-(NSString *)getIconImageName;

+(PPSkill *)skillWithName:(NSString *)skillName AndLevel:(int)skillLevel;
+(PPSkill *)skillWithId:(int)skillID AndLevel:(int)skillLevel;

@end
