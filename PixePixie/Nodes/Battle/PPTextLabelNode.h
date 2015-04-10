//
//  PPTextLabelNode.h
//  PixelPixie
//
//  Created by xiefei on 15/3/8.
//  Copyright (c) 2015年 Psyches. All rights reserved.
//

#define PPMultiLineLabelImage UIImage
#define PPMultiLineLabelFont UIFont


#import <SpriteKit/SpriteKit.h>

@interface PPTextLabelNode : SKSpriteNode

@property(retain, nonatomic) SKColor *fontColor;
@property(copy, nonatomic) NSString *fontName;
@property(nonatomic) CGFloat fontSize;
@property(nonatomic) SKLabelHorizontalAlignmentMode horizontalAlignmentMode;
@property(copy, nonatomic) NSString *text;
@property(nonatomic) SKLabelVerticalAlignmentMode verticalAlignmentMode;
@property(nonatomic, assign) CGFloat paragraphWidth;

+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName;
- (instancetype)initWithFontNamed:(NSString *)fontName;


@end