
#import "PPOthersMainView.h"

@implementation PPOthersMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        PPSettingScene * mainScene = [[PPSettingScene alloc] initWithSize:self.bounds.size];
        mainScene.scaleMode = SKSceneScaleModeFill;
        [self presentScene:mainScene];
    }
    return self;
}


@end
