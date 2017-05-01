//
//  HSMyInviteHistoryCell.h
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMyYueBanDetailList.h"
@interface HSMyInviteHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avartaImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *inviteState;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

//记录每个创建约伴信息
@property (nonatomic, copy) NSString *yueban_id;  //约伴纪录id
@property (nonatomic, copy) NSString *user_id; //:String约伴创建者id
@property (nonatomic, copy) NSString *yueban_text_info; //:String约伴文本信息
@property (nonatomic, copy) NSString *yueban_voice_info; //:String约伴语音地址
//yueban_user_city:String约伴创建者所在城市
@property (nonatomic, copy) NSString *create_time;  //:String约伴创建时间
@property (nonatomic, copy) NSString *yueban_sport_id; //:String约伴运动类型
@property (nonatomic, copy) NSString *user_nickname;  //:String约伴创建者昵称
@property (nonatomic, copy) NSString *user_logo_img_path;  //:String约伴创建者头像

@property(strong,nonatomic) HSMyYueBanDetailList *myYueBanList;
//user_sex:String约伴创建者性别
//user_introduction:String约伴创建者个人说明
//user_birthday:String约伴创建者生日时间戳
//estimated_time:String约伴创建者设置的约伴预计时间＋创建时间的结果的时间戳。用来算倒计时
@end
