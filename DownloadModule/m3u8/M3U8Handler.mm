//
//  M3U8Handler.m
//  XB
//
//  Created by luoxubin on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "M3U8Handler.h"
#import "M3U8Playlist.h"
@implementation M3U8Handler
@synthesize delegate,playlist;


-(void)dealloc
{
    delegate = nil;
    playlist = nil;
}


//解析m3u8的内容
-(void)praseUrl:(NSString *)urlstr
{
    NSLog(@"urlstr%@",urlstr);
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *data = [[NSString alloc] initWithContentsOfURL:url
                                                     usedEncoding:&encoding 
                                                            error:&error];
    
    if(data == nil)
    {
        NSLog(@"data is nil");
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(praseM3U8Failed:)])
        {
            [self.delegate praseM3U8Failed:self];
        }
        return;
    }
    
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    NSString* remainData =data;
//    NSRange segmentRange = [remainData rangeOfString:@"#EXTINF:"];
    count=1;
//    M3U8SegmentInfo * segment = [[M3U8SegmentInfo alloc]init];
//    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    NSMutableArray *array1=[[NSMutableArray alloc]init];
//    NSMutableArray *array2=[[NSMutableArray alloc]init];
    NSArray *array=[remainData componentsSeparatedByString:@"\n"];
//    NSLog(@"array11%@",array);
    
//将m3u8中的URL和keyUrl分出后，放在一个数组中。
    for (NSString *str1 in array) {
//        NSLog(@"str1%@",str1);
                    NSString *linkUrl=nil;
                    if ([str1 hasPrefix:@"#EXT-X-KEY:"]) {
                        NSRange range1= [str1 rangeOfString:@"\""];
                        NSRange range2= [str1 rangeOfString:@"\","];
                        NSLog(@"range1%lurange2%lu",(unsigned long)range1.location,(unsigned long)range2.location);
                         linkUrl=[str1 substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
//                        NSLog(@"linkUrl%@",linkUrl);
//                        segment.locationUrl=linkUrl;
                        [array1 addObject:linkUrl];
//                        [segments addObject:segment];
        
                    }else if([str1 hasPrefix:@"http:"]){
//                        NSLog(@"shsh%@",str1);
                        NSRange range1=[str1 rangeOfString:@"http"];
                        NSRange range2=[str1 rangeOfString:@"zg"];
                        linkUrl=[str1 substringWithRange:NSMakeRange(range1.location, range2.location-range1.location+2)];
//                        segment.locationUrl=linkUrl;
//                        NSLog(@"str1link%@",linkUrl);
                        [array1 addObject:linkUrl];

        
                    }else if([str1 hasPrefix:@"EXT-X-ENDLIST"]) {
                    
                        break;
                    }else{
                        continue;
                        
                    }
                }

//    NSLog(@"dataaaa%@",dataArray);
    for (NSString *str in array1) {
        M3U8SegmentInfo * segment = [[M3U8SegmentInfo alloc]init];

//        NSLog(@"strtr%@",str);
        segment.locationUrl=str;
        [segments addObject:segment];
    }
    
    M3U8Playlist * thePlaylist = [[M3U8Playlist alloc] initWithSegments:segments ];
//    NSLog(@"segments%@",segments);
    segments = nil;
    self.playlist = thePlaylist;
    thePlaylist = nil;
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(praseM3U8Finished:)])
    {
        [self.delegate praseM3U8Finished:self];
    }
}



@end
