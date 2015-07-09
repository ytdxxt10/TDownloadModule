//
//  DownloadManage.h
//  DownloadModule
//
//  Created by offcn on 15/6/24.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadDelegate.h"
@class VideoDownloader,FileModel,VideoDownloader;
@interface DownloadManage : NSObject<UIAlertViewDelegate,VideoDownloadDelegate>

@property (nonatomic,strong) VideoDownloader *downloader;
@property (nonatomic,strong) FileModel *fileInfo;
@property (nonatomic,strong) NSString *targetPath;
@property (nonatomic,strong) NSString *tempPath;
@property (nonatomic,strong) NSMutableArray *fileList;

+(instancetype)shareDownloadManage;
//下载时获取的信息
-(void)downloadWithUrl:(NSString *)url fileName:(NSString *)fileName fileTitle:(NSString *)fileTitle;
//开始下载
-(void)startDownloadUrl:(NSString*)strUrl fileName:(NSString *)aFileName fileTitle:(NSString *)aFileTitle;
@end
