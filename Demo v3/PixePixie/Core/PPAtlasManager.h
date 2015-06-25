
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
