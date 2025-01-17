
#import "PPRootViewController.h"
#import "Configuration.h"
@interface PPRootViewController ()
{
    PPPlayerNameView * skViewName;
    PPChoosePetView * skViewPixie;
    UIView * userInfoBar;
    UIView * menuInfoBar;
    UIImageView * tabLight;
    
    PPInfoView * stoneView;
    
    PPMonsterMainView * monsterMainView;
    PPKnapsackMainView * knapsackMainView;
    PPFightingMainView * fightingMainView;
    PPScheduleMainView * scheduleMainView;
    PPOthersMainView * othersMainView;
    
    UIButton * userInfoBtn[PP_MENU_COUNT];
}

@end


@implementation PPRootViewController

NSString * userInfo[] =
{
    @"Name",
    @"Energy",
    @"Stone",
    @"Coin",
    @""
};

-(void)loadView
{
    [super loadView];
    
    // 添加大背景
    UIImageView * imgvBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_start"]];
    imgvBg.frame = PP_FULLSCREEN_FRAME;
    [self.view addSubview:imgvBg];
    
    if (YES)
    {
        // 首次启动菜单
        [self loadNameView];
        [self.view addSubview:skViewName];
    }
    else
    {
        [self loadMainView];
        [self.view addSubview:skViewMain];
    }
    [self addFitSizeBar];
}

// 添加上下两个适配条
-(void)addFitSizeBar
{
//    if (CURRENT_DEVICE_REAL_SIZE.height > 500)
//    {
//        UIImageView * upBlackBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fit_top.png"]];
//        upBlackBar.frame = CGRectMake(0, 0, 320, 44);
//        [self.view addSubview:upBlackBar];
//        
//        UIImageView * downBlackBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fit_bottom.png"]];
//        downBlackBar.frame = CGRectMake(0, self.view.frame.size.height - 44, 320, 44);
//        [self.view addSubview:downBlackBar];
//    }
}

// 加载名字输入界面
-(void)loadNameView
{
    skViewName = [[PPPlayerNameView alloc] initWithFrame:PP_FULLSCREEN_FRAME];
    [self.view addSubview:skViewName];
}

// 宠物名字界面点击跳转
-(void)textInputConfirmClick:(UIButton *)sender
{
    skViewPixie = [[PPChoosePetView alloc] initWithFrame:PP_FULLSCREEN_FRAME];
    skViewPixie.rootVC = self;
    [self.view addSubview:skViewPixie];
    
    if (skViewName != nil)
    {
        [skViewName removeFromSuperview];
        skViewName = nil;
    }
}

// 确认已选择的宠物点击进入主界面
-(void)petsChooseCofirmBtnClick:(UIButton *)sender
{
    [PPLocalData setContent:@"Logged" forContentKey:PP_FIRST_LOG_IN];
    [self loadMainView];
    [self.view addSubview:skViewMain];
    
    if (skViewPixie)
    {
        [skViewPixie removeFromSuperview];
        skViewPixie = nil;
    }
}

// 加载主界面
-(void)loadMainView
{
    skViewMain = [[SKView alloc] initWithFrame:PP_FULLSCREEN_FRAME];
    
    // 分组界面
    CGRect NormalViewRect = CGRectMake(0, 0, skViewMain.frame.size.width, skViewMain.frame.size.height);
    
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
    userInfoBar.hidden = YES;
    [userInfoBar setBackgroundColor:[UIColor clearColor]];
    
    CGRect barPos[5] =
    {
        CGRectMake(30,  2,  80, 18),
        CGRectMake(140, 2,  80, 18),
        CGRectMake(30,  23, 80, 18),
        CGRectMake(140, 23, 80, 18),
        CGRectMake(245, 2,  50, 40)
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
    
    for (int i = 0; i < PP_MENU_COUNT; i++)
    {
        userInfoBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        userInfoBtn[i].backgroundColor = [UIColor clearColor];
        userInfoBtn[i].frame = barPos[i];
        userInfoBtn[i].tag = PP_USER_BUTON_TAG + i;
        [userInfoBtn[i].titleLabel setFont:[UIFont systemFontOfSize:8]];
        [userInfoBtn[i] addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [userInfoBar addSubview:userInfoBtn[i]];
    }
    [self refreshLocalPlayerInfo];
    [skViewMain addSubview:userInfoBar];
    
    // 下方一排按钮
    menuInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, skViewMain.frame.size.height - 44, 320, 44)];
    
    UIImageView * imgvBgBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_bar_bottom.png"]];
    imgvBgBottom.frame = CGRectMake(0, 0, 320, 44);
    [menuInfoBar addSubview:imgvBgBottom];
    
    for (int i = 0; i < PP_MENU_COUNT; i++)
    {
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.tag = PP_MENU_BUTON_TAG + i;
        menuBtn.frame = CGRectMake(i * skViewMain.frame.size.width / PP_MENU_COUNT + ( 64 - 38 ) / 2, 5, 38, 38);
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [menuBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab_btn%d",i]] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuInfoBar addSubview:menuBtn];
    }
    
    
    [menuInfoBar setBackgroundColor:[UIColor redColor]];
    
    // 设置Monster界面为首页界面
    tabLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_light.png"]];
    [menuInfoBar addSubview:tabLight];
    
    [skViewMain bringSubviewToFront:monsterMainView];
    [self changeMenuState:PP_MENU_START];
    
    [skViewMain addSubview:menuInfoBar];

}

// 根据本地Player信息更新上方信息栏
-(void) refreshLocalPlayerInfo
{
    [userInfoBtn[0] setTitle:[NSString stringWithFormat:@"%@", [PPPlayer getInstance].playerName] forState:UIControlStateNormal];
    [userInfoBtn[1] setTitle:[NSString stringWithFormat:@"%ld", [PPPlayer getInstance].playerEnergy] forState:UIControlStateNormal];
    [userInfoBtn[2] setTitle:[NSString stringWithFormat:@"%ld", [PPPlayer getInstance].playerStone] forState:UIControlStateNormal];
    [userInfoBtn[3] setTitle:[NSString stringWithFormat:@"%ld", [PPPlayer getInstance].playerGold] forState:UIControlStateNormal];
}

// 改变tab提示框位置
-(void)changeMenuState:(int)index
{
    tabLight.frame = CGRectMake(index * skViewMain.frame.size.width / PP_MENU_COUNT + (64-36)/2, 5, 36, 36);
}

// 上方按钮点击
-(void)userBtnClick:(UIButton *)sender
{
    if (!stoneView) {
        stoneView = [[PPInfoView alloc] initWithFrame:CGRectMake(10, PP_FIT_TOP_SIZE + 40, 300, 300)];
        [stoneView updateStone];
        [self.view addSubview:stoneView];
    } else {
        [stoneView removeFromSuperview];
        stoneView = nil;
    }
}

// 下方按钮点击
-(void)menuBtnClick:(UIButton *)sender
{
    if (sender == nil)
    {
        [skViewMain bringSubviewToFront:monsterMainView];
        return ;
    }
    
    [self changeMenuState:(int)sender.tag - PP_MENU_BUTON_TAG];
    
    switch (sender.tag - PP_MENU_BUTON_TAG)
    {
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

@end
