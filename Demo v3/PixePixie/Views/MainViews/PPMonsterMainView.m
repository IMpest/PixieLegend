
#import "PPMonsterMainView.h"

@implementation PPMonsterMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        monsterScene = [[PPMonsterScene alloc] initWithSize:self.bounds.size];
        monsterScene.scaleMode = SKSceneScaleModeFill;
        [self presentScene:monsterScene];
    }
    return self;
}

-(void)hideMonstorShowBtns
{
    [monsterScene hideShowbtns];
}

@end
