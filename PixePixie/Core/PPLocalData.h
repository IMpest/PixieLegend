
#import <Foundation/Foundation.h>

@interface PPLocalData : NSObject

-(PPLocalData *)getInstance;
+(NSString *)getUserInfoPath;

// json 数据转换
+(NSData *)directoryToJSONData:(NSDictionary *)dict;
+(NSDictionary *)JSONDataTodirectory:(NSData *)dict;

// UserDefault
+(id)contentFromUserDefaultKey:(NSString *) keyString;
+(void)setContent:(id)content forContentKey:(NSString *) keyString;

@end
