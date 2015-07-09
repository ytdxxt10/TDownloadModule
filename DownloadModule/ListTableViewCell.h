//
//  ListTableViewCell.h
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
