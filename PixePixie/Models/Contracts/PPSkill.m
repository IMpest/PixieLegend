#import "PPSkill.h"

@implementation PPSkill

@synthesize skillName;
@synthesize animateTextures;
@synthesize HPChangeValue;
@synthesize skillType;
@synthesize skillObject;
@synthesize skillstatus;
@synthesize skillcontinue;
@synthesize skillbtntexture;

-(NSString *)getIconImageName
{
    return [NSString stringWithFormat:@"%02ld_%@", (long)self.skillId, kSkillName[self.skillId]];
}

+(NSString *)getIconImageNameBySkillId:(int)skillID
{
    return [NSString stringWithFormat:@"%02ld_%@", (long)skillID, kSkillName[skillID]];
}

+(PPSkill *)skillWithId:(int)skillID AndLevel:(int)skillLevel
{
    NSDictionary *skillInfo = [[PPLocalData getInstance].allSkillsInfo objectForKey:[NSString stringWithFormat:@"%02d",skillID]];
//    NSLog(@"skillInfo = %@ allinfo = %@",skillInfo,[PPLocalData getInstance].allSkillsInfo);

    PPSkill * tSkill = PPInstance(PPSkill);
    tSkill.skillId = skillID;
    
    tSkill.skillName = kSkillName[skillID];
    tSkill.skillLevel = skillLevel;
    tSkill.skillName = [skillInfo objectForKey:@"skillname"];
    tSkill.skillObject = [[skillInfo objectForKey:@"skillobject"] intValue];
    tSkill.skillType = [[skillInfo objectForKey:@"skilltype"] intValue];
    tSkill.skillstatus = [[skillInfo objectForKey:@"skillstatus"] intValue];
    tSkill.skillCD = [[skillInfo objectForKey:@"skillcdrounds"] intValue];
    tSkill.skillcontinue = [[skillInfo objectForKey:@"skillcontinue"] intValue];
    tSkill.skillbtntexture = [skillInfo objectForKey:@"skillbtntexture"];
    return tSkill;
}

@end
