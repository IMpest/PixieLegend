
#import "PPInfoView.h"

@implementation PPInfoView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView * imgvBg = [[UIImageView alloc] initWithImage:
                                [[UIImage imageNamed:@"bg_alert"] stretchableImageWithLeftCapWidth:40
                                                                                      topCapHeight:40]];
        imgvBg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:imgvBg];
    }
    return self;
}


-(void)updateInfo:(PPPixie *)pixie
{
    int left = 140,top = 27;
    
    UIImageView * imgvHP = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_hp"]];
    imgvHP.frame = CGRectMake(left, top, 125, 35);
    [self addSubview:imgvHP];
    
    UIImageView * imgvAP = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_ap"]];
    imgvAP.frame = CGRectMake(left, top+35, 125, 35);
    [self addSubview:imgvAP];
    
    UIImageView * imgvDP = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_dp"]];
    imgvDP.frame = CGRectMake(left, top+70, 125, 35);
    [self addSubview:imgvDP];
    
}

@end
