
#import "PPMonsterInfoNode.h"

@implementation PPMonsterInfoNode

-(void)initMonsterInfo:(NSDictionary *)monsterInfo
{
    PPSpriteButton * monsterTexture = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"plant3_temp.png"]
                                                                andSize:CGSizeMake(180, 180)];
    monsterTexture.position = CGPointMake(0, 10);
    monsterTexture.name = @"pixie_plant3_battle0";
    [monsterTexture addTarget:self selector:@selector(monsterTextureClick:)
                   withObject:monsterTexture.name forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:monsterTexture];
    
    for (int i = 0; i < 3; i++) {
        PPSpriteButton * buffButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(30, 30)];
        buffButton.position = CGPointMake(130, i * 40 + 20);
        buffButton.name = [NSString stringWithFormat:@"%d",i];
        [buffButton setLabelWithText:@"状态" andFont:[UIFont systemFontOfSize:15] withColor:nil];
        [buffButton addTarget:self selector:@selector(buffButtonClick:)
                   withObject:buffButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:buffButton];
    }
    
//    PPSpriteButton * moodButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(30, 30)];
//    moodButton.position = CGPointMake(130, -85);
//    moodButton.name = @"心情";
//    [moodButton setLabelWithText:@"心情" andFont:[UIFont systemFontOfSize:15] withColor:nil];
//    [moodButton addTarget:self selector:@selector(moodButtonClick:)
//               withObject:moodButton.name forControlEvent:PPButtonControlEventTouchUpInside];
//    [self addChild:moodButton];
    
    PPSpriteButton * feedButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(30, 30)];
    feedButton.position = CGPointMake(130, -125);
    feedButton.name = @"喂食";
    [feedButton setLabelWithText:@"喂食" andFont:[UIFont systemFontOfSize:15] withColor:nil];
    [feedButton addTarget:self selector:@selector(feedButtonClick:) withObject:feedButton.name
          forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:feedButton];

}

-(void)feedButtonClick:(NSString *)stringName
{
}

-(void)hungryButtonClick:(NSString *)stringName
{
}

-(void)moodButtonClick:(NSString *)stringName
{
}

-(void)monsterTextureClick:(NSString *)stringName
{
}

-(void)buffButtonClick:(NSString *)stringName
{
}

@end
