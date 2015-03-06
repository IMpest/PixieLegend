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
@synthesize battleGuideStringArray;
-(void)setTutorialFinger:(CGPoint)posFinger atIndex:(int)index
{
        SKNode *contentNodePrevious = [self childNodeWithName:PP_GUIDE_CONTENT_NODE_NAME];
        if (contentNodePrevious) {
            [contentNodePrevious removeFromParent];
            contentNodePrevious = nil;
        }
    
        SKSpriteNode *contentNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.size];
        contentNode.position = posFinger;
        contentNode.name = PP_GUIDE_CONTENT_NODE_NAME;
        [self addChild:contentNode];
    
    NSLog(@"finger x=%f y=%f",posFinger.x,posFinger.y);
    
       PPSpriteButton *  tutorialBackBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_alert_bg"] andSize:CGSizeMake(241/2.0f,144/2.0f)];
        [tutorialBackBtn setLabelWithText:[self.battleGuideStringArray objectAtIndex:battleGuideIndex] andFont:[UIFont boldSystemFontOfSize:10] withColor:[UIColor redColor]];
        tutorialBackBtn.position = CGPointMake(0.0f, 0.0f);
        tutorialBackBtn.name = @"tutorial1";
        [tutorialBackBtn addTarget:self selector:@selector(tutorialBackBtnClick:)
                withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
        [contentNode addChild:tutorialBackBtn];
    
    
    
    SKSpriteNode *spriteCircle=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_circle_big.png"];
    spriteCircle.position = CGPointMake(tutorialBackBtn.position.x, tutorialBackBtn.position.y-20);
    spriteCircle.size = CGSizeMake(spriteCircle.size.width/2.0f, spriteCircle.size.height/2.0f);

    [contentNode addChild:spriteCircle];
    
    
    
    
    SKSpriteNode *spriteFinger=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_finger.pvr.png"];
    spriteFinger.position = CGPointMake(spriteCircle.position.x, spriteCircle.position.y-20);
    spriteFinger.size = CGSizeMake(spriteFinger.size.width/2.0f, spriteFinger.size.height/2.0f);
    [contentNode addChild:spriteFinger];
    
    SKAction *actionSeq=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:0.5 duration:0.5],[SKAction scaleTo:1.0 duration:0.5], nil]];
    
    SKAction *actionRepeat=[SKAction repeatAction:actionSeq count:5];
    
    [spriteFinger runAction:actionRepeat];
    
    
}
-(void)beginBattleGuide:(NSString *)guideName
{
    
      self.battleGuideStringArray = [NSArray arrayWithObjects:@"battle guide   test1",@"battle guide   test2",@"battle guide   test3",@"battle guide   test 4",@"battle guide   test 5",@"battle guide   test 6",@"battle guide   test 7",@"battle guide   test 8",@"battle guide   test 9",@"battle guide   test 10", nil];
    [self setTutorialFinger:CGPointMake(0.0f, 0.0f) atIndex:0];
}
-(void)tutorialBackBtnClick:(NSNumber *)numIndex
{
    
    battleGuideIndex++;
    
    [self setTutorialFinger:CGPointMake(arc4random()%160, arc4random()%160) atIndex:battleGuideIndex];
    
    
}
@end
