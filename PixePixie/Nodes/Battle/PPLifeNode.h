//
//  PPLifeNode.h
//  PixelPixie
//
//  Created by xiefei on 15/4/8.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class PPValueShowNode;

@interface PPLifeNode : SKSpriteNode
{
    PPValueShowNode * bodyHPBar;
    PPValueShowNode * bodyMPBar;
}

@end
