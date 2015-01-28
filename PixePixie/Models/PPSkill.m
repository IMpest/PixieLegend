#import "PPSkill.h"

@implementation PPSkill

@synthesize skillName;
@synthesize animateTextures;
@synthesize HPChangeValue;
@synthesize skillType;
@synthesize skillObject;

-(NSString *)getSkillPicName
{
    return [NSString stringWithFormat:@"%02d_%@", self.skillId, self.skillName];
}

+(PPSkill *)skillWithId
{
    return nil;
}

+(PPSkill *)skillWithName
{
    return nil;
}

@end
