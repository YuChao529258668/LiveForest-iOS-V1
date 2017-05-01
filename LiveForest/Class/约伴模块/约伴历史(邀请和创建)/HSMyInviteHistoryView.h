//
//  HSMyInviteHistoryView.h
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSMyInviteHistoryCell.h"

#import "HSConstLayout.h"

#import "UITableView+FDTemplateLayoutCell.h"

//数据模型层
#import "HSMyYueBanDetailList.h"


@interface HSMyInviteHistoryView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *myInviteTableView;

////一个存储 所有 我的约伴详情的 数组，数组中的信息来自 数据模型层
//@property (strong, nonatomic) NSMutableArray *myYueBanHistory;
@end
