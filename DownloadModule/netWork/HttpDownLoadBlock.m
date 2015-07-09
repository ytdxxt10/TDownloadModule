

//

#import "HttpDownLoadBlock.h"
#import "MyMD5.h"
#import "NSFileManager+method.h"
@implementation HttpDownLoadBlock
-(id)initWithUrlStr:(NSString*)urlStr setBlock:(void(^)(HttpDownLoadBlock*,BOOL))a{
    if (self=[super init]) {
        self.data=[NSMutableData dataWithCapacity:0];
        self.httpRequestBlock=a;
        //设置网络请求
        [self httpRequest:urlStr];
    }
    return self;
}
//进行网络请求
-(void)httpRequest:(NSString*)urlStr{
    //使用MD5进行加密
    self.pathFile=[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),[MyMD5 md5:urlStr]];
    NSFileManager*manager=[NSFileManager defaultManager];
    
    //fileExistsAtPath 判断文件或者文件夹是否存在
    if ([manager fileExistsAtPath:self.pathFile]&&[manager timeOutWithPath:self.pathFile timeOut:60*60]) {
        //缓存目录是有效的
        self.data=[NSMutableData dataWithContentsOfFile:self.pathFile];
        [self jsonValue];
        if (self.httpRequestBlock) {
             self.httpRequestBlock(self,YES);
        }
        
        
        
        }else{
            
        self.connection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] delegate:self];
        
    }
}
#pragma mark 4个网络请求的代理方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
    //self.data=[NSMutableData dataWithCapacity:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.data.length>0) {
        [self.data writeToFile:self.pathFile atomically:YES];
        [self jsonValue];
        if (self.httpRequestBlock) {
            self.httpRequestBlock(self,YES);
        }
    }else{
        if (self.httpRequestBlock) {
            self.httpRequestBlock(self,NO);
        }
    }
    
    
   
   

    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.httpRequestBlock) {
        self.httpRequestBlock(self,NO);
    }

}
-(void)jsonValue{
    //进行解析
    id result=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSArray class]]) {
        //是数组
        self.dataArray=[NSArray arrayWithArray:result];
    }else{
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDict=[NSDictionary dictionaryWithDictionary:result];
        }else{
            self.dataImage=[UIImage imageWithData:self.data];
        }
    }
    
    
}

@end
