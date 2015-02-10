

@interface SKTextureAtlas (AnimationBuilder)
-(SKAction *)getAnimation:(NSString *)name;
-(SKAction *)getAnimationContrary:(NSString *)name;
@end

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


@interface PPAtlasManager : NSObject

// ==== v2.0 ====

+(SKTextureAtlas *)ball_elements;
+(SKTextureAtlas *)ball_table;

// ==== v3.0 ====
+(SKTextureAtlas *)battle_fight_missile;
+(SKTextureAtlas *)battle_fight_effect;
+(SKTextureAtlas *)battle_fight_skill;
+(SKTextureAtlas *)battle_table_ball;
+(SKTextureAtlas *)battle_table_buff;
+(SKTextureAtlas *)pixie_battle_action;
+(SKTextureAtlas *)ui_number;

// ==== custom ====
+(SKSpriteNode *)createSpriteImageName:(NSString *)imageName withPos:(CGPoint)pos
                              withSize:(CGSize)size withName:(NSString *)nodeName;

@end
