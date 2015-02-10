

@interface PPBasicScene : SKScene
{
    @public
    id target;
    SEL backBtnSel;
    SKScene * previousScene;
}

-(void)addDefaultBackground;
-(void)addTitle:(NSString *)title;
-(void)addTitle:(NSString *)title andBackButton:(CGFloat)yPostion;

@end
