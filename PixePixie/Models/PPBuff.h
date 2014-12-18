
// buff名称
static NSString * kBuffNameList[10] ={
    @"none",
    @"fire_burn",  //buffid  1为灼烧
    @"plant_root", //buffid  2为缠绕
    @"stone"
};

// buff类型定义
typedef NS_ENUM(NSInteger, PPBuffUniversalType){
    PPBuffTypeAttackAddition = 0,              // 伤害加成
};

// buff作用归类定义
typedef NS_ENUM(NSInteger, PPBuffFunction){
    PPBuffFunctionBenefit = 0,              // 伤害加成
};


@interface PPBuff : NSObject

@property (nonatomic, retain) NSString * buffName;   // buff名称
@property (nonatomic, retain) NSString * buffId;     // buff的id标识
@property (nonatomic, retain) NSString * buffEffect; // 特效名称

@property (nonatomic, assign) int continueRound;     // 持续回合

@property (nonatomic, assign) NSInteger cdRoundsAttAdd;  //伤害加成回合数
@property (nonatomic, assign) NSInteger cdRoundsDefAdd;  //防御加成回合数
@property (nonatomic, assign) CGFloat attackAddition;    //伤害加成
@property (nonatomic, assign) CGFloat defenseAddition;   //防御加成

@end
