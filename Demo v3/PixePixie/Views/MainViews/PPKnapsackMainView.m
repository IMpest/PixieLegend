
#import "PPKnapsackMainView.h"

@implementation PPKnapsackMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        PPPacksackScene * mainScene = [[PPPacksackScene alloc] initWithSize:self.bounds.size];
        mainScene.scaleMode = SKSceneScaleModeFill;
        [self presentScene:mainScene];
    }
    return self;
}

@end
