

#import "PPScheduleScene.h"

static NSString * activityTitle[] = {
    @"每日日常",
    @"每日抽奖",
    @"神秘转轮",
    @"活动图标",
    @"活动图标"
};


@implementation PPScheduleScene

-(id)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        
        [self addDefaultBackground];
        
        for (int i = 0; i < 5; i++) {
            
            SKSpriteNode * activityBarContent = [[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(280, 50)];
            activityBarContent.position = CGPointMake(160, 60 * i + 60);
            
            SKLabelNode * labalTitle = [[SKLabelNode alloc] init];
            labalTitle.fontSize = 12;
            [labalTitle setText:activityTitle[i]];
            [labalTitle setPosition:CGPointMake(-100, 0)];
            [activityBarContent addChild:labalTitle];
            
            SKLabelNode * labalContent = [[SKLabelNode alloc] init];
            labalContent.fontSize = 12;
            [labalContent setText:@"活动信息"];
            [labalContent setPosition:CGPointMake(0, 0)];
            [activityBarContent addChild:labalContent];
            
            PPSpriteButton *joinButton = [PPSpriteButton buttonWithImageNamed:@"bt_normal"];
            joinButton.size = CGSizeMake(40, 40);
            joinButton.position = CGPointMake(100, 0);
            joinButton.name = [NSString stringWithFormat:@"%d",i];
            [joinButton setLabelWithText:@"GO" andFont:[UIFont systemFontOfSize:15] withColor:[UIColor blackColor]];
            [joinButton addTarget:self selector:@selector(joinButtonClick:)
                       withObject:joinButton.name forControlEvent:PPButtonControlEventTouchUpInside];
            [activityBarContent addChild:joinButton];
            
            [self addChild:activityBarContent];
        }
    }
    return self;
}

-(void)joinButtonClick:(NSString *)backName
{
    PPActivityDetailScene * activityDetail = [[PPActivityDetailScene alloc] initWithSize:self.view.bounds.size];
    activityDetail->previousScene = self;
    [self.view presentScene:activityDetail];
}

-(void)backButtonClick:(NSString *)backName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PP_BACK_TO_MAIN_VIEW object:nil];
}

@end
