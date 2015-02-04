
// 球类型定义
typedef NS_ENUM(NSInteger, PPPixieActionType)
{
    PPPixieActionTypeNone = 0,
    PPPixieActionTypeStand,
    PPPixieActionTypeRun,
};


@interface PPMonsterInfoNode : SKSpriteNode

-(void)initMonsterInfo:(PPPixie *)pixie;

@end
