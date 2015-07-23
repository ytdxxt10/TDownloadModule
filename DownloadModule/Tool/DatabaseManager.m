//
//  DatabaseManager.m
//  DownloadModule
//
//  Created by offcn on 15/7/13.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager
+(instancetype)shareDataManager
{
    static DatabaseManager *dataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DatabaseManager alloc]init];
    });

    return dataManager;
}
-(void)createDatabase
{
 NSString *path=[NSString stringWithFormat:@"%@/Documents/DownloadInfo.sqlite",NSHomeDirectory()];

    _database = [FMDatabase databaseWithPath:path];
    if ([_database open]) {
        NSLog(@"create database success");
    }else{
    
        NSLog(@"create database failed");
    }

   BOOL isSucceed = [_database executeUpdate:@"create table if not exists info(id integer primary key, fileName text not null,count integer not null)"];
    if (isSucceed) {
        NSLog(@"create table success");
    }else{
    
        NSLog(@"create table success");
    }
    
}
-(void)insertFileName:(NSString *)fileName count:(NSInteger)count
{
    NSString *insertSql = [NSString stringWithFormat:@"insert into info(fileName,count) values ('%@','%ld');",fileName,(long)count];
    [_database executeUpdate:insertSql];

}
-(void)updateDataFileName:(NSString *)fileName count:(NSInteger)count
{
   
    NSString *moidify = [NSString stringWithFormat:@"update info set count=%ld where fileName='%@'",(long)count,fileName];
    [_database executeUpdate:moidify];
    
}
-(NSInteger)selectFileName:(NSString *)fileName count:(NSInteger)theCount
{
    FMResultSet *set = [_database executeQuery:@"select *from info where fileName=?",fileName];
    NSString *str=nil;
    while ([set next]) {
        str = [set stringForColumn:@"count"];
    }
    NSLog(@"testsss%@",str);
    return [str integerValue];
}
@end
