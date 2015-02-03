
#import "PPMonsterScene.h"

static NSString * monsterBtnTitle[] = {
    @"变卖",
    @"强化",
    @"天赋"
};

@implementation PPMonsterScene

BOOL menuIsHidden;

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        // 添加背景
        SKSpriteNode * bgImg = [[SKSpriteNode alloc] initWithImageNamed:@"theme_forest.png"];
        bgImg.size = CGSizeMake(320, 392);
        bgImg.position = CGPointMake(160, 196);
        [self addChild:bgImg];
        
        // 宠物信息
        PPMonsterInfoNode * monsterInfo = [[PPMonsterInfoNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(320, 260)];
        [monsterInfo initMonsterInfo:[PPLocalData getInstance].firstPixie];
        monsterInfo.position = CGPointMake(160, 170);
        [self addChild:monsterInfo];
        
        // 上方按钮
        PPSpriteButton * feedFromFriendButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(120.0f, 30.0f)];
        [feedFromFriendButton setLabelWithText:@"有朋友给你的宠物喂食了!" andFont:[UIFont systemFontOfSize:10] withColor:nil];
        feedFromFriendButton.position = CGPointMake(60.0f,360.0f);
        feedFromFriendButton.name = @"";
        [feedFromFriendButton addTarget:self selector:@selector(feedButtonClick:)
                             withObject:feedFromFriendButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:feedFromFriendButton];
        
        PPSpriteButton * removeToGroupBtn = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(80, 30.0f)];
        [removeToGroupBtn setLabelWithText:@"remove to Group" andFont:[UIFont systemFontOfSize:10] withColor:nil];
        removeToGroupBtn.position = CGPointMake(feedFromFriendButton.position.x+120,feedFromFriendButton.position.y);
        removeToGroupBtn.name = @"removeFromGroupBtn";
        [removeToGroupBtn addTarget:self selector:@selector(removeToGroupBtnClick:)
                         withObject:feedFromFriendButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:removeToGroupBtn];
        
        PPSpriteButton * worldBossButton = [PPSpriteButton buttonWithColor:[UIColor orangeColor] andSize:CGSizeMake(60.0f, 30.0f)];
        [worldBossButton setLabelWithText:@"world boss" andFont:[UIFont systemFontOfSize:10] withColor:nil];
        worldBossButton.position = CGPointMake(160.0f+feedFromFriendButton.size.width/2.0f+50.0f,feedFromFriendButton.position.y);
        worldBossButton.name = @"";
        [worldBossButton addTarget:self selector:@selector(worldBossButtonClick:)
                        withObject:feedFromFriendButton.name forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:worldBossButton];
        
        // 侧边菜单
        menuIsHidden = YES;
        
        PPSpriteButton * showMonsterBtn = [PPSpriteButton buttonWithImageNamed:@"bt_detail.png"];
        showMonsterBtn.name = @"pixieMenu";
        showMonsterBtn.size = CGSizeMake(25, 50);
        showMonsterBtn.position = CGPointMake(22,180);
        [showMonsterBtn addTarget:self selector:@selector(showMonsterBtnClick:)
                       withObject:showMonsterBtn forControlEvent:PPButtonControlEventTouchUpInside];
        [self addChild:showMonsterBtn];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
}

- (void)willMoveFromView:(SKView *)view
{
    [self hideShowbtns];
}

// 子菜单
-(void)showMonsterBtnClick:(PPSpriteButton *)showBtn
{
    if (menuIsHidden) {
        for (int i = 0; i < 3; i++) {
            PPSpriteButton * monsterButton = [PPSpriteButton buttonWithImageNamed:@"bt_menu.png"];
            monsterButton.position = CGPointMake(160,i * 100 + 80);
            monsterButton.size = CGSizeMake(150, 60);
            monsterButton.name = [NSString stringWithFormat:@"%d",i];
            [monsterButton setLabelWithText:monsterBtnTitle[i]
                                    andFont:[UIFont systemFontOfSize:15] withColor:[UIColor blackColor]];
            [monsterButton addTarget:self selector:@selector(monsterButtonClick:)
                          withObject:monsterButton.name forControlEvent:PPButtonControlEventTouchUpInside];
            [self addChild:monsterButton];
        }
        menuIsHidden = NO;
    } else {
        [self hideShowbtns];
    }
}

-(void)hideShowbtns
{
    PPSpriteButton * btn = (PPSpriteButton *)[self childNodeWithName:@"pixieMenu"];
    btn.color = [UIColor orangeColor];
    for (int i = 0; i < 3; i++) {
        SKNode * monsterButton = [self childNodeWithName:[NSString stringWithFormat:@"%d",i]];
        [monsterButton removeFromParent];
    }
    menuIsHidden = YES;
}

-(void)feedButtonClick:(NSString *)nameString
{
}

-(void)removeToGroupBtnClick:(NSString *)nameString
{
}

-(void)worldBossButtonClick:(NSString *)nameString
{
}

-(void)monsterButtonClick:(NSString *)name
{
    switch ([name intValue]) {
        case 0:
        {
            PPSellMonsterScene * sellMonster = [[PPSellMonsterScene alloc] initWithSize:self.view.frame.size];
            sellMonster->previousScene = self;
            [self.view presentScene:sellMonster];
        }
            break;
        case 1:
        {
            PPEuoFusionScene * euoFusion = [[PPEuoFusionScene alloc] initWithSize:self.view.frame.size];
            euoFusion->previousScene = self;
            [self.view presentScene:euoFusion];
        }
            break;
        case 2:
        {
            PPTalentTreeScene * talentTree = [[PPTalentTreeScene alloc] initWithPixie:[PPLocalData getInstance].firstPixie];
            talentTree.size = self.view.frame.size;
            talentTree->previousScene = self;
            [self.view presentScene:talentTree];
        }
            break;
            
        default:
            break;
    }
}

-(void)backButtonClick:(NSString *)backName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PP_BACK_TO_MAIN_VIEW object:nil];
}


@end
