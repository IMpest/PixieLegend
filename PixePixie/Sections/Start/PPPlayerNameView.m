

#import "PPPlayerNameView.h"

@implementation PPPlayerNameView

-(void)layoutSubviews
{
    
    UIImageView * imgvBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_alert"]];
    imgvBg.frame = CGRectMake(40, 100, 240, 200);
    [self addSubview:imgvBg];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 140, 160, 40)];
    [titleLabel setText:@"给自己取个名字吧："];
    [self addSubview:titleLabel];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(80, 180, 160, 30)];
    [textFiled addTarget:self action:@selector(textFieldResign:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textFiled setBackgroundColor:[UIColor blackColor]];
    [textFiled setTextColor:[UIColor whiteColor]];
    [textFiled setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:textFiled];
    
    UIButton * buttonConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonConfirm setFrame:CGRectMake(110, 240, 100, 40)];
    [buttonConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [buttonConfirm setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    [buttonConfirm addTarget:self.pView action:@selector(textInputConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonConfirm];
}

-(void)textFieldResign:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end
