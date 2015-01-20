

#import "PPChoosePetScrollView.h"

static NSString * typeString[] = {
    @"金",
    @"木",
    @"水",
    @"火",
    @"土"
};

@implementation PPChoosePetScrollView

NSArray * myPixies;

-(id)initWithFrame:(CGRect)frame
            Pixies:(NSArray *)pixies
{
    self = [super initWithFrame:frame];
    if (self) {
        
        myPixies = pixies;
        
        self.pagingEnabled = YES;
        self.bounces = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(320 * [pixies count], self.frame.size.height);
        self.delegate = self;
        
        for (int i = 0; i < [pixies count]; i++) {
            
            PPPixie * tpixie = (PPPixie *)[pixies objectAtIndex:i];
        
            UIImageView * petsImageView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageNamed:[NSString stringWithFormat: @"bg_pet_%d", i]]];
            petsImageView.frame = CGRectMake(i * self.frame.size.width + 122, 0, 75, 200);
            [self addSubview:petsImageView];
            
            UIButton * petsTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [petsTypeBtn setFrame:CGRectMake(i * self.frame.size.width + 165, 0, 40, 40)];
            [petsTypeBtn addTarget:self action:@selector(petsTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            switch (tpixie.pixieElement) {
                case PPElementTypeMetal:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_metal.png"] forState:UIControlStateNormal];
                }
                    break;
                case PPElementTypePlant:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_plant.png"] forState:UIControlStateNormal];
                }
                    break;
                case PPElementTypeWater:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_water.png"] forState:UIControlStateNormal];
                }
                    break;
                case PPElementTypeFire:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_fire.png"] forState:UIControlStateNormal];
                }
                    break;
                case PPElementTypeEarth:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_earth.png"] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
            [self addSubview:petsTypeBtn];
            
//            UIButton * petsNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [petsNameBtn setTitle:tpixie.pixieName forState:UIControlStateNormal];
//            [petsNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [petsNameBtn setBackgroundImage:[UIImage imageNamed:@"pet_name"] forState:UIControlStateNormal];
//            [petsNameBtn setFrame:CGRectMake(i * self.frame.size.width + 110, 10, 100, 40)];
//            [petsNameBtn addTarget:self action:@selector(petsNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:petsNameBtn];
        }
    }
    return self;
}

-(void)petsNameBtnClick:(UIButton *)sender
{
}

-(void)petsTypeBtnClick:(UIButton *)sender
{
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int num = (int)self.contentOffset.x/320;
    PPChoosePetView * tView = (PPChoosePetView *)self.superview;
    [tView.infoView updatePixie:[myPixies objectAtIndex:num]];
}

@end
