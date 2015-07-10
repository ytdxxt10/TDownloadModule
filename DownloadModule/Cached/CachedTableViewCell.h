//
//  CachedTableViewCell.h
//  DownloadModule
//
//  Created by offcn on 15/7/10.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CachedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
