//
//  CachedViewController.m
//  DownloadModule
//
//  Created by offcn on 15/7/8.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "CachedViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CachedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playLocalButton;

@end

@implementation CachedViewController
- (IBAction)playLocalButton:(UIButton *)sender {
    MPMoviePlayerViewController* VodPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://127.0.0.1:12347/Downloads/69_11846/69_11846.m3u8"]];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _playLocalButton.layer.borderColor = [UIColor grayColor].CGColor;
    _playLocalButton.layer.borderWidth = 1;
    _playLocalButton.layer.cornerRadius= _playLocalButton.frame.size.width/2;
    _playLocalButton.layer.masksToBounds=YES;
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
