#import "PPLocalData.h"
#import <objc/runtime.h>

static PPLocalData * localData = nil;

@implementation PPLocalData

// 这里其实不加也没问题的
//@synthesize allSkillsInfo;

+(PPLocalData *)getInstance
{
    @synchronized(self){
        if (localData == nil) {
            localData = [[PPLocalData alloc] init];
            NSDictionary * pixiesInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PixiesInfo"
                                                                                                                   ofType:@"plist"]];
            NSDictionary * skillInfo = [pixiesInfo objectForKey:@"skills"];
            localData.allSkillsInfo = skillInfo;
        }
    }
    return localData;
}

//得到应用程序Documents文件夹下的目标路径
+(NSString *)getUserInfoPath
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Userinfo.plist"];
}

//
+(NSData *)directoryToJSONData:(NSDictionary *)dict
{
    if(class_getClassMethod([NSJSONSerialization class], @selector(dataWithJSONObject:options:error:)) == NULL){
        return nil;
    }
    NSError * error = nil;
    return  [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
}

//
+(NSDictionary *)JSONDataTodirectory:(NSData *)data
{
    if (class_getClassMethod([NSJSONSerialization class], @selector(JSONObjectWithData:options:error:)) == NULL){
        return  nil;
    }
    NSError * error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
}

//
+(id)contentFromUserDefaultKey:(NSString *)keyString
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    id content = [userDef objectForKey:keyString];
    return content;
}

//
+(void)setContent:(id)content forContentKey:(NSString *)keyString
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:content forKey:keyString];
}

//
-(void)filePathTest
{
    NSDictionary * dictPass =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSArray arrayWithObjects:
      [NSDictionary dictionaryWithObjectsAndKeys:@"副本1",@"passname",@"1234",@"passid",@"2013/11/11 00:00",@"passtime",@"ball_pixie_plant2",@"passimage", nil],
      [NSDictionary dictionaryWithObjectsAndKeys:@"副本2",@"passname",@"1234",@"passid",@"2013/11/11 00:00",@"passtime",@"ball_pixie_plant2",@"passimage", nil],
      [NSDictionary dictionaryWithObjectsAndKeys:@"副本3",@"passname",@"1234",@"passid",@"2013/11/11 00:00",@"passtime",@"ball_pixie_plant2",@"passimage", nil],
      [NSDictionary dictionaryWithObjectsAndKeys:@"副本4",@"passname",@"1234",@"passid",@"2013/11/11 00:00",@"passtime",@"ball_pixie_plant2",@"passimage", nil],
      nil],
     @"transcriptinfo",
     @"精灵大战",
     @"transcriptname",
     nil];
    
    if ([dictPass writeToFile:[[self getPersonalSetTargetPath] stringByAppendingPathComponent:@"userinfo.plist"] atomically:YES]) {
        NSLog(@"success!");
    } else {
        NSLog(@"fail！");
    }
    NSLog(@"getPersonalSetTargetPath = %@",[self getPersonalSetTargetPath]);
}

// 得到应用程序Documents文件夹下的目标路径
-(NSString *)getPersonalSetTargetPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cahcesPlist = [paths objectAtIndex:0];
    return cahcesPlist;
}

@end
