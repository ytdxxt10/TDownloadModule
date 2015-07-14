//
//  VideoDownloader.m
//  XB
//
//  Created by luoxubin on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoDownloader.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonHelper.h"
#import "DatabaseManager.h"
@implementation VideoDownloader
@synthesize totalprogress,playlist,delegate;


-(id)initWithM3U8List:(M3U8Playlist *)list
{
    self = [super init];
    if(self != nil)
    {
        self.playlist = list;
        totalprogress = 0.0;
    }
    return  self;
}
#pragma mark--download go & handle the first download sitiuation

-(void)startDownloadVideo
{
    NSString * path = [NSString stringWithFormat:@"%@/Documents/Downloads/%@",NSHomeDirectory(),self.playlist.uuid];
    NSLog(@"paht%@",path);
    NSString *fileName=[self.playlist.uuid componentsSeparatedByString:@"/"][1];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:self.playlist.uuid];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:fileName];
    }
    
    self.localDataArray=[[NSMutableArray alloc]init];
    self.keyUrlDataArray=[[NSMutableArray alloc]init];
    NSLog(@"start download video");
    
    NSLog(@"segment%ld",(long)self.playlist.length);
    //将其key文件和包文件分开，便于重新命名。
    for (int i=0; i<self.playlist.length; i++) {
        M3U8SegmentInfo* segment = [self.playlist getSegment:i];
        if (!segment.locationUrl) {
            continue;
        }
        if ([segment.locationUrl hasPrefix:@"http:"]) {
            [self.localDataArray addObject:segment.locationUrl];
        }else if([segment.locationUrl hasPrefix:@"https:"]){
            [self.keyUrlDataArray addObject:segment.locationUrl];
            
        }
    }
    [self downloadKeyFile];
    [self downloadpackageFile];

}
#pragma mark- download key file
-(void)downloadKeyFile
{
    //下载key文件，用AF下载，原先用ASI下载会发生bug;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [self.keyUrlDataArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:obj]];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSString* filename1 = [NSString stringWithFormat:@"%lu.key",(unsigned long)idx];
            
            //保存文件的位置
            
            NSString * path = [NSString stringWithFormat:@"%@/Documents/Downloads/%@/%@",NSHomeDirectory(),self.playlist.uuid,filename1];
            NSLog(@"pathhhaa = %@",path);
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"下载完成3");
            
        }];
        //启动下载任务
        [downloadTask resume];
        
    }];


}
#pragma mark -handle IsCaching download
-(void)handleIsCahingDownload
{

    NSString * path = [NSString stringWithFormat:@"%@/Documents/Downloads/%@",NSHomeDirectory(),self.playlist.uuid];
    NSLog(@"paht%@",path);
//    NSString *fileName=[self.playlist.uuid componentsSeparatedByString:@"/"][1];
    NSString *fileName=self.playlist.uuid;
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:self.playlist.uuid];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:fileName];
    }
    int count=[[[NSUserDefaults standardUserDefaults]objectForKey:fileName]intValue];
    NSLog(@"finenamee:%d count::%@",count,[[NSUserDefaults standardUserDefaults]objectForKey:self.playlist.uuid]);
    self.localDataArray=[[NSMutableArray alloc]init];
    self.keyUrlDataArray=[[NSMutableArray alloc]init];
    NSLog(@"start download video");
    
    NSLog(@"segment%ld",(long)self.playlist.length);
    //将其key文件和包文件分开，便于重新命名。
    for (int i=0; i<self.playlist.length; i++) {
        M3U8SegmentInfo* segment = [self.playlist getSegment:i];
//        NSLog(@"--keyUrl%@--",segment.locationUrl);
        if (!segment.locationUrl) {
            continue;
        }
        if ([segment.locationUrl hasPrefix:@"http:"]) {
            [self.localDataArray addObject:segment.locationUrl];
        }else if([segment.locationUrl hasPrefix:@"https:"]){
            [self.keyUrlDataArray addObject:segment.locationUrl];
            
        }
    }
    
    if (self.localDataArray.count==0) {
        return;
    }
    for (int i=0; i<count; i++) {
        
        if (self.localDataArray.count==0) {
            return;
        }
        [self.localDataArray removeObjectAtIndex:0];
    }
    NSLog(@"download%lu %d  %@",(unsigned long)self.localDataArray.count,count,self.playlist.uuid);
    [self downloadKeyFile];
    [self downloadAgainPackageFileCount:count];
    
}
#pragma mark 再次下载继续从上次下载的位置开始下载。
-(void)downloadAgainPackageFileCount:(int)thecount
{
    if (downloadArray==nil) {
        downloadArray=[[NSMutableArray alloc]init];
        for (int i=thecount; i<self.localDataArray.count+thecount; i++) {
            NSString *fileName=nil;
            if (i>=0&i<=9) {
                fileName = [NSString stringWithFormat:@"0000%d.zg",i];
            }else if(i>=10&&i<=99){
                
                fileName=[NSString stringWithFormat:@"000%d.zg",i];
            }else{
                
                fileName=[NSString stringWithFormat:@"00%d.zg",i];
            }
            //可能存在一个小问题，（会发生丢掉一个包得情况，但并不影响播放，因此暂时不修改，有时间再改啊）
            NSString* segment = [self.localDataArray objectAtIndex:(i-thecount)];
            SegmentDownloader* sgDownloader = [[SegmentDownloader alloc]initWithUrl:segment andFilePath:self.playlist.uuid andFileName:fileName];
            sgDownloader.delegate = self;
            [downloadArray addObject:sgDownloader];
            sgDownloader = nil;
        }
    }
//
//    NSString *downStr=[NSString stringWithFormat:@"%lu",(unsigned long)downloadArray.count];
//    [[NSUserDefaults standardUserDefaults]setObject:downStr forKey:self.playlist.uuid];
    for (SegmentDownloader *obj in downloadArray) {
        [obj start];
    }

}
# pragma mark-download package file
-(void)downloadpackageFile
{
    
    //对包文件进行命名
    if(downloadArray == nil)
    {
        downloadArray = [[NSMutableArray alloc]init];
        NSLog(@"segmentcount%lu",(unsigned long)self.localDataArray.count);
        for(int i = 0;i< self.localDataArray.count;i++)
        {
            NSString *filename=nil;
            if (i>=0&i<=9) {
                filename = [NSString stringWithFormat:@"0000%d.zg",i];
            }else if(i>=10&&i<=99){
                
                filename=[NSString stringWithFormat:@"000%d.zg",i];
            }else{
                
                filename=[NSString stringWithFormat:@"00%d.zg",i];
            }
            NSString* segment = [self.localDataArray objectAtIndex:i];
            SegmentDownloader* sgDownloader = [[SegmentDownloader alloc]initWithUrl:segment andFilePath:self.playlist.uuid andFileName:filename];
            sgDownloader.delegate = self;
            [downloadArray addObject:sgDownloader];
            sgDownloader = nil;
        }
        
        
        
    }

    NSString *downStr=[NSString stringWithFormat:@"%lu",(unsigned long)downloadArray.count];
    [[NSUserDefaults standardUserDefaults]setObject:downStr forKey:self.playlist.uuid];
    for(SegmentDownloader* obj in downloadArray)
    {
        
        [obj start];
        
    }
    bDownloading = YES;


}
-(void)cleanDownloadFiles
{
    NSLog(@"cleanDownloadFiles");
    
  
    for(int i = 0;i< self.playlist.length;i++)
    {
        NSString* filename = [NSString stringWithFormat:@"id%d",i];
        NSString* tmpfilename = [filename stringByAppendingString:kTextDownloadingFileSuffix];
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *savePath = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.playlist.uuid];
        NSString* fullpath = [savePath stringByAppendingPathComponent:filename];
        NSString* fullpath_tmp = [savePath stringByAppendingPathComponent:tmpfilename];
    
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:fullpath]) {
            NSError *removeError = nil;
            [fileManager removeItemAtPath:fullpath error:&removeError];
            if (removeError) 
            {
                 NSLog(@"delete file=%@ err, err is %@",fullpath,removeError);
            }
        }

        if ([fileManager fileExistsAtPath:fullpath_tmp]) {
            NSError *removeError = nil;
            [fileManager removeItemAtPath:fullpath_tmp error:&removeError];
            if (removeError) 
            {
                NSLog(@"delete file=%@ err, err is %@",fullpath_tmp,removeError);
            }
        }

    }
    
}


-(void)stopDownloadVideo
{
    
    bDownloading=1;
    if(bDownloading && downloadArray != nil)
    {
        for(SegmentDownloader *obj in downloadArray)
        {
            [obj stop];
        }
        bDownloading = NO;
    }
}
#pragma mark CancelDownload
-(void)cancelDownloadVideo
{
    NSLog(@"down%@",downloadArray);

    NSLog(@"cancel download video");
    if(bDownloading && downloadArray != nil)
    {
        for(SegmentDownloader *obj in downloadArray)
        {
            [obj clean];
        }
    }
    [self cleanDownloadFiles];
}


-(void)dealloc
{
    playlist = nil;
    delegate = nil;
    [downloadArray removeAllObjects];
    downloadArray = nil;
}


#pragma mark - SegmentDownloadDelegate
-(void)segmentDownloadFailed:(SegmentDownloader *)request
{
    NSLog(@"a segment Download Failed");
    
    if(delegate && [delegate respondsToSelector:@selector(videoDownloaderFailed:)])
    {
        [delegate videoDownloaderFailed:self];
    }
}
#pragma mark -download finished
-(void)segmentDownloadFinished:(SegmentDownloader *)request
{
//    NSString *fileName=[self.playlist.uuid componentsSeparatedByString:@"/"][1];
    NSString *fileName=self.playlist.uuid;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:fileName]) {
        _count=[[[NSUserDefaults standardUserDefaults]objectForKey:fileName] intValue];
        _count++;
    }
    NSLog(@"a segment Download Finished");
   NSInteger count = [[DatabaseManager shareDataManager]selectFileName:fileName count:0];
    count =count +1;
    [[DatabaseManager shareDataManager]updateDataFileName:fileName count:count];
    NSLog(@"fileName:%@ _count:%d",fileName,_count);
//    NSLog(@"downloadArray%@",downloadArray);
//    _count++;
    

    NSString *str=[NSString stringWithFormat:@"%d",_count];
//    NSString *fileName=[self.playlist.uuid componentsSeparatedByString:@"/"][1];
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:fileName];
    
    NSLog( @"sstr%@ -%@-",str,fileName);
//    }
//    [dic enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop){
//    
//    
//    
//    }];
//        NSLog(@"print plist path%@",plistpath);
    //passvalue for caculate the progress
//    if ([self.delegate respondsToSelector:@selector(passValue:completeValue:)]) {
//        [self.delegate passValue:self.count completeValue:downloadArray.count+self.count];
//        NSLog(@"hahak%d",self.count);
//    }
    [downloadArray removeObject:request];
    NSLog(@" downarray2%lu",(unsigned long)downloadArray.count);
    if([downloadArray count] == 0)
    {
        totalprogress = 1;
        NSLog(@"all the segments downloaded. video download finished");
        if(delegate && [delegate respondsToSelector:@selector(videoDownloaderFinished:)])
        {
           [delegate videoDownloaderFinished:self];
        }
    }    
}



@end
