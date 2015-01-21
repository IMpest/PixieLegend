
#import <UIKit/UIKit.h>

@interface PPChoosePetScrollView : UIScrollView < UIScrollViewDelegate >

-(id)initWithFrame:(CGRect)frame
            Pixies:(NSArray *)pixies;

-(PPPixie *)getCurrentPixie;

@end
