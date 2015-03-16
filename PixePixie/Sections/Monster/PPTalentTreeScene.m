
#import "PPTalentTreeScene.h"

@implementation PPTalentTreeScene


-(id)initWithPixie:(PPPixie *)pixie
{
    if (self = [super init]) {
        
        [self addTitle:@"天赋树" andBackButton:360.0f];
        
        SKSpriteNode * backTree = [[SKSpriteNode alloc] initWithImageNamed:@"bg_tree"];
        backTree.position = CGPointMake(160, 180);
        backTree.size = CGSizeMake(305, 265);
        [self addChild:backTree];
        
        for (int i = 1; i < 9; i++) {
            PPSpriteButton * monstersButton = [PPSpriteButton buttonWithImageNamed:[PPSkill getIconImageNameBySkillId:i]];
            monstersButton.position = CGPointMake(60 * ((i-1) % 2) - 100, 60 * ( (i-1) / 2) - 85);
            monstersButton.size = CGSizeMake(40, 40);
            monstersButton.name = [NSString stringWithFormat:@"%d",i];
            [backTree addChild:monstersButton];
        }

    }
    return self;
}

-(void)backButtonClick:(NSString *)backName
{
    [self.view presentScene:previousScene];
}


//-(void)creatTreeWith:(PPElementType)elementType{
//    
//    SKSpriteNode * backTree = [[SKSpriteNode alloc] initWithTexture:[[PPAtlasManager ui_talent] textureNamed:[NSString stringWithFormat:@"%@_tree", kElementTypeString[elementType]]]];
//    backTree.position = CGPointMake(self.size.width/2.0f, self.size.height/2.0f);
//    backTree.size = CGSizeMake(290, 223*290/195);
//    [self addChild:backTree];
//    
//}
//
//-(void)monstersButtonClick:(NSString *)stringName
//{}

@end
