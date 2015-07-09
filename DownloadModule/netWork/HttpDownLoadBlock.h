

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HttpDownLoadBlock : NSObject<NSURLConnectionDataDelegate>
@property(nonatomic,retain)NSURLConnection*connection;
@property(nonatomic,retain)NSMutableData*data;
//缓存目录地址
@property(nonatomic,copy)NSString*pathFile;
//解析后的结果
@property(nonatomic,retain)NSArray*dataArray;
@property(nonatomic,retain)NSDictionary*dataDict;
@property(nonatomic,retain)UIImage*dataImage;

//建立block指针
@property(nonatomic,copy)void(^httpRequestBlock)(HttpDownLoadBlock*,BOOL);

//外部初始化设置的函数
//(void(^)(HttpDownLoadBlock*,BOOL))a 函数指针

-(id)initWithUrlStr:(NSString*)urlStr setBlock:(void(^)(HttpDownLoadBlock*,BOOL))a;
@end
