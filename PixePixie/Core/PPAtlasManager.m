
#import "PPAtlasManager.h"

@implementation PPAtlasManager

#pragma mark demo v2.0

+(SKTextureAtlas *)ball_elements
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ball_elements"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)ball_table
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ball_table"];
    });
    return tAtlas;
}


#pragma mark demo v3.0

+(SKTextureAtlas *)battle_fight_effect
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"battle_fight_effect"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)battle_fight_missile
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"battle_fight_missile"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)battle_fight_skill
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"battle_fight_skill"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)battle_table_buff
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"battle_table_buff"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)battle_table_ball
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"battle_table_ball"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)pixie_battle_action
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"pixie_battle_action"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)ui_number
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ui_number"];
    });
    return tAtlas;
}

#pragma mark custom

+(SKSpriteNode *)createSpriteImageName:(NSString *)imageName withPos:(CGPoint)pos
                              withSize:(CGSize)size withName:(NSString *)nodeName
{
    SKSpriteNode *spriteTmp = nil;
    if (imageName == nil) {
        spriteTmp = PPInstance(SKSpriteNode);
    } else {
        spriteTmp = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    }
    spriteTmp.name = nodeName;
    spriteTmp.position = pos;
    spriteTmp.name = nodeName;
    spriteTmp.size = size;
    return spriteTmp;
}

@end
