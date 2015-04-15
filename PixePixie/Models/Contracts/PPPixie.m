#import "PPPixie.h"

@implementation PPPixie

@synthesize pixieName;
@synthesize pixieStatus;
@synthesize pixieIntimate;
@synthesize pixieGP;

@synthesize pixieLEVEL;     // 战斗等级
@synthesize pixieHPmax;     // 生命值上限 HealthPointMax
@synthesize pixieMPmax;     // 魔法值上限 ManaPointMax
@synthesize pixieAP;        // 攻击力 AttackPoint;
@synthesize pixieDP;        // 防御力 DefendPoint;
@synthesize pixieDEX;       // 闪避值 Dexterity
@synthesize pixieDEF;       // 格挡值 Defense

@synthesize currentHP;      // 当前生命值 HitPoint
@synthesize currentMP;      // 当前魔法值 ManaPoint
@synthesize currentAP;      // 当前攻击力 AttackPoint;
@synthesize currentDP;      // 当前防御力 DefendPoint;
@synthesize currentDEX;     // 当前闪避值 Dexterity
@synthesize currentDEF;     // 当前防御  Defense

@synthesize pixieElement;
@synthesize pixieGeneration;
@synthesize pixieSkills;
@synthesize pixieBuffs;
@synthesize pixieBall;

// 输出宠物数值
-(void)outputInfo
{
    NSLog(@"Pixie:%@\n %d\n %d\n %f\n %f\n", pixieName, pixieStatus, pixieLEVEL, pixieHPmax, pixieMPmax);
}

// 物理攻击伤害计算
-(CGFloat)countPhysicalDamageTo:(PPPixie *)targetPixie
{
    return 600;
}

// 技能伤害计算
-(CGFloat)countMagicalDamageTo:(PPPixie *)targetPixie
                     WithSkill:(PPSkill *)usingSkill
{
    return 350;
}

// 获得宠物名字
-(NSString *)getTextureName
{
    return [NSString stringWithFormat:@"%@%d", kElementTypeString[self.pixieElement], self.pixieGeneration];
}

// 手动创建宠物
+(PPPixie *)pixieWithElement:(PPElementType)element Generation:(int)generation HPmax:(CGFloat)hpmax MPmax:(CGFloat)mpmax;
{
    PPPixie *tPixie = [[PPPixie alloc] init];
    
    tPixie.pixieName = @"Name";
    tPixie.pixieHPmax = 1000;
    tPixie.pixieMPmax = 1000;
    tPixie.currentHP = 100;
    tPixie.currentMP = 100;
    
    tPixie.pixieAP = 10;
    tPixie.pixieDP = 1;
    tPixie.pixieDEX = 10;
    tPixie.pixieDEF = 10;
    
    tPixie.pixieElement = element;
    tPixie.pixieGeneration = generation;
    
    return tPixie;
}

// 自动创建宠物
+(PPPixie *)pixieWithData:(NSDictionary *)pixieDict
{
    PPPixie *tPixie = [[PPPixie alloc] init];
    
    tPixie.pixieName = [pixieDict objectForKey:@"name"];
    
    tPixie.pixieGeneration = [[pixieDict objectForKey:@"generation"] intValue];
    tPixie.pixieLEVEL = [[pixieDict objectForKey:@"level"] intValue];
    tPixie.pixieHPmax = [[pixieDict objectForKey:@"hpmax"] intValue];
    tPixie.pixieMPmax = [[pixieDict objectForKey:@"mpmax"] intValue];
    tPixie.currentHP = tPixie.pixieHPmax;
    tPixie.currentMP = tPixie.pixieMPmax;
    
    tPixie.pixieAP = [[pixieDict objectForKey:@"ap"] intValue];
    tPixie.pixieDP = [[pixieDict objectForKey:@"dp"] intValue];
    tPixie.pixieDEX = [[pixieDict objectForKey:@"dex"] intValue];
    tPixie.pixieDEF = [[pixieDict objectForKey:@"def"] intValue];
    
    tPixie.pixieElement = [[pixieDict objectForKey:@"element"] intValue];
    tPixie.pixieSkills = [NSArray arrayWithArray:[pixieDict objectForKey:@"skills"]];
    tPixie.pixieBuffs = [[NSMutableArray alloc] initWithObjects:@"buff1", @"buff2", @"buff3", nil];
    tPixie.pixieBall = [PPBall ballWithPixie:tPixie];
    
    // 创建宠物技能列表
    NSMutableArray *tSkillList = [NSMutableArray array];
    for (NSDictionary * tSkillInfo in [NSArray arrayWithArray:[pixieDict objectForKey:@"skill_list"]])
    {
        id skillId = [tSkillInfo objectForKey:@"id"];
        id skillLevel = [tSkillInfo objectForKey:@"level"];
        if (skillId == nil || skillLevel == nil) break;
        PPSkill * tSkill = [PPSkill skillWithId:[skillId intValue] AndLevel:[skillLevel intValue]];
        if (tSkill != nil) [tSkillList addObject:tSkill];
    }
    tPixie.skillList = tSkillList;
    
    return tPixie;
}

-(void)setPetSkillList:(NSDictionary *)petDict;
{
    NSLog(@"petDict=%@",petDict);
    
   
    
    
    // 创建宠物技能列表
    NSMutableArray *tSkillList = [[NSMutableArray alloc] init];
    for (NSDictionary * tSkillInfo in [petDict objectForKey:@"skill_list"])
    {
        id skillId = [tSkillInfo objectForKey:@"id"];
        id skillLevel = [tSkillInfo objectForKey:@"level"];
        if (skillId == nil || skillLevel == nil) break;
        
        NSLog(@"");
        
        PPSkill * tSkill = [PPSkill skillWithId:[skillId intValue] AndLevel:[skillLevel intValue]];
        
        if (tSkill != nil)
            [tSkillList addObject:tSkill];
    }
    self.skillList = tSkillList;
    
}

@end
