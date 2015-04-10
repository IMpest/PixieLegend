
@class PPValueShowNode;

@interface PPBodyModelNode : SKSpriteNode
{
    SKSpriteNode *headNode;
    SKSpriteNode *handNode;
    SKSpriteNode *bodyNode;
    SKSpriteNode *legNode;
    
    PPValueShowNode * bodyHPBar;
    PPValueShowNode * bodyMPBar;
}

-(void)initUnitBody:(NSString *)bodyId;

@end
