
//@class PPMenuThemeScene;
@class PPRootViewController;
@interface PPFightingMainView : SKView
{
    @public
    PPRootViewController *rootViewControl;
    
}

//添加世界大地图
-(void)setMenuContentScrollView;
-(void)fullScreenForBattleScene;
-(void)normalScreenForMenu;

-(void)changeToPassScene;


@end
