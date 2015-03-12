//
//  PPTutorialNode.h
//  PixelPixie
//
//  Created by xiefei on 15/3/5.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPTutorialNode : SKSpriteNode
{
    int battleGuideIndex;
    @public
    SEL completeSel;
    SEL stopSel;
    SEL type4Sel;
    id  target;
    BOOL  isTutorialType4;
}

@property(nonatomic,retain)NSArray *battleGuideStringArray;
-(void)stopGuide;
-(void)resumeGuide;
-(void)setTutorialFinger:(CGPoint)posFinger atIndex:(int)index;
-(void)beginBattleGuide:(NSString *)guideName;
@end
