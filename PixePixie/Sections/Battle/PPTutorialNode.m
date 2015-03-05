//
//  PPTutorialNode.m
//  PixelPixie
//
//  Created by xiefei on 15/3/5.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import "PPTutorialNode.h"
#import "PPSpriteButton.h"
@implementation PPTutorialNode
-(void)setTutorialFinger:(CGPoint)posFinger
{
    
    
    
        PPSpriteButton *  tutorialBackBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_alert_bg"] andSize:CGSizeMake(241/2.0f,144/2.0f)];


        tutorialBackBtn.position = CGPointMake(0.0f, 0.0f);
        tutorialBackBtn.name = @"tutorial1";
        [tutorialBackBtn addTarget:self selector:@selector(tutorialBackBtnClick:)
                withObject:tutorialBackBtn.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:tutorialBackBtn];
    
    
    
    SKSpriteNode *spriteCircle=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_circle_big.png"];
    spriteCircle.position = CGPointMake(tutorialBackBtn.position.x, tutorialBackBtn.position.y-20);
    spriteCircle.size = CGSizeMake(spriteCircle.size.width/2.0f, spriteCircle.size.height/2.0f);

    [self addChild:spriteCircle];
    
    
    
    
    SKSpriteNode *spriteFinger=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_finger.pvr.png"];
    spriteFinger.position = CGPointMake(spriteCircle.position.x, spriteCircle.position.y-20);
    spriteFinger.size = CGSizeMake(spriteFinger.size.width/2.0f, spriteFinger.size.height/2.0f);
    [self addChild:spriteFinger];
    
    SKAction *actionSeq=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:0.5 duration:0.5],[SKAction scaleTo:1.0 duration:0.5], nil]];
    
    SKAction *actionRepeat=[SKAction repeatAction:actionSeq count:5];
    
    [spriteFinger runAction:actionRepeat];
    
    
}
-(void)tutorialBackBtnClick:(NSString *)stringName
{
    
}
@end
