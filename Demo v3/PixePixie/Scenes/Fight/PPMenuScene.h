@class PPFightingMainView;

@interface PPMenuScene : PPBasicScene
{
    @public
    PPFightingMainView * preiviousView; // 战斗主View
}

@property (nonatomic, retain) NSDictionary * passDictInfo;

-(id)initWithSize:(CGSize)size andElement:(PPElementType)elementType;

@end
