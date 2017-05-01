//
//  HSInviteFriendsCardView.h
//  LiveForest
//
//  Created by 余超 on 15/8/4.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSInviteFriendsCard.h"
#import "HSSuperCell.h"
#import "HSRequestDataController.h"
//@class HSMyMyYueBanDetailListView;
#import "HSMyMyYueBanDetailListView.h"
#import "HSYueBanDetailViewController.h"

@class HSRecordTool;

@protocol HSInviteFriendsCardViewDelegate;

@interface HSInviteFriendsCardView : HSSuperCell <HSYueBanDetailViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;


@property(strong,nonatomic)NSMutableArray *inviteFriendsCardArray;
@property(nonatomic, strong)HSInviteFriendsCard *inviteFriendsCard;
@property(strong,nonatomic)HSRequestDataController *requestDataCtrl;
@property(nonatomic, strong)HSMyMyYueBanDetailListView *detailView;


@property(nonatomic, weak)id<HSInviteFriendsCardViewDelegate> ybDelegate;

/**
 *  播放语音
 */
@property (nonatomic, strong)HSRecordTool *recordTool;

@end



@protocol HSInviteFriendsCardViewDelegate <NSObject>

@required

//- (void)agreeBtnClickWithYueBanID:(NSString *)yueBanID;
//- (void)refuseBtnClickWithYueBanID:(NSString *)yueBanID;
- (void)agreeBtnClickWithYueBanDataModel:(HSInviteFriendsCard *) inviteFriendsCard;
- (void)refuseBtnClickWithYueBanDataModel:(HSInviteFriendsCard *) inviteFriendsCard;

@end