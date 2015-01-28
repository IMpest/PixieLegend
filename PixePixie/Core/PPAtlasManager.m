
#import "PPAtlasManager.h"

@implementation PPAtlasManager


#pragma mark demo v2.0

+(SKTextureAtlas *)ball_action
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"pixie_action"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)ball_buff
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ball_buff"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)ball_elements
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ball_elements"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)ball_magic
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ball_magic"];
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

+(SKTextureAtlas *)skill_buff
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"skill_buff"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)skill_icon
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"skill_icon"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)ui_fighting
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ui_fighting"];
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

+(SKTextureAtlas *)ui_talent
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"ui_talent"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)pixie_info
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"pixie_info"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)pixie_battle_effect
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"pixie_battle_effect"];
    });
    return tAtlas;
}

+(SKTextureAtlas *)pixie_battle_skill
{
    __strong static SKTextureAtlas * tAtlas = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tAtlas = [SKTextureAtlas atlasNamed:@"pixie_battle_skill"];
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

#pragma mark custom

+(SKSpriteNode *)createSpriteImageName:(NSString *)imageName withPos:(CGPoint)pos
                              withSize:(CGSize)size withName:(NSString *)nodeName
{
    SKSpriteNode * spriteTmp = nil;
    if (imageName == nil) {
        spriteTmp = [[SKSpriteNode alloc] init];
    } else {
        spriteTmp = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    }
    spriteTmp.name =nodeName;
    spriteTmp.position = pos;
    spriteTmp.name = nodeName;
    spriteTmp.size = size;
    return spriteTmp;
}

@end
