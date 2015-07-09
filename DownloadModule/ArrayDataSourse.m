//
//  ArrayDataSourse.m
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "ArrayDataSourse.h"
@interface ArrayDataSourse ()
@property (strong,nonatomic) NSArray *items;
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) TableViewCellConfigureBolck configCellBlock;

@end

@implementation ArrayDataSourse

-(id)init
{
    return nil;
}
-(id)initWithItem:(NSArray *)anItem cellIdentifer:(NSString *)aCellIdentifier configCellBlock:(TableViewCellConfigureBolck)aConfigCellBlock
{
    self=[super init];
    if (self) {
        self.items=anItem;
        self.identifier=aCellIdentifier;
        self.configCellBlock=[aConfigCellBlock copy];
    }

    return self;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;

}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath
{

    return self.items[indexPath.row];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    id item=[self itemAtIndexPath:indexPath];
    
    self.configCellBlock(cell,item);
    return cell;


}
@end
