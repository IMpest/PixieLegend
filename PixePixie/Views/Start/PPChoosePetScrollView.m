

#import "PPChoosePetScrollView.h"

static NSString * typeString[] = {
    @"金",
    @"木",
    @"水",
    @"火",
    @"土"
};

@implementation PPChoosePetScrollView

int currentIndex;
NSArray * myPixies;

-(PPPixie *)getCurrentPixie
{
    return [myPixies objectAtIndex:currentIndex];
}

-(id)initWithFrame:(CGRect)frame
            Pixies:(NSArray *)pixies
{
    self = [super initWithFrame:frame];
    if (self) {
        
        currentIndex = 0;
        myPixies = pixies;
        
        self.pagingEnabled = YES;
        self.bounces = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(320 * [pixies count], self.frame.size.height);
        self.delegate = self;
        
        for (int i = 0; i < [pixies count]; i++) {
            
            PPPixie * tpixie = (PPPixie *)[pixies objectAtIndex:i];
        
            UIImageView * cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_pet_0"]];
            cardView.frame = CGRectMake(i * self.frame.size.width + 122, 0, 75, 200);
            [self addSubview:cardView];
            
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
            
            NSString * imgName = [NSString stringWithFormat: @"%@_card.png", [tpixie getTextureName]];
            UIImageView * petsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
            petsView.frame = CGRectMake(i * self.frame.size.width + 110, 40, 100, 100);
            [self addSubview:petsView];
            
            UILabel * petName = [[UILabel alloc] initWithFrame:CGRectMake(i * self.frame.size.width + 110, 170, 100, 20)];
            petName.textAlignment = NSTextAlignmentCenter;
            petName.text = tpixie.pixieName;
            [self addSubview:petName];
        }
    }
    return self;
}

-(void)petsNameBtnClick:(UIButton *)sender
{}

-(void)petsTypeBtnClick:(UIButton *)sender
{}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentIndex = (int)self.contentOffset.x/320;
    PPChoosePetView * tView = (PPChoosePetView *)self.superview;
    [tView.infoView updatePixie:[myPixies objectAtIndex:currentIndex]];
}

@end
