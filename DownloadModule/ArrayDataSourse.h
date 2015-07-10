//
//  ArrayDataSourse.h
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TableViewCellConfigureBolck)(id cell,id item);

@interface ArrayDataSourse : NSObject<UITableViewDataSource>

-(id)initWithItem:(NSArray*)anItem cellIdentifer:(NSString*)aCellIdentifier configCellBlock:(TableViewCellConfigureBolck)aConfigCellBlock;
-(id)itemAtIndexPath:(NSIndexPath*)indexPath;
@end
