
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
typedef enum {
		Downloading,
		WillDownload,
		StopDownload
}DownLoadState;
@interface FileModel : NSObject {
    
}

@property(nonatomic,retain)NSString *fileID;
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *fileSize;
@property(nonatomic,retain)NSString *fileType;
// 0:@"Video" ;1:@"Audio";2:@"Image";3:@"File"4:Record

@property(nonatomic)BOOL isFirstReceived;//是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加
@property(nonatomic,retain)NSString *fileReceivedSize;
@property(nonatomic,retain)NSMutableData *fileReceivedData;//接受的数据
@property(nonatomic,retain)NSString *fileURL;
@property(nonatomic,retain)NSString *time;
@property(nonatomic,retain)NSString *targetPath;
@property(nonatomic,retain)NSString *tempPath;
@property(nonatomic,retain)NSString *downloadcount;
/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载

当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
可以主动切换下载状态
所有任务以添加时间排序。
*/
@property DownLoadState downloadState;
@property(nonatomic)BOOL error;
@property(nonatomic,retain)NSString *MD5;
@property(nonatomic,retain)UIImage *fileimage;
@property(nonatomic,copy)NSString *fileTitle;
@property(nonatomic,copy)NSString *courseTitle;

@end
