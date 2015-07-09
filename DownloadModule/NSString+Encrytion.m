//
//  NSString+Encrytion.m
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "NSString+Encrytion.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Encrytion)
-(NSString *)encryptionArray:(NSMutableArray *)anArray urlString:(NSString *)aUrlString
{
    aUrlString=[aUrlString stringByAppendingString:@"&sign="];
    
   __block NSString *signh=@"";
    
    [anArray enumerateObjectsUsingBlock:^(NSString * obj,NSUInteger idx,BOOL *stop){
    
        signh=[NSString stringWithFormat:@"%@offcnwx2015|%@",signh,obj];
    
    }];
    NSString *endStr=[NSString stringWithFormat:@"%@%@",aUrlString,[self md5:signh]];
    return endStr;
}

//Md5加密
-(NSString *)md5:(NSString *)input{
    const char *cstr=[input UTF8String];
    unsigned char digest[32];
    CC_MD5(cstr, strlen(cstr), digest);
    NSMutableString *output=[NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD2_DIGEST_LENGTH;i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;

}
@end
