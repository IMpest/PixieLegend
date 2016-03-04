//
//  PEICloudHelp.m
//  PixieEndless
//
//  Created by xiefei on 15/4/28.
//  Copyright (c) 2015年 silver6wings. All rights reserved.
//

#import "PEICloudHelp.h"
#import "PEDocument.h"
#define kPEContainerIdentifier @"iCloud.com.cmjstudio.kctest" //容器id，可以从生产的entitiements文件中查看Ubiquity Container Identifiers（注意其中的$(CFBundleIdentifier)替换为BundleID）

@interface PEICloudHelp()
{
    
}
@property (strong,nonatomic) PEDocument *document;//当前选中的管理对象
@property (strong,nonatomic) NSMutableDictionary *files; //现有文件名、创建日期集合
@property (strong,nonatomic) NSMetadataQuery *dataQuery;//数据查询对象，用于查询iCloud文档
@end

@implementation PEICloudHelp
#pragma mark - 属性
-(NSMetadataQuery *)dataQuery{
    if (!_dataQuery) {
        //创建一个iCloud查询对象
        _dataQuery=[[NSMetadataQuery alloc]init];
        _dataQuery.searchScopes=@[NSMetadataQueryUbiquitousDocumentsScope];
        //注意查询状态是通过通知的形式告诉监听对象的
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryFinish:) name:NSMetadataQueryDidFinishGatheringNotification object:_dataQuery];//数据获取完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryFinish:) name:NSMetadataQueryDidUpdateNotification object:_dataQuery];//查询更新通知
    }
    return _dataQuery;
}
#pragma mark - 私有方法
/**
 *  取得云端存储文件的地址
 *
 *  @param fileName 文件名，如果文件名为nil则重新创建一个url
 *
 *  @return 文件地址
 */
-(NSURL *)getUbiquityFileURL:(NSString *)fileName{
    //取得云端URL基地址(参数中传入nil则会默认获取第一个容器)
    NSURL *url= [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:kPEContainerIdentifier];
    //取得Documents目录
    url=[url URLByAppendingPathComponent:@"Documents"];
    //取得最终地址
    url=[url URLByAppendingPathComponent:fileName];
    return url;
}

/**
 *  添加文档到iCloud
 *
 *  @param fileName 文件名称（不包括后缀）
 */
-(void)addDocument:(NSString *)fileName{
    //取得保存URL
    fileName=[NSString stringWithFormat:@"%@.txt",fileName];
    NSURL *url=[self getUbiquityFileURL:fileName];
    
    NSLog(@"fileName=%@",fileName);
    
    
    /**
     创建云端文档操作对象
     */
    PEDocument *document= [[PEDocument alloc]initWithFileURL:url];
    [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"保存成功.");
            [self loadDocuments];
            self.document=document;
        }else{
            NSLog(@"保存失败.");
        }
        
    }];
}
/**
 *  加载文档列表
 */
-(void)loadDocuments{
    [self.dataQuery startQuery];
}
/**
 *  获取数据完成后的通知执行方法
 *
 *  @param notification 通知对象
 */
-(void)metadataQueryFinish:(NSNotification *)notification{
    NSLog(@"数据获取成功！");
    NSArray *items=self.dataQuery.results;//查询结果集
    self.files=[NSMutableDictionary dictionary];
    //变量结果集，存储文件名称、创建日期
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMetadataItem *item=obj;
        NSString *fileName=[item valueForAttribute:NSMetadataItemFSNameKey];
        NSDate *date=[item valueForAttribute:NSMetadataItemFSContentChangeDateKey];
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        dateformate.dateFormat=@"YY-MM-dd HH:mm";
        NSString *dateString= [dateformate stringFromDate:date];
        [self.files setObject:dateString forKey:fileName];
    }];
}

-(void)removeDocument:(NSString *)fileName{
    NSURL *url=[self getUbiquityFileURL:fileName];
    NSError *error=nil;
    //删除文件
    [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (error) {
        NSLog(@"删除文档过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self.files removeObjectForKey:fileName];//从集合中删除
}


@end
