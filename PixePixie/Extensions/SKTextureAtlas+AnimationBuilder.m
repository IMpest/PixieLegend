
#import "SKTextureAtlas+AnimationBuilder.h"

@implementation SKTextureAtlas (AnimationBuilder)

-(SKAction *)getAnimation:(NSString *)name
{
    NSString * plistName = [[NSBundle mainBundle] pathForResource:@"FrameCount" ofType:@"plist"];
    NSDictionary * plistDic = [[NSDictionary alloc] initWithContentsOfFile:plistName];
    NSNumber * frameCount = [plistDic objectForKey:name];
    
    NSMutableArray * textureArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [frameCount intValue]; i++)
    {
        SKTexture * textureCombo = [self textureNamed:[NSString stringWithFormat:@"%@_%04d.png",name,i]];
        [textureArray addObject:textureCombo];
    }
    return [SKAction animateWithTextures:textureArray timePerFrame:kFrameInterval];
}

-(SKAction *)getAnimationContrary:(NSString *)name
{
    NSString * plistName = [[NSBundle mainBundle] pathForResource:@"FrameCount" ofType:@"plist"];
    NSDictionary * plistDic = [[NSDictionary alloc] initWithContentsOfFile:plistName];
    NSNumber * frameCount = [plistDic objectForKey:name];
    
    NSMutableArray * textureArray = [[NSMutableArray alloc] init];
    for (int i = [frameCount intValue]-1; i >= 0; i--)
    {
        SKTexture * textureCombo = [self textureNamed:[NSString stringWithFormat:@"%@_%04d.png",name,i]];
        [textureArray addObject:textureCombo];
    }
    return [SKAction animateWithTextures:textureArray timePerFrame:kFrameInterval];
}

@end