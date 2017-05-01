//
//  HSYueBanDetailViewController.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSConstLayout.h"

#import "HSRequestDataController.h"
#import "HSYueBanUserInfoList.h"
#import "HSMyYueBanDetailList.h"
#import "UITableView+FDTemplateLayoutCell.h"

@protocol HSYueBanDetailViewControllerDelegate;


@interface HSYueBanDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



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

@property(nonatomic,copy)NSString *yuebanId;

@property(nonatomic,strong)NSMutableArray *friendsArray;
@property(nonatomic,strong)NSMutableArray *strangersArray;


@property(nonatomic,strong)HSRequestDataController *requestDataCtrl;
//@property(nonatomic, copy)NSString *yueBanID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidth;


@property(nonatomic)BOOL isDeal;
@property (weak, nonatomic)id<HSYueBanDetailViewControllerDelegate> delegate;
@end




@protocol HSYueBanDetailViewControllerDelegate <NSObject>

@required

- (void)agreeBtnClickWithYueBanID:(NSString *)yueBanID;
- (void)refuseBtnClickWithYueBanID:(NSString *)yueBanID;
//- (void)agreeBtnClickWithYueBanDataModel:(HSInviteFriendsCard *) inviteFriendsCard;
//- (void)refuseBtnClickWithYueBanDataModel:(HSInviteFriendsCard *) inviteFriendsCard;

@end
