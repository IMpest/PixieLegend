
#import "PPFightingMainView.h"

static NSString * stringMenuTheme[3] = {
    @"fire",
    @"metal",
    @"plant"
};

@implementation PPFightingMainView

UIScrollView * contentScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMenuContentScrollView];
    }
    return self;
}

// 世界大地图战斗选择
-(void)passChoose:(UIButton *)passBtn
{
    [contentScrollView removeFromSuperview];
    
    NSDictionary * dictPassInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PassInfo"
                                                                                                             ofType:@"plist"]];
    NSArray * passArray = [[NSArray alloc] initWithArray:[dictPassInfo objectForKey:@"transcriptinfo"]];
    NSInteger passCount = [passArray count];
    PPElementType index = (PPElementType)passBtn.tag;
    
    NSDictionary * passDictInfo = nil;
    if (passCount > index) {
        passDictInfo = [NSDictionary dictionaryWithDictionary:[passArray objectAtIndex:index]];
    }
    
    // TODO: 火属性hardCode，后期需要改或者删除
    // if (index == 0) index = 4;
    
    [self fullScreenForBattleScene];

    PPMenuScene * menuScene = [[PPMenuScene alloc] initWithSize:self.bounds.size andElement:PPElementTypeFire];
    menuScene->preiviousView = self;
    menuScene.passDictInfo = passDictInfo;
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self presentScene:menuScene];
    
}

-(void)setMenuContentScrollView
{
    if (contentScrollView != nil) {
        [contentScrollView removeFromSuperview];
        contentScrollView = nil;
    }
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:PP_FULLSCREEN_FRAME];
    contentScrollView.bounces = NO;
    contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
    contentScrollView.userInteractionEnabled = YES;
    
    for (int i = 0; i < 4; i++) {
        UIImageView * themeImageContent = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width,
                                                                                        0,
                                                                                        contentScrollView.frame.size.width,
                                                                                        contentScrollView.frame.size.height)];
        
        themeImageContent.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_all_%02d",i]];
        [contentScrollView addSubview:themeImageContent];
        
        UIButton * buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonMenu setImage:[UIImage imageNamed:[NSString stringWithFormat:@"map_icon_%@", stringMenuTheme[i]]]
                    forState:UIControlStateNormal];
        
        switch (i) {
            case 0:
            {
                [buttonMenu setFrame:CGRectMake(120, 60, 75, 75)];
            }
                break;
            case 1:
            {
                [buttonMenu setFrame:CGRectMake(440, 180, 75, 75)];
            }
                break;
            case 2:
            {
                [buttonMenu setFrame:CGRectMake(800, 80, 75, 75)];
            }
                break;
            default:
                break;
        }
        buttonMenu.tag = i;
        [buttonMenu addTarget:self action:@selector(passChoose:) forControlEvents:UIControlEventTouchUpInside];
        [contentScrollView addSubview:buttonMenu];
    }
    [self addSubview:contentScrollView];
}

// 战斗界面全屏
-(void)fullScreenForBattleScene
{
    [self setFrame:CGRectMake(0.0f, 0.0f,
                              rootViewControl->skViewMain.frame.size.width,
                              rootViewControl->skViewMain.frame.size.height)];
    [rootViewControl->skViewMain bringSubviewToFront:self];
}

// 正常屏幕大小
-(void)normalScreenForMenu
{
    [self setFrame:CGRectMake(0.0f, 44.0f,
                              rootViewControl->skViewMain.frame.size.width,
                              rootViewControl->skViewMain.frame.size.height - 44 * 2)];
    [rootViewControl->skViewMain bringSubviewToFront:self];
}


@end
