//
//  DownloadObjectDelegate.h
//  XB
//
//  Created by luoxubin on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
@class ASIHTTPRequest;
@class SegmentDownloader;
@protocol SegmentDownloadDelegate <NSObject>
@optional
-(void)segmentDownloadFinished:(SegmentDownloader *)request;
-(void)segmentDownloadFailed:(SegmentDownloader *)request;

@end


@class VideoDownloader;
@protocol VideoDownloadDelegate <NSObject>
@optional
-(void)videoDownloaderFinished:(VideoDownloader*)request;
-(void)videoDownloaderFailed:(VideoDownloader*)request;

-(void)passValue:(float)value completeValue:(float)completevalue;

//传值，计算进度
@end

@protocol DownloadDelegate <NSObject>

-(void)startDownload:(ASIHTTPRequest *)request;
-(void)updateCellProgress:(ASIHTTPRequest *)request;
-(void)finishedDownload:(ASIHTTPRequest *)request;
-(void)allowNextRequest;//处理一个窗口内连续下载多个文件且重复下载的情况
@end
