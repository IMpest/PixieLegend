
#import "PPRootViewController.h"

@interface PPRootViewController ()
@end

@implementation PPRootViewController

int menuAnimationTag;
UIButton * backToMain;

UIView * skViewName;
UIView * skViewPixie;
UIView * userInfoBar;
UIView * menuInfoBar;
UIImageView * tabLight;

PPMonsterMainView * monsterMainView;
PPKnapsackMainView * knapsackMainView;
PPFightingMainView * fightingMainView;
PPScheduleMainView * scheduleMainView;
PPOthersMainView * othersMainView;

NSString * userInfo[] =
{
    @"Name",
    @"Energy",
    @"Stone",
    @"Coin",
    @""
};

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    //这个不知道干嘛的我先注释掉了(返回到世界大地图)
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(backToMonsterScene:)
//                                                 name:PP_BACK_TO_MAIN_VIEW object:nil];
    
    if ([[PPLocalData contentFromUserDefaultKey:PP_FIRST_LOG_IN] isEqualToString:@"1"]) {
//    if (NO) {
        [self loadMainView];
        [self.view addSubview:skViewMain];
    } else {
        // 首次启动菜单
        [self loadNameView];
        [self.view addSubview:skViewName];
    }
    [self addFitSizeBar];
}

// 添加上下两个适配条
-(void)addFitSizeBar
{
    if (CurrentDeviceRealSize.height > 500) {
        UIImageView * upBlackBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_fit_top.png"]];
        upBlackBar.frame = CGRectMake(0, 0, 320, 44);
        [self.view addSubview:upBlackBar];
        
        UIImageView * downBlackBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_fit_bottom.png"]];
        downBlackBar.frame = CGRectMake(0, self.view.frame.size.height - 44, 320, 44);
        [self.view addSubview:downBlackBar];
    }
}

// 加载名字输入界面
-(void)loadNameView
{
    skViewName = [[UIView alloc] initWithFrame:CGRectMake(0, PP_FIT_TOP_SIZE, 320, 480)];
    
    UIImageView * imgvBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_start"]];
    imgvBg.frame = CGRectMake(0, 0, 320, 480);
    [skViewName addSubview:imgvBg];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 40)];
    [titleLabel setBackgroundColor:[UIColor yellowColor]];
    [titleLabel setText:@"下面请告诉我你的名字："];
    [skViewName addSubview:titleLabel];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(40, 50, 150, 50)];
    [textFiled addTarget:self action:@selector(textFieldResign:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textFiled setBackgroundColor:[UIColor redColor]];
    [skViewName addSubview:textFiled];
    
    UIButton * buttonConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [buttonConfirm setBackgroundColor:[UIColor brownColor]];
    [buttonConfirm addTarget:self action:@selector(textInputConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonConfirm setFrame:CGRectMake(120, 120, 60, 40)];
    [skViewName addSubview:buttonConfirm];
}

// 点击跳转确认宠物名字界面
-(void)textInputConfirmClick
{
    skViewPixie = [[UIView alloc] initWithFrame:CGRectMake(0, PP_FIT_TOP_SIZE, 320, 480)];
    
    UIImageView * imgvBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_start"]];
    imgvBg.frame = CGRectMake(0, 0, 320, 480);
    [skViewPixie addSubview:imgvBg];
    
    NSDictionary * dictUserPets = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PetsChooseInfo"
                                                                                                             ofType:@"plist"]];
    
    PPChoosePetScrollView * petsScroll = [[PPChoosePetScrollView alloc] initWithFrame:CGRectMake(20, 20, 280, 250)];
    [petsScroll setBackgroundColor:[UIColor cyanColor]];
    [petsScroll setSCrollWith:dictUserPets];
    [skViewPixie addSubview:petsScroll];
    
    UILabel * labelEnemyInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 60)];
    [labelEnemyInfo setText:@"怪物信息"];
    [labelEnemyInfo setBackgroundColor:[UIColor whiteColor]];
    [labelEnemyInfo setTextAlignment:NSTextAlignmentCenter];
    [skViewPixie addSubview:labelEnemyInfo];
    
    UILabel * labelConfrimInfo = [[UILabel alloc] initWithFrame:
                                 CGRectMake(labelEnemyInfo.frame.origin.x,
                                            labelEnemyInfo.frame.origin.y+labelEnemyInfo.frame.size.height + 10, 200, 40)];
    [labelConfrimInfo setFont:[UIFont boldSystemFontOfSize:11]];
    [labelConfrimInfo setTextColor:[UIColor blackColor]];
    [labelConfrimInfo setText:@"是否选择此怪物作为你的第一个伙伴？"];
    [labelConfrimInfo setTextAlignment:NSTextAlignmentCenter];
    [skViewPixie addSubview:labelConfrimInfo];
    
    UIButton * petsChooseCofirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [petsChooseCofirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [petsChooseCofirmBtn setBackgroundColor:[UIColor blackColor]];
    [petsChooseCofirmBtn setFrame:CGRectMake(labelConfrimInfo.frame.origin.x + labelConfrimInfo.frame.size.width + 20,
                                             labelConfrimInfo.frame.origin.y, 40, 40)];
    [petsChooseCofirmBtn addTarget:self action:@selector(petsChooseCofirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [skViewPixie addSubview:petsChooseCofirmBtn];
    
    [self.view addSubview:skViewPixie];
    
    if (skViewName != nil)
    {
        [skViewName removeFromSuperview];
        skViewName = nil;
    }
}

// 确认宠物点击
-(void)petsChooseCofirmBtnClick:(UIButton *)sender
{
    [PPLocalData setContent:@"1" forContentKey:PP_FIRST_LOG_IN];
    [self loadMainView];
    [self.view addSubview:skViewMain];
    
    if (skViewPixie) {
        [skViewPixie removeFromSuperview];
        skViewPixie = nil;
    }
}

-(void)textFieldResign:(UITextField *)textField
{
    [textField resignFirstResponder];
}

// 加载主界面
-(void)loadMainView
{
    skViewMain = [[SKView alloc] initWithFrame:CGRectMake(0, PP_FIT_TOP_SIZE, 320, 480)];
    
    CGRect NormalViewRect = CGRectMake(0, 44, skViewMain.frame.size.width, skViewMain.frame.size.height - 44 * 2);
    
    monsterMainView = [[PPMonsterMainView alloc] initWithFrame:NormalViewRect];
    [skViewMain addSubview:monsterMainView];
    
    knapsackMainView = [[PPKnapsackMainView alloc] initWithFrame:NormalViewRect];
    [skViewMain addSubview:knapsackMainView];
    
    
    fightingMainView = [[PPFightingMainView alloc] initWithFrame:NormalViewRect];
    fightingMainView->rootViewControl = self;
    [skViewMain addSubview:fightingMainView];
    
    scheduleMainView = [[PPScheduleMainView alloc] initWithFrame:NormalViewRect];
    [skViewMain addSubview:scheduleMainView];
    
    othersMainView = [[PPOthersMainView alloc] initWithFrame:NormalViewRect];
    [skViewMain addSubview:othersMainView];

    
    // 上方信息栏
    userInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [userInfoBar setBackgroundColor:[UIColor clearColor]];
    
    CGRect barPos[5] = {
        CGRectMake(30, 2, 80, 18),
        CGRectMake(140, 2, 80, 18),
        CGRectMake(30, 23, 80, 18),
        CGRectMake(140, 23, 80, 18),
        CGRectMake(245, 2, 50, 40)
    };
    
    UIImageView * imgvBgTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_bar_top.png"]];
    imgvBgTop.frame = CGRectMake(0, 0, 320, 44);
    [userInfoBar addSubview:imgvBgTop];

    UIImageView * imgvName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_name.png"]];
    imgvName.frame = barPos[0];
    [userInfoBar addSubview:imgvName];

    UIImageView * imgvStone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_energy.png"]];
    imgvStone.frame = barPos[1];
    [userInfoBar addSubview:imgvStone];
    
    UIImageView * imgvEnergy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_stone.png"]];
    imgvEnergy.frame = barPos[2];
    [userInfoBar addSubview:imgvEnergy];

    UIImageView * imgvCoin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_coin.png"]];
    imgvCoin.frame = barPos[3];
    [userInfoBar addSubview:imgvCoin];
    
    UIImageView * imgvMail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_mail.png"]];
    imgvMail.frame = barPos[4];
    [userInfoBar addSubview:imgvMail];
    
    for (int i = 0; i < PP_MENU_COUNT; i++) {
        UIButton  * userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        userInfoBtn.backgroundColor = [UIColor clearColor];
        userInfoBtn.frame = barPos[i];
        userInfoBtn.tag = PP_USER_BUTON_TAG + i;
        [userInfoBtn.titleLabel setFont:[UIFont systemFontOfSize:8]];
        [userInfoBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [userInfoBtn setTitle:userInfo[i] forState:UIControlStateNormal];
        [userInfoBar addSubview:userInfoBtn];
    }
    [skViewMain addSubview:userInfoBar];
    
    // 下方一排按钮
    menuInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, skViewMain.frame.size.height - 44, 320, 44)];
    
    UIImageView * imgvBgBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_bar_bottom.png"]];
    imgvBgBottom.frame = CGRectMake(0, 0, 320, 44);
    [menuInfoBar addSubview:imgvBgBottom];
    
    for (int i = 0; i < PP_MENU_COUNT; i++) {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.tag = PP_MENU_BUTON_TAG + i;
        menuBtn.frame = CGRectMake(i * skViewMain.frame.size.width/PP_MENU_COUNT+(64-38)/2, 5, 38, 38);
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [menuBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab_btn%d",i]] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuInfoBar addSubview:menuBtn];
    }
    [skViewMain addSubview:menuInfoBar];
    
    // 设置Monster界面为首页界面
    tabLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_light.png"]];
    [menuInfoBar addSubview:tabLight];
    
    [skViewMain bringSubviewToFront:monsterMainView];
    [self changeMenuState:PP_MENU_START];
}

//上方按钮点击
-(void)userBtnClick:(UIButton *)sender
{
    
}

//下方按钮点击
-(void)menuBtnClick:(UIButton *)sender
{
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         [backToMain setFrame:CGRectMake(0,
//                                                         backToMain.frame.origin.y,
//                                                         backToMain.frame.size.width,
//                                                         backToMain.frame.size.height)];
//                     }
//                     completion:^(BOOL finished){
//                     }];
   
    [self changeMenuState:(int)sender.tag - PP_MENU_BUTON_TAG];
    
    if (sender == nil) {
//        CGRect NormalViewRect = CGRectMake(0, 44, skViewMain.frame.size.width, skViewMain.frame.size.height - 44 * 2);
//        fightingMainView = nil;
//        fightingMainView = [[PPFightingMainView alloc] initWithFrame:NormalViewRect];
        
         [skViewMain bringSubviewToFront:monsterMainView];
        return ;
    }
    
    switch (sender.tag - PP_MENU_BUTON_TAG) {
        case 0:
        {
            [skViewMain bringSubviewToFront:monsterMainView];
        }
            break;
        case 1:
        {
            [skViewMain bringSubviewToFront:knapsackMainView];
        }
            break;
        case 2:
        {
            [skViewMain bringSubviewToFront:fightingMainView];
//            fightingMainView->mainScene->backButton.hidden = NO;
        }
            break;
        case 3:
        {
            [skViewMain bringSubviewToFront:scheduleMainView];
        }
            break;
        case 4:
        {
            [skViewMain bringSubviewToFront:othersMainView];
        }
            break;
            
        default:
            break;
    }
    
    [monsterMainView hideMonstorShowBtns];
    
}

-(void)backToMonsterScene:(NSNotification *)notifi
{
    
    //    [skViewMain bringSubviewToFront:monsterMainView];
    [self menuBtnClick:nil];
    [self changeMenuState:3];
    
//    if ([[notifi object] isEqualToString:PP_BACK_TO_MAIN_VIEW_FIGHTING]) {
//        
//        [skViewMain bringSubviewToFront:menuInfoBar];
//        [skViewMain bringSubviewToFront:userInfoBar];
//        
//    }
}

// 改变tab提示
-(void)changeMenuState:(int)index
{
    tabLight.frame = CGRectMake(index * skViewMain.frame.size.width/PP_MENU_COUNT+(64-36)/2, 5, 36, 36);
//    for (int i = 0; i < PP_MENU_COUNT; i++) {
//        UIButton * buttonMenuTmp = (UIButton *)[menuInfoBar viewWithTag:PP_MENU_BUTON_TAG + i];
//        if (i == index) {
//            [buttonMenuTmp setBackgroundColor:[UIColor blueColor]];
//        } else {
//            [buttonMenuTmp setBackgroundColor:[UIColor clearColor]];
//        }
//    }
}

//// Todo 加注释
//-(void)counterpartEnter:(id)obj
//{
//    PPTableView * ppTable1 = [[PPTableView alloc] initWithFrame:CGRectMake(0, 80, 320, 200)];
//    ppTable1.tag = PP_PASSNUM_CHOOSE_TABLE_TAG;
//    ppTable1.choosePassNumber = self;
//    ppTable1.choosePassNumberSel = @selector(enterBattle:);
//    NSArray * productInfoArray = [NSArray arrayWithObjects:@"关卡1",@"关卡2",@"关卡3",@"关卡4",@"关卡5",@"关卡6", nil];
//    [ppTable1 ppsetTableViewWithData:productInfoArray];
//    [self.view addSubview:ppTable1];
//}
//
// Todo 加注释
//-(void)enterBattle:(NSNumber *)passNumber
//{
//    UIView * passNumView = [self.view viewWithTag:PP_PASSNUM_CHOOSE_TABLE_TAG];
//    [passNumView removeFromSuperview];
//    passNumber = nil;
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        [backToMain setFrame:CGRectMake(0, backToMain.frame.origin.y,
//                                        backToMain.frame.size.width, backToMain.frame.size.height)];
//    } completion:^(BOOL finished){}];
//    
//    //    [self menuDownAnimation];
//    
//    PPHurdleReadyScene * battleScene;
//    battleScene = [[PPHurdleReadyScene alloc] initWithSize:CurrentDeviceRealSize];
//    battleScene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    [skViewMain presentScene:battleScene];
//}



//-(void)backToMainClick
//{
//    
//    if ([UIScreen mainScreen].bounds.size.height > 500) {
//
//    [skViewMain setFrame:CGRectMake(0, 44, 320, 480)];
//        
//    }
//    
//    [skViewMain presentScene:mainScene];
//    [UIView animateWithDuration:0.1 animations:^{
//        
//        [backToMain setFrame:CGRectMake(-backToMain.frame.size.width, backToMain.frame.origin.y,
//                                        backToMain.frame.size.width, backToMain.frame.size.height)];
//        
//    } completion:^(BOOL finished){}];
//    [self menuUpAnimation];
//    
//}

-(void)menuUpAnimation
{
    [self performSelector:@selector(upMenuBtn) withObject:nil];
}

-(void)menuDownAnimation
{
    [self performSelector:@selector(downMenuBtn) withObject:nil];
}

-(void)upMenuBtn
{
    
    [UIView animateWithDuration:0.05
                     animations:
     ^{
        UIButton *buttonTmp=(UIButton *)[skViewMain viewWithTag:PP_MENU_BUTON_TAG+menuAnimationTag];
        NSLog(@"height=%f",skViewMain.frame.size.height);
        [buttonTmp setFrame:CGRectMake(buttonTmp.frame.origin.x,2, buttonTmp.frame.size.width, buttonTmp.frame.size.height)];
     }
                     completion:
     ^(BOOL finished) {
        menuAnimationTag++;
        if (menuAnimationTag < PP_MENU_COUNT) {
            [self performSelector:@selector(menuUpAnimation) withObject:nil];
            return ;
        }
        menuAnimationTag=0;
     }];
    
}

-(void)downMenuBtn
{
    [UIView animateWithDuration:0.05 animations:^{
        
        UIButton * buttonTmp = (UIButton *)[skViewMain viewWithTag:PP_MENU_BUTON_TAG + menuAnimationTag];
        [buttonTmp setFrame:CGRectMake(buttonTmp.frame.origin.x, buttonTmp.frame.size.height,
                                       buttonTmp.frame.size.width, buttonTmp.frame.size.height)];

    } completion:^(BOOL finished){
        menuAnimationTag++;
        if (menuAnimationTag < PP_MENU_COUNT) {
            [self performSelector:@selector(menuDownAnimation) withObject:nil];
            return ;
        }
        menuAnimationTag = 0;
    }];

}

@end
