//
//  CachedViewController.m
//  DownloadModule
//
//  Created by offcn on 15/7/8.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "CachedViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CachedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *CachedTableView;

@end

@implementation CachedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc]init];
    _CachedTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _CachedTableView.delegate = self;
    _CachedTableView.dataSource=self;
    [self.view addSubview:_CachedTableView];

    NSString *path=[NSString stringWithFormat:@"%@/Documents/Downloads/finished.plist",NSHomeDirectory()];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
    _dataArray=[NSMutableArray arrayWithArray:tempArray];
    NSLog(@"temp%@",tempArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [_dataArray[indexPath.row] objectForKey:@"fileTitle"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName=[_dataArray[indexPath.row] objectForKey:@"fileName"];
    NSString *strUrl=[NSString stringWithFormat:@"http://127.0.0.1:12347/Downloads/%@/%@.m3u8",fileName,fileName];
    MPMoviePlayerViewController* VodPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:strUrl]];
    if (VodPlayer)
    {
        //        if ([VodPlayer respondsToSelector:@selector(setMovieSourceType:)])
        //        {
        VodPlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        //        }
        [self presentViewController:VodPlayer animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(myMovieFinishedCallback:) name: MPMoviePlayerPlaybackDidFinishNotification object: nil];
    }


}

- (void)myMovieFinishedCallback:(NSNotification *)notification{
    
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue])
    {
        case MPMovieFinishReasonPlaybackEnded:
        {
            NSLog(@"视频结束了");
            
            //            double progress =  self.currentPlayer.currentPlaybackTime;
            //            double duration = self.currentPlayer.duration;
            
            //            NSLog(@"视频结束了,%f=====%f",progress,duration);
        }
            break;
        case MPMovieFinishReasonPlaybackError:
        {
            NSLog(@"有一个错误在回放期间");
        }
            break;
        case MPMovieFinishReasonUserExited:
        {
            NSLog(@"用户停止播放");
        }
            break;
        default:
            break;
    }
    
}


@end
