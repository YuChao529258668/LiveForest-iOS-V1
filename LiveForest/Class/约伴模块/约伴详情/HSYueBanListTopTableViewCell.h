//
//  HSYueBanListTopTableViewCell.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/6.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSMyYueBanDetailList;
@interface HSYueBanListTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inviteDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *inviteTimeLabel;


@property(strong,nonatomic)NSTimer* timer;
@property(strong,nonatomic)NSTimer* timerMin;
@property(strong,nonatomic)NSTimer* timeHour;
@property NSTimeInterval sec;
@property NSTimeInterval min;
@property NSTimeInterval hour;

@property(strong,nonatomic)HSMyYueBanDetailList *yuebanDetail;
+(id)yueBanDetailCell;
+(id)ID;

@end
