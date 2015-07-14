//
//  DatabaseManager.h
//  DownloadModule
//
//  Created by offcn on 15/7/13.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface DatabaseManager : NSObject
@property (nonatomic,strong) FMDatabase *database;
+(instancetype)shareDataManager;
//创建数据库和表格
-(void)createDatabase;
//插入内容
-(void)insertFileName:(NSString *)fileName count:(NSInteger)count;
//更新count
-(void)updateDataFileName:(NSString *)fileName count:(NSInteger)count;

-(NSInteger)selectFileName:(NSString *)fileName count:(NSInteger)theCount;
@end
