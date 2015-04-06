//
//  PPBodyModelNode.h
//  PixelPixie
//
//  Created by xiefei on 15/4/2.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
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
