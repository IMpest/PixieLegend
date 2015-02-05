
#import "PPInfoView.h"

@implementation PPInfoView

UIImageView *imgvHP, *imgvAP,*imgvDP;
UILabel *lbHP, *lbAP, *lbDP;
UIView * skillIcon;

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

-(void)updatePixie:(PPPixie *)pixie
{
    if (pixie == nil) return;
    
    int left = 140, top = 27;
    
    if (imgvHP == nil) {
        imgvHP = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_hp"]];
        imgvHP.frame = CGRectMake(left, top, 125, 35);
        [self addSubview:imgvHP];
    }
    if (imgvAP == nil) {
        imgvAP = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_ap"]];
        imgvAP.frame = CGRectMake(left, top+35, 125, 35);
        [self addSubview:imgvAP];
    }
    if (imgvDP == nil) {
        imgvDP = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_dp"]];
        imgvDP.frame = CGRectMake(left, top+70, 125, 35);
        [self addSubview:imgvDP];
    }

    int left2 = left + 40, top2 = top + 5;
    
    if (lbHP == nil) {
        lbHP = [[UILabel alloc] initWithFrame:CGRectMake(left2, top2, 125, 35)];
        [self addSubview:lbHP];
    }
    if (lbAP == nil) {
        lbAP = [[UILabel alloc] initWithFrame:CGRectMake(left2, top2+35, 125, 35)];
        [self addSubview:lbAP];
    }
    if (lbDP == nil) {
        lbDP = [[UILabel alloc] initWithFrame:CGRectMake(left2, top2+70, 125, 35)];
        [self addSubview:lbDP];
    }
    
    lbHP.text = [NSString stringWithFormat:@"%.0f", pixie.pixieHPmax];
    lbAP.text = [NSString stringWithFormat:@"%.0f", pixie.pixieAP];
    lbDP.text = [NSString stringWithFormat:@"%.0f", pixie.pixieDP];
    
    
    if (skillIcon != nil) {
        [skillIcon removeFromSuperview];
        skillIcon = nil;
    }
    
    skillIcon = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 110, 110)];
    [self addSubview:skillIcon];
    
    // 最多显示四个技能
    const int tmax = 4;
    int x[tmax] = {0, 55, 0, 55};
    int y[tmax] = {0, 0, 55, 55};
    
    for (int i = 0; i < tmax; i++) {
        if (i < [pixie.skillList count] ) {
            PPSkill * tSkill = (PPSkill *)[pixie.skillList objectAtIndex:i];
            UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[tSkill getIconImageName]]];
            icon.frame = CGRectMake(x[i], y[i], 50, 50);
            [skillIcon addSubview:icon];
        }
    }
    
}

@end
