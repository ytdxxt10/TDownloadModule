
//

#import <Foundation/Foundation.h>

@interface NSFileManager (method)
//判断缓存文件是否超时
//第一个参数文件的路径
//第二个参数是文件设置缓存时间
-(BOOL)timeOutWithPath:(NSString*)path timeOut:(NSTimeInterval)time;
//清除缓存
-(void)clearCache;

@end
