#import "PPBasicScene.h"

@implementation PPBasicScene

PPSpriteButton * backButtonTitle;
PPSpriteButton * backButton;

-(void)addDefaultBackground
{
    SKSpriteNode * defaultBg = [[SKSpriteNode alloc] initWithImageNamed:@"bg_start"];
    defaultBg.size = CGSizeMake(320, 480 - 44 * 2);
    defaultBg.position = CGPointMake(160, 196);
    defaultBg.zPosition = PPZ_BACK_GROUND;
    [self addChild:defaultBg];
}

-(void)addTitle:(NSString *)title
{
    if (title == nil)  return;
    
    backButtonTitle = [PPSpriteButton  buttonWithImageNamed:@"title_section"];
    backButtonTitle.size = CGSizeMake(107, 22);
    backButtonTitle.position = CGPointMake(53, 360);
    backButtonTitle.zPosition = PPZ_BACK_BUTTON;
    
    [backButtonTitle setLabelWithText:title andFont:[UIFont systemFontOfSize:12] withColor:nil];
    [backButtonTitle addTarget:self selector:@selector(backTitleClick:)
                    withObject:title forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:backButtonTitle];
}

-(void)addTitle:(NSString *)title andBackButton:(CGFloat)yPostion;
{
    if (title != nil) {
        backButtonTitle = [PPSpriteButton  buttonWithImageNamed:@"title_section"];
        backButtonTitle.size = CGSizeMake(107, 22);
        backButtonTitle.position = CGPointMake(60, yPostion);
        backButtonTitle.zPosition = PPZ_BACK_BUTTON;
        
        [backButtonTitle setLabelWithText:title andFont:[UIFont systemFontOfSize:12] withColor:nil];
        [backButtonTitle addTarget:self selector:@selector(backTitleClick:)
                        withObject:title forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:backButtonTitle];
    }
    
    backButton = [PPSpriteButton buttonWithImageNamed:@"bt_back"];
    backButton.size = CGSizeMake(29, 29);
    backButton.position = CGPointMake(15, yPostion);
    backButton.zPosition = PPZ_BACK_BUTTON;
    
    [backButton addTarget:self selector:@selector(backButtonClick:)
               withObject:@"" forControlEvent:PPButtonControlEventTouchUpInside];
    [self addChild:backButton];
}

-(void)backButtonClick:(NSString *)backName
{}

-(void)backTitleClick:(NSString *)backName
{}

-(void)backToSuperScene
{}

@end
