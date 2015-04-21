

#import "PPNodeTools.h"

@implementation PPNodeTools

// 获取按钮背景
+ (SKSpriteNode *)getButtonDefault:(CGSize)size
{
    SKSpriteNode *btNode = [SKSpriteNode spriteNodeWithImageNamed:@"bt_normal"];
    float defaultWidth = 40.0f;
    float defaultHeight = 40.0f;
    btNode.size = CGSizeMake(defaultWidth, defaultHeight);
    btNode.xScale = size.width / defaultWidth;
    btNode.yScale = size.height / defaultHeight;
    btNode.centerRect = CGRectMake(26.0/51.0, 26.0/51.0, 1.0/51.0, 1.0/51.0);
    return btNode;
}


// 获取数字图片拼接node
+ (SKSpriteNode *)getNumber:(int)number AndColor:(NSString *)color
{
    SKSpriteNode *tNode = PP_INSTANCE(SKSpriteNode);
    if (number < 1 || color == nil) return tNode;
    
    CGFloat width = 13.0f;
    
    // 拼接数字图片
    int i = 0;
    while (number > 0) {
        i++;
        int tNum = number % 10;
        number /= 10;
        
        NSString * tNumName = [NSString stringWithFormat:@"%@_%d.png", color, tNum];
        SKSpriteNode *tNumNode = [SKSpriteNode spriteNodeWithTexture:[[PPAtlasManager ui_number] textureNamed:tNumName]];
        tNumNode.position = CGPointMake(-width * i, 0);
        tNumNode.xScale = 0.5;
        tNumNode.yScale = 0.5;
        [tNode addChild:tNumNode];
    }
    
    // 调整位置居中
    for (SKSpriteNode *numNode in [tNode children]) {
        numNode.position = CGPointMake(numNode.position.x + (i+1) * width / 2, numNode.position.y);
    }
    return tNode;
}

@end
