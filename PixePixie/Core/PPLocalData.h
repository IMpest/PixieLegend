
@class PPPixie;

@interface PPLocalData : NSObject

// 公共数据
@property (nonatomic, retain) PPPixie *firstPixie;
@property (nonatomic, retain) NSDictionary *allSkillsInfo;

// 单例方法
+(PPLocalData *)getInstance;
+(NSString *)getUserInfoPath;

// JSON 数据转换
+(NSData *)directoryToJSONData:(NSDictionary *)dict;
+(NSDictionary *)JSONDataTodirectory:(NSData *)dict;

// UserDefault
+(id)contentFromUserDefaultKey:(NSString *)keyString;
+(void)setContent:(id)content forContentKey:(NSString *)keyString;

@end
