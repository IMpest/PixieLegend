//#import "PPMenuThemeScene.h"
//
//static NSString * stringMenuTheme[3] = {@"fire",@"metal",@"plant"};
//
//@interface PPMenuThemeScene ()
//@end
//
//@implementation PPMenuThemeScene
//
//- (id)initWithSize:(CGSize)size
//{
//    if (self = [super initWithSize:size]) {
////        [self setBackTitleText:@"世界地图" andPositionY:450];
//    }
//    return self;
//}
//
//-(void)didMoveToView:(SKView *)view
//{
//    UIView * contentView = [self.view viewWithTag:PP_MAP_SCROLL_VIEW_TAG];
//    if (contentView) {
//        [contentView removeFromSuperview];
//        contentView = nil;
//    }
//    
//    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 392)];
//    contentScrollView.bounces = NO;
//    contentScrollView.tag = PP_MAP_SCROLL_VIEW_TAG;
//    contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
//    contentScrollView.userInteractionEnabled = YES;
//    contentScrollView.decelerationRate = 0.0;
//    
//    for (int i = 0; i < 4; i++) {
//        UIImageView * themeImageContent = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width,
//                                                                                        0,
//                                                                                        contentScrollView.frame.size.width,
//                                                                                        contentScrollView.frame.size.height)];
//        themeImageContent.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_all_%02d",i]];
//        [contentScrollView addSubview:themeImageContent];
//        
//        UIButton * buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
//        [buttonMenu setImage:[UIImage imageNamed:[NSString stringWithFormat:@"map_icon_%@",stringMenuTheme[i]]]
//                    forState:UIControlStateNormal];
//        
//        switch (i) {
//            case 0:
//            {
//                [buttonMenu setFrame:CGRectMake(120, 60, 75, 75)];
//            }
//                break;
//            case 1:
//            {
//                [buttonMenu setFrame:CGRectMake(440, 180, 75, 75)];
//            }
//                break;
//            case 2:
//            {
//                [buttonMenu setFrame:CGRectMake(800, 80, 75, 75)];
//            }
//                break;
//            default:
//                break;
//        }
//        buttonMenu.tag = i;
//        [buttonMenu addTarget:self action:@selector(passChoose:) forControlEvents:UIControlEventTouchUpInside];
//        [contentScrollView addSubview:buttonMenu];
//    }
//    [self.view addSubview:contentScrollView];
//    
////    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    [backButton setBackgroundColor:[UIColor orangeColor]];
////    [backButton setTitle:@"返回" forState:UIControlStateNormal];
////    [backButton setFrame:CGRectMake(15, contentScrollView.frame.origin.y+10, 45, 30)];
////    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:backButton];
//}
//
//-(void)willMoveFromView:(SKView *)view
//{
//}
//
//-(void)passChoose:(UIButton *)passBtn
//{
//    UIView * contentScroll = [self.view viewWithTag:PP_MAP_SCROLL_VIEW_TAG];
//    [contentScroll removeFromSuperview];
//    
//    NSDictionary * dictPassInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PassInfo"
//                                                                                                             ofType:@"plist"]];
//    NSArray * passArray = [[NSArray alloc] initWithArray:[dictPassInfo objectForKey:@"transcriptinfo"]];
//    NSInteger passCount = [passArray count];
//    PPElementType index = (PPElementType)passBtn.tag;
//    
//    NSDictionary * passDictInfo = nil;
//    if (passCount > index) {
//        passDictInfo = [NSDictionary dictionaryWithDictionary:[passArray objectAtIndex:index]];
//    }
//    
//    // 火属性hardCode
//    if (index == 0) {
//        index = 4;
//    }
//    
//    PPMenuDungeonScene * menuDungeonScene = [[PPMenuDungeonScene alloc] initWithSize:self.view.bounds.size
//                                                                          andElement:index];
//    
//    menuDungeonScene.passDictInfo = passDictInfo;
//    menuDungeonScene->previousScene = self;
//    menuDungeonScene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    [self.view presentScene:menuDungeonScene];
//}
//
//@end
