
#import "PPChoosePetView.h"

@implementation PPChoosePetView

PPChoosePetScrollView * petsScroll;

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
    NSArray * pixiesData = [[NSDictionary dictionaryWithContentsOfFile:
                             [[NSBundle mainBundle] pathForResource:@"PixiesInfo" ofType:@"plist"]] objectForKey:@"start_pixies"];
    NSMutableArray *pixies = [NSMutableArray array];
    for (NSDictionary * tPixie in pixiesData) [pixies addObject:[PPPixie pixieWithData:tPixie]];
    
    petsScroll = [[PPChoosePetScrollView alloc] initWithFrame:CGRectMake(0, 60, 320, 200) Pixies:pixies];
    [self addSubview:petsScroll];
    
    // 添加信息栏
    self.infoView = [[PPInfoView alloc] initWithFrame:CGRectMake(10, 260, 300, 210)];
    [self.infoView updatePixie:[pixies objectAtIndex:0]];
    [self addSubview:self.infoView];
    
    // 添加确定按钮
    UIButton * buttonConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonConfirm setFrame:CGRectMake(110, 400, 100, 40)];
    [buttonConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [buttonConfirm setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    [buttonConfirm addTarget:self action:@selector(clickOK:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonConfirm];
}

-(void)clickOK:(UIButton *)sender
{
    [PPLocalData getInstance].firstPixie = [petsScroll getCurrentPixie];
    [self.rootVC petsChooseCofirmBtnClick:sender];
}

@end
