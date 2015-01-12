

#import "PPChoosePetScrollView.h"

static NSString *typeString[]={
    @"金",
    @"木",
    @"水",
    @"火",
    @"土"
};

@implementation PPChoosePetScrollView

-(id)initWithFrame:(CGRect)frame
            Pixies:(NSArray *)pixies
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(320 * [pixies count], self.frame.size.height);
        
        NSLog(@"%d", [pixies count]);
        
        for (int i = 0; i < [pixies count]; i++) {
            
            PPPixie * tpixie = (PPPixie *)[pixies objectAtIndex:i];
        
            UIImageView * petsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pet_card"]];
            petsImageView.frame = CGRectMake(i * self.frame.size.width+110, 20, 100, 200);
            [self addSubview:petsImageView];
            
            UIButton * petsTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            switch (tpixie.pixieElement) {
                case PPElementTypeMetal:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_metal.png"] forState:UIControlStateNormal];
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_metal.png"] forState:UIControlStateSelected];
                }
                    break;
                case PPElementTypePlant:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_plant.png"] forState:UIControlStateNormal];
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_plant.png"] forState:UIControlStateHighlighted];
                }
                    break;
                case PPElementTypeWater:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_water.png"] forState:UIControlStateNormal];
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_water.png"] forState:UIControlStateHighlighted];
                }
                    break;
                case PPElementTypeFire:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_fire.png"] forState:UIControlStateNormal];
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_fire.png"] forState:UIControlStateHighlighted];
                }
                    break;
                case PPElementTypeEarth:
                {
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_earth.png"] forState:UIControlStateNormal];
                    [petsTypeBtn setImage:[UIImage imageNamed:@"element_earth.png"] forState:UIControlStateHighlighted];
                }
                    break;
                    
                default:
                    break;
            }
            
            [petsTypeBtn setFrame:CGRectMake(i * self.frame.size.width + 110, 100, 40, 40)];
            [petsTypeBtn addTarget:self action:@selector(petsTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:petsTypeBtn];
            
            UIButton * petsNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [petsNameBtn setTitle:tpixie.pixieName forState:UIControlStateNormal];
            [petsNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [petsNameBtn setBackgroundImage:[UIImage imageNamed:@"pet_name"] forState:UIControlStateNormal];
            [petsNameBtn setFrame:CGRectMake(i * self.frame.size.width + 110, 10, 100, 40)];
            [petsNameBtn addTarget:self action:@selector(petsNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:petsNameBtn];
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

@end
