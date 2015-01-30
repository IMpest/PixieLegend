#import "PPSkill.h"

@implementation PPSkill

@synthesize skillName;
@synthesize animateTextures;
@synthesize HPChangeValue;
@synthesize skillType;
@synthesize skillObject;

-(NSString *)getSkillImageName
{
    return [NSString stringWithFormat:@"%02d_%@", self.skillId, self.skillName];
}

+(PPSkill *)skillWithName:(NSString *)skillName AndLevel:(int)skillLevel
{
    for (int i = 1; i <= kSkillCountTotal; i++) {
        if ([skillName isEqualToString:kSkillName[i]]) {
            return [PPSkill skillWithId:i AndLevel:skillLevel];
        }
    }
    return nil;
}

+(PPSkill *)skillWithId:(int)skillID AndLevel:(int)skillLevel
{
    PPSkill * tSkill = [[PPSkill alloc] init];
    tSkill.skillLevel = skillLevel;
    
    return nil;
}

@end
