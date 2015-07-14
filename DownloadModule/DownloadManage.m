//
//  DownloadManage.m
//  DownloadModule
//
//  Created by offcn on 15/6/24.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "DownloadManage.h"
#import "M3U8Handler.h"
#import "VideoDownloader.h"
#import "FileModel.h"
#import "AFNetworking.h"
#import "DatabaseManager.h"
@implementation DownloadManage

-(id)init{
    self = [super init];
    if (self) {
        _fileList=[[NSMutableArray alloc]init];
    }
    return self;
    
}
+(instancetype)shareDownloadManage
{
    static DownloadManage *downloadManage=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (downloadManage==nil) {
            downloadManage=[[DownloadManage alloc]init];
        }
    });
    return downloadManage;
}

-(void)downloadWithUrl:(NSString *)url fileName:(NSString *)fileName fileTitle:(NSString *)fileTitle
{
    _fileInfo = [[FileModel alloc]init];
    _fileInfo.fileName = fileName;
    _fileInfo.fileTitle = fileTitle;
    _fileInfo.fileURL = url;
    _fileInfo.downloadState = Downloading;
    NSString *targetPath=[CommonHelper getTargetPathWithBasepath:@"Downloads" subpath:nil];
    NSString *tempPath=[CommonHelper getTempFolderPathWithBasepath:nil];
    NSLog(@"thetargetPath%@",targetPath);
    targetPath=[targetPath stringByAppendingPathComponent:_fileInfo.fileName];
    tempPath = [tempPath stringByAppendingPathComponent:_fileInfo.fileName];
    [self saveFinished];
    if ([CommonHelper isExistFile:targetPath]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"文件已经存在，不需要重新下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([CommonHelper isExistFile:tempPath]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"文件已经存在，不需要重新下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已经加入下载队列中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
    
//           [self downloadFileWithUrl:_fileInfo.fileURL fileName:_fileInfo.fileName];
           [self startDownloadUrl:_fileInfo.fileURL fileName:_fileInfo.fileName fileTitle:_fileInfo.fileTitle];
        [[DatabaseManager shareDataManager]insertFileName:_fileInfo.fileName count:0];
    }



}
-(void)startDownloadUrl:(NSString*)strUrl fileName:(NSString *)aFileName fileTitle:(NSString *)aFileTitle
{
  
    M3U8Handler *handle=[[M3U8Handler alloc]init];
    [handle praseUrl:strUrl];

    handle.playlist.uuid=aFileName;
    _downloader.delegate=self;
    _downloader=[[VideoDownloader alloc]initWithM3U8List:handle.playlist];
    [self downloadFileWithUrl:strUrl fileName:aFileName];
    [_downloader handleIsCahingDownload];


}


-(void)downloadFileWithUrl:(NSString *)fileUrl fileName:(NSString *)aFileName
{
    
//    
//    AFURLSessionManager *manager1 = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
//    NSLog(@"request%@",fileUrl);
//    NSURLSessionDownloadTask *downloadTask = [manager1 downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        //告诉下载管理器, 保存文件的位
//        NSString * filePath = [NSString stringWithFormat:@"%@/Documents/Downloads/%@/%@.m3u8",NSHomeDirectory(),aFileName,aFileName];
//        NSLog(@"filePathxiao = %@",filePath);
//        return [NSURL fileURLWithPath:filePath];
//        
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"下载完成2");
//        //        NSString *fileName = [url lastPathComponent];
//        [self handleTheM3u8:aFileName];
//    }];
//    //启动下载任务
//    [downloadTask resume];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL*(NSURL *targetPath,NSURLResponse *response){
        NSString *path = [NSString stringWithFormat:@"%@/Documents/Downloads/%@/%@.m3u8",NSHomeDirectory(),aFileName,aFileName];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse *response,NSURL *filePath,NSError *error){
        [self handleTheM3u8:aFileName];
    
    
    }];
    [downloadTask resume];
    
    
}

-(void)handleTheM3u8:(NSString *)fileName
{
    NSMutableArray * mutArray =[[NSMutableArray alloc]init];
    NSString * path = [NSString stringWithFormat:@"%@/Documents/Downloads/%@/%@.m3u8",NSHomeDirectory(),fileName,fileName];
    NSLog(@"%@path",path);
//    NSString *string=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSString *string=[[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableString * string =[[NSMutableString alloc]initWithString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    
    NSInteger i =0;
    for (NSString * string2 in array){
        if([string2 hasPrefix:@"http://"]){
            NSString * fileString =[string2 lastPathComponent];
            NSRange  range = [string2 rangeOfString:fileString];
            NSMutableString * removeString =[NSMutableString stringWithString:string2];
            [removeString deleteCharactersInRange:range];
            
            NSMutableString * str  = [NSMutableString stringWithString:string2];
            [str deleteCharactersInRange:[str rangeOfString:removeString]];
            NSLog(@"str=%@",str);
            [mutArray addObject:str];
        }
        else if([string2 hasPrefix:@"#EXT-X-KEY"]){
            NSMutableString * string3 =[NSMutableString stringWithString:string2];
            NSRange range1 = [string3 rangeOfString:@"URI="];
            unsigned long location1 = range1.location+5;
            
            NSRange range2 = [string3 rangeOfString:@"IV="];
            unsigned long location2 = range2.location-2;
            
            NSRange rang = NSMakeRange(location1, location2-location1);
            //                NSString * strRang = [string2 substringWithRange:rang];
            
            NSString *str = [string3 stringByReplacingCharactersInRange:rang withString:[NSString stringWithFormat:@"%ld.key",i]];
            NSLog(@"str=%@",str);
            [mutArray addObject:str];
            i++;
        }
        else{
            [mutArray addObject:string2];
        }
    }
    NSString * str = [mutArray componentsJoinedByString:@""];
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];


}

-(void)videoDownloaderFailed:(VideoDownloader *)request
{




}
-(void)videoDownloaderFinished:(VideoDownloader *)request
{



}

-(void)saveFinished
{
    NSString *tempStr = [NSString stringWithFormat:@"%@/Documents/Downloads/finished.plist",NSHomeDirectory()];
    NSDictionary *tempDic=@{@"fileName":_fileInfo.fileName,@"fileTitle":_fileInfo.fileTitle};
    _fileList = [[NSMutableArray alloc]initWithContentsOfFile:tempStr];
    if (!_fileList) {
        _fileList = [[NSMutableArray alloc]init];
    }
    [self.fileList addObject:tempDic];
    if (![_fileList writeToFile:tempStr atomically:YES]) {
        NSLog(@"write plist failed");
    }

}
@end
