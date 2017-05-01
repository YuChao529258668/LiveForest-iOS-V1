//
//  HSMyMyYueBanDetailListView.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSConstLayout.h"

#import "HSRequestDataController.h"
#import "HSYueBanUserInfoList.h"
#import "HSMyYueBanDetailList.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface HSMyMyYueBanDetailListView : UIView<UITableViewDataSource,UITableViewDelegate>

- (IBAction)stopInviteBtn:(id)sender;
- (IBAction)ignoreInviteClick:(id)sender;
- (IBAction)wantGoClick:(id)sender;
- (void)show;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *ignoreInviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *wantGoBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopInviteBtn;

@property (weak, nonatomic) IBOutlet UITableView *MyYueBanListTableView;

- (IBAction)backBtnClick:(id)sender;
- (instancetype)initWithYueBanID:(NSString *)yueBanID;
@property(nonatomic)BOOL isMe;


@property(strong,nonatomic)HSYueBanUserInfoList *yuebanUserInfo;
@property(strong,nonatomic)HSMyYueBanDetailList *yuebanDetail;

//@property(nonatomic,copy)NSString *yuebanId;

@property(nonatomic,strong)NSMutableArray *friendsArray;
@property(nonatomic,strong)NSMutableArray *strangersArray;


@property(nonatomic,strong)HSRequestDataController *requestDataCtrl;
//@property(nonatomic, copy)NSString *yueBanID;

@property(strong,nonatomic)UIActivityIndicatorView *loading;

@end
