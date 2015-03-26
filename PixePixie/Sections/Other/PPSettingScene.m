
#import "PPSettingScene.h"

static NSString * monsterBtnTitle[] = {
    @"帮助",
    @"设置",
    @"图鉴",
    @"新闻"
};

@implementation PPSettingScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        [self addDefaultBackground];
        
        for (int i = 0; i < 4; i++) {
            
            
            PPSpriteButton * monsterButton = [PPSpriteButton buttonWithImageNamed:@"bt_normal"];
            monsterButton.size = CGSizeMake(200, 40);
            monsterButton.position = CGPointMake(160, i * 60 + 120);
            monsterButton.name = [NSString stringWithFormat:@"%d",i];
            [monsterButton addChild:[PPNodeTools getButtonDefault:monsterButton.size]];
            [monsterButton setLabelWithText:monsterBtnTitle[i] andFont:[UIFont systemFontOfSize:15.0]
                                  withColor:[UIColor blackColor]];
            [monsterButton addTarget:self selector:@selector(monsterButtonClick:)
                          withObject:monsterButton.name forControlEvent:PPButtonControlEventTouchUpInside];
            [self addChild:monsterButton];
            
//            SKLabelNode * btTitle = [SKLabelNode labelNodeWithText:monsterBtnTitle[i]];
//            btTitle.position = CGPointMake(160, i * 60 + 115);
//            btTitle.fontColor = [SKColor blackColor];
//            btTitle.fontSize = 15.0f;
//            [self addChild:btTitle];
        }
    }
    return self;
}

-(void)monsterButtonClick:(NSString *)name
{
    switch ([name intValue]) {
        case 0:
        {
            PPHelpScene * helpScene = [[PPHelpScene alloc] initWithSize:self.view.bounds.size];
            helpScene->previousScene = self;
            [self.view presentScene:helpScene];
        }
            break;
        case 1:
        {
            PPOptionsScene * optionScene = [[PPOptionsScene alloc] initWithSize:self.view.bounds.size];
            optionScene->previousScene = self;
            [self.view presentScene:optionScene];
        }
            break;
        case 2:
        {
            PPMonsterBookScene * monstorBookScene = [[PPMonsterBookScene alloc] initWithSize:self.view.bounds.size];
            monstorBookScene->previousScene = self;
            [self.view presentScene:monstorBookScene];
        }
            break;
        case 3:
        {
            PPNewsScene * newsScene = [[PPNewsScene alloc] initWithSize:self.view.bounds.size];
            newsScene->previousScene = self;
            [self.view presentScene:newsScene];
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
