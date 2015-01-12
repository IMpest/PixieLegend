
#import "PPInfoView.h"

@implementation PPInfoView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIImageView * imgvBg = [[UIImageView alloc] initWithImage:
                            [[UIImage imageNamed:@"bg_alert"] stretchableImageWithLeftCapWidth:100
                                                                                  topCapHeight:50]];
    imgvBg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imgvBg];
}

-(void)updateInfo:(PPPixie *)pixie
{
    
}

@end
