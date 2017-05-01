//
//  HSMyInviteHistoryViewController.h
//  LiveForest
//
//  Created by 余超 on 15/8/6.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSMyInviteHistoryView.h"

//数据模型，直接加到视图中
#import "HSMyYueBanDetailList.h"

#import "HSRequestDataController.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface HSMyInviteHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HSMyInviteHistoryView *myYueBanHistoryView;

@property (nonatomic, strong) HSRequestDataController *requestCtrl;


//一个存储 所有 我的约伴详情的 数组，数组中的信息来自 数据模型层
@property (strong, nonatomic) NSMutableArray *myYueBanHistory;

@end
