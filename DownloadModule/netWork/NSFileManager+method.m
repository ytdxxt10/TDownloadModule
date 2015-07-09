


//

#import "NSFileManager+method.h"

@implementation NSFileManager (method)
-(BOOL)timeOutWithPath:(NSString*)path timeOut:(NSTimeInterval)time{
//首先获得NSfileManager的指针
    NSFileManager*manager=[NSFileManager defaultManager];
//获得指定某一个文件的信息
    NSDictionary*info=[manager attributesOfItemAtPath:path error:nil];
    //获得文件创建时间
    NSDate*createData=[info objectForKey:NSFileCreationDate];
    //获得缓存文件大小
    //[info objectForKey:NSFileSize];
    //获得当前时间
    NSDate*date=[NSDate date];
    
    //获得这2个时间的差值
    NSTimeInterval tempTime=[date timeIntervalSinceDate:createData];
    if (tempTime>time) {
        //过期了
        return NO;
    }else{
        return YES;
    }
}
-(void)clearCache{
//获得所有的文件名
    
    NSString*path=[NSString stringWithFormat:@"%@/documents",NSHomeDirectory()];
    
    NSFileManager*manager=[NSFileManager defaultManager];
    //array保存的是所有文件名字
   NSArray*array= [manager contentsOfDirectoryAtPath:path error:nil];
    
   
    
    //清空缓存有2种办法
    //第一种办法
    for (NSString*fileName in array) {
        //删除指定文件
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),fileName] error:nil];
    }
//    //第二种办法
//    //把array转换成枚举器
//    NSEnumerator*enumerator=[array objectEnumerator];
//    NSString*fileName;
//    while (fileName=[enumerator nextObject]) {
//         [manager removeItemAtPath:[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),fileName] error:nil];
//    }
    
//    //第三种方法 比快速枚举效率更高4.0
//    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//         [manager removeItemAtPath:[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),obj] error:nil];
//    }];

}
@end
