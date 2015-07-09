//
//  VideoDownloader.h
//  XB
//
//  Created by luoxubin on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SegmentDownloader.h"
#import "M3U8Playlist.h"

@protocol passvalueDelegate <NSObject>

-(void)passValue:(NSInteger)value completeValue:(NSInteger)completevalue;


@end
@interface VideoDownloader : NSObject<SegmentDownloadDelegate>
{
    NSMutableArray *downloadArray;
    M3U8Playlist* playlist;
    float totalprogress;
    id<VideoDownloadDelegate> delegate;
    BOOL bDownloading;
}

@property(nonatomic,strong)NSString *fileName;
@property(nonatomic,retain)id<VideoDownloadDelegate> delegate;
@property (nonatomic,assign)id<passvalueDelegate>valuedelegate;
@property(nonatomic,retain)M3U8Playlist* playlist;
@property(nonatomic,assign)float totalprogress;
@property (nonatomic,strong) NSMutableArray *localDataArray;
@property (nonatomic,strong) NSMutableArray *keyUrlDataArray;
@property (nonatomic,assign) int count;

-(id)initWithM3U8List:(M3U8Playlist*)list;

//开始下载
-(void)startDownloadVideo;

//暂停下载
-(void)stopDownloadVideo;

//取消下载，而且清除下载的部分文件
-(void)cancelDownloadVideo;

-(NSString*)createLocalM3U8file;

//handle isCaching downLoad
-(void)handleIsCahingDownload;

@end
