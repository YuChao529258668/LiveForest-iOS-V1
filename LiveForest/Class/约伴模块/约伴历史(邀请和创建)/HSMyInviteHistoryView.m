//
//  HSMyInviteHistoryView.m
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMyInviteHistoryView.h"
#import "HSMyMyYueBanDetailListView.h"
#import "HSYueBanDetailViewController.h"
@implementation HSMyInviteHistoryView

//static NSString *reuseIdentifier = @"HSMyInviteHistoryCell";

//- (void)setMyYueBanHistory:(NSMutableArray *)myYueBanHistory{
//    _myYueBanHistory = myYueBanHistory;
//}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews;
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSMyInviteHistoryView" owner:self options:nil];
        
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 加载nib
        self = arrayOfViews[0];
        
        
        //cell的注册
//        [self.myInviteTableView registerNib:[UINib nibWithNibName:@"HSMyInviteHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
//        
//        self.myInviteTableView.dataSource = self;
//        self.myInviteTableView.delegate = self;
        
        
//        //点击返回按钮
//        [self.backBtn addTarget:self action:@selector(backPress:) forControlEvents:UIControlEventTouchUpInside];
        
        //屏幕适配
//        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
//        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
        
//        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
//        CGRect frame=self.frame;
//        frame.origin=CGPointZero;
//        self.frame=frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(HSMyInviteHistoryCell *cell) {
//        
//        //根据描述的长度，动态计算高度。
//        
////        [self configCell:cell atIndexPath:indexPath];
//        cell.descriptionLabel.text = @"下午6点南大篮球场，战个痛快！";
////        cell.descriptionLabel.text = [[self.myYueBanHistory objectAtIndex:indexPath.row] objectForKey:@""];
//        
//    }];
////    return 128;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 5;
////    return self.myYueBanHistory.count;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HSMyInviteHistoryCell *cell = [self.myInviteTableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.descriptionLabel.text = @"下午6点南大篮球场，战个痛快！";
//
//    // Configure the cell...
////    [self configCell:cell andIndexPath:indexPath];
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HSMyInviteHistoryCell *cell = (HSMyInviteHistoryCell *)[self.myInviteTableView cellForRowAtIndexPath:indexPath];
//    //跳转到 详情
//    
//    
//    HSYueBanDetailViewController *yuebanDetailViewController = [[HSYueBanDetailViewController alloc]init];
////    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:yuebanDetailViewController animated:YES completion:nil];
////    [[UIApplication sharedApplication].keyWindow addSubview:yuebanDetailViewController.view];
//    [self addSubview:yuebanDetailViewController.view];
////    [self presentViewController:yuebanDetailViewController animated:YES completion:nil];
////    
////    HSMyMyYueBanDetailListView *detailView = [[HSMyMyYueBanDetailListView alloc]initWithYueBanID:cell.yueban_id];
////    [detailView show];
//}
//
//#pragma mark 配置cell信息
//- (void)configCell:(HSMyInviteHistoryCell *)cell andIndexPath:(NSIndexPath *)indexPath{
//    HSMyYueBanDetailList *yueBanDetail = (HSMyYueBanDetailList*)[_myYueBanHistory objectAtIndex:indexPath.row];
//    cell.yueban_id = yueBanDetail.yueban_id;
//    //todo
//}

@end
