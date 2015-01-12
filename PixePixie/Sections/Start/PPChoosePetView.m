
#import "PPChoosePetView.h"

@implementation PPChoosePetView

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 添加标题
    UIImageView * imgvTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pet_hint.png"]];
    imgvTitle.frame = CGRectMake(40, 10, 240, 40);
    [self addSubview:imgvTitle];

    UILabel * labelConfrimInfo = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 240, 40)];
    [labelConfrimInfo setFont:[UIFont boldSystemFontOfSize:14]];
    [labelConfrimInfo setTextColor:[UIColor whiteColor]];
    [labelConfrimInfo setText:@"选择你的第一个伙伴"];
    [labelConfrimInfo setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:labelConfrimInfo];
    
    
    // 添加宠物
//    NSDictionary * dictUserPets = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PetsChooseInfo"
//                                                                                                             ofType:@"plist"]];
//    
//    NSArray * petsInfoArray = [[NSArray alloc] initWithArray:[dictUserPets objectForKey:@"userpetinfo"]];
//    NSArray * petsArray = [NSArray arrayWithArray:petsInfoArray];
    
    NSArray * pixies = [NSArray arrayWithObjects:
                        [PPPixie birthPixieWithHPmax:1000.0f MPmax:1000.0f],
                        [PPPixie birthPixieWithHPmax:1500 MPmax:1500], nil];
    
    PPChoosePetScrollView * petsScroll = [[PPChoosePetScrollView alloc] initWithFrame:CGRectMake(0, 60, 320, 200)
                                                                               Pixies:pixies];
    [self addSubview:petsScroll];
    
    
    PPInfoView * infoView = [[PPInfoView alloc] initWithFrame:CGRectMake(10, 300, 300, 160)];
    [self addSubview:infoView];
    
    // 添加确定按钮
    UIButton * buttonConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonConfirm setFrame:CGRectMake(110, 400, 100, 40)];
    [buttonConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [buttonConfirm setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    [buttonConfirm addTarget:self.rootVC action:@selector(petsChooseCofirmBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonConfirm];
    
    
    

}

@end
