//
//  PPTutorialNode.m
//  PixelPixie
//
//  Created by xiefei on 15/3/5.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#import "PPTutorialNode.h"
#import "PPSpriteButton.h"
#import "PPTextLabelNode.h"

@implementation PPTutorialNode
@synthesize battleGuideStringArray;
-(void)setTutorialFinger:(CGPoint)posFinger atIndex:(int)index
{
    
    SKNode *contentNodePrevious = [self childNodeWithName:PP_GUIDE_CONTENT_NODE_NAME];
    if (contentNodePrevious) {
        [contentNodePrevious removeFromParent];
        contentNodePrevious = nil;
    }
    
    
    switch ([[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"type"] intValue]) {
        case 1:
        {
            
            
            CGPoint pos = CGPointMake([[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posx"] floatValue], [[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posy"] floatValue]);
            
            
            SKSpriteNode *contentNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.size];
            contentNode.position = pos;
            contentNode.name = PP_GUIDE_CONTENT_NODE_NAME;
            [self addChild:contentNode];
            
            NSLog(@"finger x=%f y=%f",posFinger.x,posFinger.y);
            
            PPSpriteButton *  tutorialBackBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_alert_bg"] andSize:CGSizeMake(241/2.0f,144/2.0f)];
            //    [tutorialBackBtn setLabelWithText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] andFont:[UIFont boldSystemFontOfSize:10] withColor:[UIColor redColor]];
            tutorialBackBtn.position = CGPointMake(0.0f, 0.0f);
            tutorialBackBtn.name = @"tutorial1";
            [tutorialBackBtn addTarget:self selector:@selector(tutorialBackBtnClick:)
                            withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
            [contentNode addChild:tutorialBackBtn];
            
            
            //    [contentNode addChild:[self creatLabel:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] fontname:@"Arial" fontcolor:[UIColor redColor] fontsize:10 verticalMargin:10 emptylineheight:10]];
            
            //    SKLabelNode *tutorialLabel=[[SKLabelNode alloc] init];
            //    [tutorialLabel setText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"]];
            //    [tutorialLabel setFontSize:10];
            //    [tutorialLabel setColor:[UIColor redColor]];
            //    [tutorialLabel addChild:tutorialLabel];
            
            PPTextLabelNode *tutorialText=[PPTextLabelNode labelNodeWithFontNamed:@"Arial"];
            
            
            [tutorialText setText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"]];
            tutorialText.paragraphWidth = tutorialBackBtn.size.width-12;
            [tutorialText setFontSize:10];
            [tutorialText setFontColor:[UIColor redColor]];
            [tutorialText setColor:[UIColor blueColor]];
            [tutorialBackBtn addChild:tutorialText];
            tutorialText.position = CGPointMake(0.0f,0.0f);
            NSLog(@"tutorialText width=%f",tutorialText.size.width);
            
            
            
            SKSpriteNode *spriteCircle=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_circle_big.png"];
            spriteCircle.position = CGPointMake(tutorialBackBtn.position.x, tutorialBackBtn.position.y-20);
            spriteCircle.size = CGSizeMake(spriteCircle.size.width/2.0f, spriteCircle.size.height/2.0f);
            
            [contentNode addChild:spriteCircle];
            
            
            
            
//            SKSpriteNode *spriteFinger=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_finger.pvr.png"];
            PPSpriteButton *  spriteFinger = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_finger.pvr.png"] andSize:CGSizeMake(64/2.0f,128/2.0f)];
            [spriteFinger addTarget:self selector:@selector(tutorialBackBtnClick:)
                            withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
             spriteFinger.position = CGPointMake(spriteCircle.position.x, spriteCircle.position.y-20);
            [contentNode addChild:spriteFinger];
            
            
//            PPSpriteButton *  tutorialBackBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_alert_bg"] andSize:CGSizeMake(241/2.0f,144/2.0f)];
//            //    [tutorialBackBtn setLabelWithText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] andFont:[UIFont boldSystemFontOfSize:10] withColor:[UIColor redColor]];
//            tutorialBackBtn.position = CGPointMake(0.0f, 0.0f);
//            tutorialBackBtn.name = @"tutorial1";
//            [tutorialBackBtn addTarget:self selector:@selector(tutorialBackBtnClick:)
//                            withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
//            [contentNode addChild:tutorialBackBtn];
            
            SKAction *actionSeq=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:0.5 duration:0.5],[SKAction scaleTo:1.0 duration:0.5], nil]];
            
            SKAction *actionRepeat=[SKAction repeatAction:actionSeq count:5];
            
            [spriteFinger runAction:actionRepeat];

            
        }
            break;
            case 2:
        {
            
            
            CGPoint pos = CGPointMake([[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posx"] floatValue], [[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posy"] floatValue]);
            CGPoint pos1 = CGPointMake([[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posx1"] floatValue], [[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posy1"] floatValue]);

            
            SKSpriteNode *contentNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.size];
            contentNode.position = pos;
            contentNode.name = PP_GUIDE_CONTENT_NODE_NAME;
            [self addChild:contentNode];
            
            NSLog(@"finger x=%f y=%f",posFinger.x,posFinger.y);
            
            PPSpriteButton *  tutorialBackBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_alert_bg"] andSize:CGSizeMake(241/2.0f,144/2.0f)];
            //    [tutorialBackBtn setLabelWithText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] andFont:[UIFont boldSystemFontOfSize:10] withColor:[UIColor redColor]];
            tutorialBackBtn.position = CGPointMake(0.0f, 0.0f);
            tutorialBackBtn.name = @"tutorial1";
            [tutorialBackBtn addTarget:self selector:@selector(tutorialBackBtnClick:)
                            withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
            [contentNode addChild:tutorialBackBtn];
            
            
            //    [contentNode addChild:[self creatLabel:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] fontname:@"Arial" fontcolor:[UIColor redColor] fontsize:10 verticalMargin:10 emptylineheight:10]];
            
            //    SKLabelNode *tutorialLabel=[[SKLabelNode alloc] init];
            //    [tutorialLabel setText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"]];
            //    [tutorialLabel setFontSize:10];
            //    [tutorialLabel setColor:[UIColor redColor]];
            //    [tutorialLabel addChild:tutorialLabel];
            
            PPTextLabelNode *tutorialText=[PPTextLabelNode labelNodeWithFontNamed:@"Arial"];
            [tutorialText setText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"]];
            tutorialText.paragraphWidth = tutorialBackBtn.size.width-12;
            [tutorialText setFontSize:10];
            [tutorialText setFontColor:[UIColor redColor]];
            [tutorialText setColor:[UIColor blueColor]];
            [tutorialBackBtn addChild:tutorialText];
            tutorialText.position = CGPointMake(0.0f,0.0f);
            NSLog(@"tutorialText width=%f",tutorialText.size.width);
            
            
            
            SKSpriteNode *spriteCircle=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_circle_big.png"];
            spriteCircle.position = CGPointMake(tutorialBackBtn.position.x, tutorialBackBtn.position.y-20);
            spriteCircle.size = CGSizeMake(spriteCircle.size.width/2.0f, spriteCircle.size.height/2.0f);
            
            [contentNode addChild:spriteCircle];
            
            
            
            
//            SKSpriteNode *spriteFinger=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_finger.pvr.png"];
//            spriteFinger.position = CGPointMake(spriteCircle.position.x, spriteCircle.position.y-20);
//            spriteFinger.size = CGSizeMake(spriteFinger.size.width/2.0f, spriteFinger.size.height/2.0f);
//            [contentNode addChild:spriteFinger];
            PPSpriteButton *  spriteFinger = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_finger.pvr.png"] andSize:CGSizeMake(64/2.0f,128/2.0f)];
            [spriteFinger addTarget:self selector:@selector(tutorialBackBtnClick:)
                         withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
            spriteFinger.position = CGPointMake(spriteCircle.position.x, spriteCircle.position.y-20);
            [contentNode addChild:spriteFinger];
            
            
            SKAction *actionSeq=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:0.5 duration:0.5],[SKAction scaleTo:1.0 duration:0.5], nil]];
            
            SKAction *actionRepeat=[SKAction repeatAction:actionSeq count:5];
            
            [spriteFinger runAction:actionRepeat];
            
            
        }
            break;
        case 3:
        {
            
            
            CGPoint pos = CGPointMake([[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posx"] floatValue], [[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"posy"] floatValue]);
            
            
            SKSpriteNode *contentNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.size];
            contentNode.position = CGPointMake(-100.0f, -100.0f);
            contentNode.name = PP_GUIDE_CONTENT_NODE_NAME;
            [self addChild:contentNode];
            
//            NSLog(@"finger x=%f y=%f",posFinger.x,posFinger.y);
//            
//            PPSpriteButton *  tutorialBackBtn = [PPSpriteButton buttonWithTexture:[SKTexture textureWithImageNamed:@"tutorial_alert_bg"] andSize:CGSizeMake(241/2.0f,144/2.0f)];
//            //    [tutorialBackBtn setLabelWithText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] andFont:[UIFont boldSystemFontOfSize:10] withColor:[UIColor redColor]];
//            tutorialBackBtn.position = CGPointMake(0.0f, 0.0f);
//            tutorialBackBtn.name = @"tutorial1";
//            [tutorialBackBtn addTarget:self selector:@selector(tutorialBackBtnClick:)
//                            withObject:[NSNumber numberWithInt:index] forControlEvent:PPButtonControlEventTouchUpInside];
//            [contentNode addChild:tutorialBackBtn];
            
            
            //    [contentNode addChild:[self creatLabel:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"] fontname:@"Arial" fontcolor:[UIColor redColor] fontsize:10 verticalMargin:10 emptylineheight:10]];
            
            //    SKLabelNode *tutorialLabel=[[SKLabelNode alloc] init];
            //    [tutorialLabel setText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"]];
            //    [tutorialLabel setFontSize:10];
            //    [tutorialLabel setColor:[UIColor redColor]];
            //    [tutorialLabel addChild:tutorialLabel];
            
//            PPTextLabelNode *tutorialText=[PPTextLabelNode labelNodeWithFontNamed:@"Arial"];
//            [tutorialText setText:[[self.battleGuideStringArray objectAtIndex:index] objectForKey:@"message"]];
//            tutorialText.paragraphWidth = tutorialBackBtn.size.width-12;
//            [tutorialText setFontSize:10];
//            [tutorialText setFontColor:[UIColor redColor]];
//            [tutorialText setColor:[UIColor blueColor]];
//            [tutorialBackBtn addChild:tutorialText];
//            tutorialText.position = CGPointMake(0.0f,0.0f);
//            NSLog(@"tutorialText width=%f",tutorialText.size.width);
            
            
            
            SKSpriteNode *spriteCircle=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_circle_big.png"];
            spriteCircle.position = CGPointMake(0.0f, -20);
            spriteCircle.size = CGSizeMake(spriteCircle.size.width/2.0f, spriteCircle.size.height/2.0f);
            
            [contentNode addChild:spriteCircle];
            
            
            
            
            SKSpriteNode *spriteFinger=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial_finger.pvr.png"];
            spriteFinger.position = CGPointMake(spriteCircle.position.x, spriteCircle.position.y-20);
            spriteFinger.size = CGSizeMake(spriteFinger.size.width/2.0f, spriteFinger.size.height/2.0f);
            [contentNode addChild:spriteFinger];
            
            SKAction *actionSeq=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleTo:0.5 duration:0.5],[SKAction scaleTo:1.0 duration:0.5], nil]];
            
            SKAction *actionRepeat=[SKAction repeatAction:actionSeq count:5];
            
            [spriteFinger runAction:actionRepeat];
            
            
//            SKAction *actionMove = [SKAction moveByX:100 y:100 duration:1];
            SKAction *actionMove = [SKAction moveTo:CGPointMake(-100.0f, -100.0f) duration:1];

            SKAction *actionMove1 = [SKAction moveTo:CGPointMake(150, 150) duration:1];
            SKAction *actionMove2 = [SKAction moveTo:CGPointMake(-100.0f, -100.0f) duration:0.1];

            
//            SKAction *actionMove2 = [SKAction fadeAlphaTo:0.0f duration:0.1];
            
            SKAction *sequne = [SKAction sequence:[NSArray arrayWithObjects:actionMove,actionMove1,actionMove2, nil]];
            
            
            SKAction *repeat = [SKAction repeatAction:sequne count:3];
            [contentNode runAction:repeat completion:^{
              
                [self stopGuide];
                if (target!=nil&&stopSel!=nil&&[target respondsToSelector:stopSel]) {
                    
                    [target performSelectorOnMainThread:stopSel withObject:nil waitUntilDone:YES];
                    
                }
            }];
            
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}
-(void)beginBattleGuide:(NSString *)guideName
{
    
//      self.battleGuideStringArray = [NSArray arrayWithObjects:@"battle guide   test1",@"battle guide   test2",@"battle guide   test3",@"battle guide   test 4",@"battle guide   test 5",@"battle guide   test 6",@"battle guide   test 7",@"battle guide   test 8",@"battle guide   test 9",@"battle guide   test 10", nil];
    
    // 添加battleguide数据
    NSArray * pixiesData = [[[NSDictionary dictionaryWithContentsOfFile:
                             [[NSBundle mainBundle] pathForResource:@"PixiesInfo" ofType:@"plist"]] objectForKey:@"GuideInfo"] objectForKey:@"BattleGuide"];
//    NSMutableArray *guideInfo = [[NSMutableArray alloc] init];
    self.battleGuideStringArray =pixiesData;
    NSLog(@"self.battleGuideStringArray =%@",self.battleGuideStringArray);
    
    [self setTutorialFinger:CGPointMake(0.0f, 0.0f) atIndex:0];
    
    
}

-(SKSpriteNode*)creatLabel:(NSString*)text fontname:(NSString*)fontname fontcolor:(UIColor*)colorFont fontsize:(const CGFloat)SIZEFONT verticalMargin:(const CGFloat)VERTICALMARGIN emptylineheight:(const CGFloat)EMPTYLINEHEIGHT {
    NSArray* strings = [text componentsSeparatedByString:@"\n"];
    //DLog(@"string count: %lu", (unsigned long)strings.count);
    
    UIColor* color = UIColor.clearColor;
//    color = [UIColor redColor];
    SKSpriteNode* spritenode = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(0, 0)];
    
    CGFloat totalheight = 0;
    CGFloat maxwidth = 0;
    
    NSMutableArray* labels = [NSMutableArray array];
    for (NSUInteger i = 0; i < strings.count; i++) {
        NSString* str = [strings objectAtIndex:i];
        const BOOL ISEMPTYLINE = [str isEqualToString:@""];
        
        if (!ISEMPTYLINE) {
            SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:fontname];
            label.text = str;
            label.fontColor = colorFont;
            label.fontSize = SIZEFONT;
            
            const CGSize SIZEOFLABEL = [label calculateAccumulatedFrame].size;
            if (SIZEOFLABEL.width > maxwidth)
                maxwidth = SIZEOFLABEL.width;
            totalheight += SIZEOFLABEL.height;
            [labels addObject:label];
        }
        else {
            totalheight += EMPTYLINEHEIGHT;
            [labels addObject:[NSNull null]];
        }
        if (i + 1 < strings.count)
            totalheight += VERTICALMARGIN;
    }
    spritenode.size = CGSizeMake(maxwidth, totalheight);
    
    //DLog(@"spritenode total size: %@", NSStringFromSize(spritenode.size));
    CGFloat y = spritenode.size.height * 0.5;
    const CGFloat X = 0;
    for (NSUInteger i = 0; i < strings.count; i++) {
        id obj = [labels objectAtIndex:i];
        if ([obj isKindOfClass:SKLabelNode.class]) {
            SKLabelNode* label = obj;
            label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
            label.position = CGPointMake(X, y);
            [spritenode addChild:label];
            const CGSize SIZEOFLABEL = [label calculateAccumulatedFrame].size;
            y -= SIZEOFLABEL.height;
        }
        else {
            y -= EMPTYLINEHEIGHT;
        }
        if (i + 1 < labels.count)
            y -= VERTICALMARGIN;
    }
    
    return spritenode;
}
-(void)stopGuide
{
    
    self.hidden = YES;
    
}
-(void)resumeGuide
{
    
    self.hidden = NO;
    battleGuideIndex++;
    
    if (battleGuideIndex>=[self.battleGuideStringArray count]) {
        [self removeFromParent];
        if (target!=nil&&completeSel!=nil&&[target respondsToSelector:completeSel]) {
            [target performSelectorOnMainThread:completeSel withObject:nil waitUntilDone:YES];
            
        }
        
        return;
    }
    
    [self setTutorialFinger:CGPointMake(arc4random()%160, arc4random()%160) atIndex:battleGuideIndex];
    
    
}

-(void)tutorialBackBtnClick:(NSNumber *)numIndex
{
    
    battleGuideIndex++;
    
    if (battleGuideIndex>=[self.battleGuideStringArray count]) {
        [self removeFromParent];
        if (target!=nil&&completeSel!=nil&&[target respondsToSelector:completeSel]) {
            [target performSelectorOnMainThread:completeSel withObject:nil waitUntilDone:YES];

        }
        
        return;
    }
    [self setTutorialFinger:CGPointMake(arc4random()%160, arc4random()%160) atIndex:battleGuideIndex];
    
    
}

@end
