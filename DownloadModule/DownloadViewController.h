//
//  DownloadViewController.h
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSString *key;
@property (strong,nonatomic) NSString *downloadUrl;
@property (strong,nonatomic) NSString *fileName;
@property (strong,nonatomic) NSString *fileTitle;
@end
