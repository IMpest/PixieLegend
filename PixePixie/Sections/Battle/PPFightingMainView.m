
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
        
//        [self changeToPassScene];
        
        contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 392)];
        contentScrollView.bounces = NO;
        contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
        contentScrollView.userInteractionEnabled = YES;
        contentScrollView.decelerationRate = 0.0;
        
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
    return self;
}

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
    
    if (index == 0) index = 4; // 火属性hardCode
    PPMenuScene * menuScene = [[PPMenuScene alloc] initWithSize:self.bounds.size andElement:index];
    //    menuScene->previousScene = self;
    menuScene.passDictInfo = passDictInfo;
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self presentScene:menuScene];
    
    
}

-(void)changeToPassScene
{
//    mainScene = [[PPMenuThemeScene alloc] initWithSize:self.bounds.size];
//    mainScene.scaleMode = SKSceneScaleModeAspectFit;
//    [self presentScene:mainScene];
}

@end
