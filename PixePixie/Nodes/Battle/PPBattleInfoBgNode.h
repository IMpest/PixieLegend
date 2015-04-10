//
//  PPBattleInfoBgNode.h
//  PixelPixie
//
//  Created by xiefei on 15/4/8.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPBattleInfoBgNode : SKSpriteNode
{
    SKSpriteNode *arryNearBg[2];
    SKSpriteNode *arryFarBg[3];
}
-(void)backgroundMove:(CGFloat)speed;
@end
