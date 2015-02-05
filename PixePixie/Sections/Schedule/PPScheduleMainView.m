

#import "PPScheduleMainView.h"

@implementation PPScheduleMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        PPScheduleScene * mainScene = [[PPScheduleScene alloc] initWithSize:self.bounds.size];
        mainScene.scaleMode = SKSceneScaleModeFill;
        [self presentScene:mainScene];
    }
    return self;
}


@end
