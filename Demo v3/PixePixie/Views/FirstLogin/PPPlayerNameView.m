

#import "PPPlayerNameView.h"

@implementation PPPlayerNameView

-(void)layoutSubviews
{
    
    PPInfoView * alert = [[PPInfoView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
    [self addSubview:alert];
    
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
    [buttonConfirm setFrame:CGRectMake(110, 230, 100, 40)];
    [buttonConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [buttonConfirm setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    [buttonConfirm addTarget:self.rootVC action:@selector(textInputConfirmClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonConfirm];
}

-(void)textFieldResign:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end
