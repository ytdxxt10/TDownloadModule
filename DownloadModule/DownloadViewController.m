//
//  DownloadViewController.m
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "DownloadViewController.h"
#import "NSString+Encrytion.h"
#import "ListModel.h"
#import "ListTableViewCell.h"
#import "HttpDownLoadBlock.h"
#import "DownloadManage.h"
@interface DownloadViewController ()<UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIAlertView *_downloadAlertView;
}
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=NSLocalizedString(@"Course Download", nil);
    _dataArray=[[NSMutableArray alloc]init];
    [self createTableView];
    [self dataRequest];

    self.view.backgroundColor=[UIColor grayColor];
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];


}

-(void)dataRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@foreuser_app/getSessionId?type=1",UrlHostString];
    NSArray *tempArray=@[@"1"];
    urlStr=[urlStr encryptionArray:tempArray urlString:urlStr];
   __unused HttpDownLoadBlock *block=[[HttpDownLoadBlock alloc]initWithUrlStr:urlStr setBlock:^(HttpDownLoadBlock *http,BOOL succeed){
    
        if (succeed) {
            [self getKeyWithSid:[http.dataDict[@"data"] objectForKey:@"sid"]];
        }
    }];


}

-(void)getKeyWithSid:(NSString *)sid
{
    NSString *urlStr=[NSString stringWithFormat:@"%@foreuser_app/dologin?type=1&key=%@&username=13811196143&password=111111",UrlHostString,sid];
    NSArray *tempArray=@[sid,@"111111",@"1",@"13811196143"];
    urlStr=[urlStr encryptionArray:tempArray urlString:urlStr];
    NSLog(@"urlsSTr%@",urlStr);
   __unused HttpDownLoadBlock *http=[[HttpDownLoadBlock alloc]initWithUrlStr:urlStr setBlock:^(HttpDownLoadBlock *http,BOOL succeed){
        if (succeed) {
            _key=[http.dataDict[@"data"]objectForKey:@"key"];
            [self getListData:[http.dataDict[@"data"] objectForKey:@"key"]];
        }
    }];

}

-(void)getListData:(NSString *)str
{
    NSString * url = [NSString stringWithFormat:@"%@course_app/GetMyCourseInfo?key=%@&class_id=69&type=1",UrlHostString,str];
    NSArray *tempArray=@[@"69",str,@"1"];
    url=[url encryptionArray:tempArray urlString:url];
    NSLog(@"http%@",url);
   __unused HttpDownLoadBlock *block=[[HttpDownLoadBlock alloc]initWithUrlStr:url setBlock:^(HttpDownLoadBlock *http,BOOL succeed){
        if (succeed) {
            NSLog(@"%@",http.dataDict[@"data"]);
            for (NSDictionary *dic in [http.dataDict[@"data"] objectForKey:@"list"]) {
                                ListModel *listModel=[[ListModel alloc]init];
//                                listModel.title=dic[@"title"];
                
                                [listModel setValuesForKeysWithDictionary:dic];
                                [_dataArray addObject:listModel];
                            }
            [_tableView reloadData];

        }
    }];


}
#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",self.dataArray);

    return _dataArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
        ListModel * listmodel=_dataArray[indexPath.row];
        cell.titleLabel.text=listmodel.title;
        cell.subTitleLabel.text=listmodel.title;
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *listModel=_dataArray[indexPath.row];
//    if (indexPath.row==0) {
//        NSLog(@"indexpath.row%d",indexPath.row);
//    }else{
    _fileName=[NSString stringWithFormat:@"69_%@",listModel.id];
    _fileTitle=listModel.title;
    [self getDataURL:listModel.id];
//    }

}

-(void)getDataURL:(NSString *)str
{
    NSString *movieUrl =[NSString stringWithFormat:@"%@course_app/GetKeysAndUrlByLid?key=%@&class_id=69&lesson_id=%@&type=1",UrlHostString,self.key,str];
    NSArray *tempArray=@[@"69",self.key,str,@"1"];
   movieUrl= [movieUrl encryptionArray:tempArray urlString:movieUrl];
//    NSLog(@"movieUrl-%@",movieUrl);
   __unused HttpDownLoadBlock *block=[[HttpDownLoadBlock alloc]initWithUrlStr:movieUrl setBlock:^(HttpDownLoadBlock *http,BOOL isSucceed){
        if (isSucceed) {
            NSLog(@"%@",http.dataDict);
            if ([http.dataDict[@"flag"] isEqualToValue:@2]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Reminder", nil) message:http.dataDict[@"infos"] delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles: nil];
                [alert show];
                return ;
            }
            if ([http.dataDict[@"flag"] integerValue]==2) {
                UIAlertView *remindAlertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Remind", nil) message:http.dataDict[@"infos"] delegate:nil cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles: nil];
                [remindAlertView show];
            }else{
            [self downloadMovie:[http.dataDict[@"data"] objectForKey:@"url"]];
            }
        }
        
    
    }];



}

-(void)downloadMovie:(NSString *)strUrl{

    NSString *encodeUrlStr=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)strUrl, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
   NSString *tempStr=[NSString stringWithFormat:@"%@course_app/replace_str?key=%@&url=%@&type=1",UrlHostString,self.key,encodeUrlStr];
    NSArray *tempArray=@[self.key,@"1",encodeUrlStr];
    tempStr=[tempStr encryptionArray:tempArray urlString:tempStr];
    NSLog(@"temp%@",tempStr);
    self.downloadUrl=tempStr;
    _downloadAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Reminder", nil) message:NSLocalizedString(@"Download ?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Certain", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
    [_downloadAlertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
  [[DownloadManage shareDownloadManage]downloadWithUrl:_downloadUrl fileName:_fileName fileTitle:_fileTitle];
  
     
        
    }else{
        NSLog(@"Cancel Download");
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
