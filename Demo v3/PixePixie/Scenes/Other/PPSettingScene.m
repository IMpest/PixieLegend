
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
            
            PPSpriteButton * btOption = [PPSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(200, 40)];
            btOption.position = CGPointMake(160, i * 60 + 120);
            btOption.name = [NSString stringWithFormat:@"%d",i];
            [btOption addChild:[PPNodeTools getButtonDefault:btOption.size]];
            [btOption setLabelWithText:monsterBtnTitle[i] andFont:[UIFont systemFontOfSize:15.0]
                                  withColor:[UIColor blackColor]];
            [btOption addTarget:self selector:@selector(btOptionClick:)
                          withObject:btOption.name forControlEvent:PPButtonControlEventTouchUpInside];
            [self addChild:btOption];
            
        }
    }
    return self;
}

-(void)btOptionClick:(NSString *)name
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
