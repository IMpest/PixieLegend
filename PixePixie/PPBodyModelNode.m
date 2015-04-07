//
//  PPBodyModelNode.m
//  PixelPixie
//
//  Created by xiefei on 15/4/2.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import "PPBodyModelNode.h"

@implementation PPBodyModelNode

-(void)setUnitBody:(NSString *)bodyId
{
    bodyHPBar = [PPValueShowNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 10)];
    [bodyHPBar setMaxValue:1000 andCurrentValue:1000
                 andShowType:PP_HPTYPE andAnchorPoint:CGPointMake(0.0f, 0.5f)
        andElementTypeString:kElementTypeString[0]];
    bodyHPBar->target = self;
//    bodyHPBar->animateEnd = @selector(animatePetHPEnd:);
    bodyHPBar.anchorPoint = CGPointMake(0.5, 0.5);
    bodyHPBar.position = CGPointMake(0.0f,20.0f);
    [self addChild:bodyHPBar];
    
    
    bodyMPBar = [PPValueShowNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50.0f, 10)];
    [bodyMPBar setMaxValue:1000 andCurrentValue:1000
               andShowType:PP_HPTYPE andAnchorPoint:CGPointMake(0.0f, 0.5f)
      andElementTypeString:kElementTypeString[0]];
    bodyMPBar->target = self;
    //    bodyHPBar->animateEnd = @selector(animatePetHPEnd:);
    bodyMPBar.anchorPoint = CGPointMake(0.5, 0.5);
    bodyMPBar.position = CGPointMake(0.0f,20.0f);
    [self addChild:bodyMPBar];
    
    
    
    [self runAction:[SKAction repeatActionForever:[[PPAtlasManager pixie_battle_action] getAnimation:[NSString stringWithFormat:@"%@3_stop",kElementTypeString[0]]]]];
    NSLog(@"plantname=%@",[NSString stringWithFormat:@"%@3_stop",kElementTypeString[0]]);
    
    
    
    headNode = [[SKSpriteNode alloc] init];
    [headNode setPosition:CGPointMake(0.0f, 20)];
    [headNode setColor:[UIColor blackColor]];
    [self addChild:headNode];
    
    
    handNode= [[SKSpriteNode alloc] init];
    [handNode setPosition:CGPointMake(0.0f, 0.0f)];
    [handNode setColor:[UIColor orangeColor]];
    [self addChild:handNode];
    
    
    bodyNode= [[SKSpriteNode alloc] init];
    [bodyNode setPosition:CGPointMake(0.0f, 0.0f)];
    [bodyNode setColor:[UIColor blueColor]];
    [self addChild:bodyNode];
    
    
    legNode= [[SKSpriteNode alloc] init];
    [legNode setPosition:CGPointMake(0.0f, -20)];
    [legNode setColor:[UIColor cyanColor]];
    [self addChild:legNode];
    
}
@end
