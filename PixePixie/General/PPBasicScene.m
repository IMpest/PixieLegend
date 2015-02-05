#import "PPBasicScene.h"

@implementation PPBasicScene

PPSpriteButton * backButtonTitle;
PPSpriteButton * backButton;

-(void)setUsingDefaultBackground
{
    SKSpriteNode * defaultBg = [[SKSpriteNode alloc] initWithImageNamed:@"bg_start"];
    defaultBg.size = CGSizeMake(320, 480 - 44 * 2);
    defaultBg.position = CGPointMake(160, 196);
    defaultBg.zPosition = PPZ_BACK_GROUND;
    [self addChild:defaultBg];
}

-(void)setBackTitleText:(NSString *)title andPositionY:(CGFloat)yValue;
{
    backButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(45, 30)];
    [backButton setLabelWithText:@"返回" andFont:[UIFont systemFontOfSize:15] withColor:nil];
    backButton.zPosition = PPZ_BACK_BUTTON;
    backButton.position = CGPointMake(15.0f,yValue);
    [backButton addTarget:self selector:@selector(backButtonClick:)
               withObject:@"返回" forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:backButton];
    
    if (title != nil) {
        backButtonTitle = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(120, 30)];
        [backButtonTitle setLabelWithText:title andFont:[UIFont systemFontOfSize:15] withColor:nil];
        backButtonTitle.position = CGPointMake(backButton.position.x + backButton.size.width/2 + backButtonTitle.size.width/2,
                                               backButton.position.y);
        backButtonTitle.zPosition = backButton.zPosition;
        [backButtonTitle addTarget:self selector:@selector(backTitleClick:)
                        withObject:title forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:backButtonTitle];
    }
}

-(void)backButtonClick:(NSString *)backName
{}

-(void)backTitleClick:(NSString *)backName
{}

-(void)backToSuperScene
{}

@end
