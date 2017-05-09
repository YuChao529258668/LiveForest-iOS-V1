//
//  HSYueBanListTopTableViewCell.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/6.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSYueBanListTopTableViewCell.h"
#import "HSMyYueBanDetailList.h"
#import "HSDataFormatHandle.h"

@implementation HSYueBanListTopTableViewCell


static int minToSec = 60.0;

+(id)yueBanDetailCell{
    return [[NSBundle mainBundle]loadNibNamed:@"HSYueBanListTopTableViewCell" owner:nil options:nil][0];
}

+(id)ID{
    return @"HSYueBanListTopTableViewCell";
}
- (void)awakeFromNib {
    // Initialization code
    
//    self.inviteTimeLabel
    self.voiceInfoBtn.hidden = YES;
    self.inviteMessageLabel.hidden = YES;
    _sec = 60;
    _hour = 5;
    _min = 6;
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
}

-(void)setYuebanDetail:(HSMyYueBanDetailList *)yuebanDetail{
    //约伴详情 赋值
    _yuebanDetail = yuebanDetail;    
//    NSLog(@"%@",yuebanDetail.yueban_sport_id);
//    NSLog(@"%@",yuebanDetail.user_nickname);
//    NSLog(@"%@",yuebanDetail.yueban_voice_second);
    //运动类型
    NSString *sport = [HSDataFormatHandle sportFormatHandleWithSportID:yuebanDetail.yueban_sport_id];
    NSString *sportId = [NSString stringWithFormat:@"%@",yuebanDetail.yueban_sport_id];
    if ([sportId isEqualToString:@"20"]) {
        sport = yuebanDetail.user_sport;
    }
    //邀请标题
    if ([yuebanDetail.is_mine isEqualToString:@"1"]) {
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"yueban_recommend_type"];
//        "1":邀请所有用户，现在就是随机20个用户，以后按照城市和运动类型筛选,"0":邀请我的好友，互粉的人
        if ([str isEqualToString: @"1"] ) {
            self.inviteDetailLabel.text = [NSString stringWithFormat:@"你 邀请 所有人 参加 %@",sport];
        }else {
            self.inviteDetailLabel.text = [NSString stringWithFormat:@"你 邀请 好友 参加 %@",sport];
        }
        
    }else{
        self.inviteDetailLabel.text = [NSString stringWithFormat:@"%@ 邀请 你 参加 %@",yuebanDetail.user_nickname,sport];
    }
////    邀请信息
    if (![yuebanDetail.yueban_voice_info isEqualToString:@""]) {
        self.inviteMessageLabel.hidden = YES;
        self.voiceInfoBtn.hidden = NO;
//        NSLog(@"%@",yuebanDetail.yueban_voice_second);
        if (![yuebanDetail.yueban_voice_second isEqualToString:@"-10086"]) {
            [self.voiceInfoBtn setTitle:yuebanDetail.yueban_voice_second forState:UIControlStateNormal];
        }
        
//        self.inviteMessageLabel.text = yuebanDetail.yueban_voice_second;
        //设置语音button 长度 点击
    }else {
        self.inviteMessageLabel.text = yuebanDetail.yueban_text_info;
        self.voiceInfoBtn.hidden = YES;
        self.inviteMessageLabel.hidden = NO;
    }
    
//    self.inviteMessageLabel.text = @"季度卡哈斯的李开复哈利就发货的街道上发生的恢复了收到货了发生的克里斯的粉红色大发了啥地方和喀什地方考试方式拉斯克奖的哈佛哈佛卡的经适房哈克大街上可恢复上课的分开就圣诞节和方式的";
//    self.inviteMessageLabel.hidden = NO;
//            self.voiceInfoBtn.hidden = NO;
    
//    邀请时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *givenTimeStr = [NSString stringWithFormat:@"%@",yuebanDetail.estimated_time];
    NSString *publishTimeStr = [NSString stringWithFormat:@"%@",yuebanDetail.create_time];
    NSDate *date = [NSDate date];
    NSDate *givenTimeDate = [NSDate dateWithTimeIntervalSince1970:([givenTimeStr integerValue]/1000)];
    NSDate *publishTimeDate = [NSDate dateWithTimeIntervalSince1970:([publishTimeStr integerValue]/1000)];
    NSComparisonResult compare = [date compare:givenTimeDate];
    if (compare  == NSOrderedSame ||compare == NSOrderedDescending) {
//        NSLog(@"yiyang de ");
        _sec=0;
        _min =0;
        _hour = 0;
        return;
    }
    NSTimeInterval dajishi = [givenTimeDate timeIntervalSinceNow];
    
    int time = dajishi;
    _hour = time/60 /60;
    _min = time/60 %60;
    _sec = time%60;

}

- (void) onTimer {
    if(_sec==0 && _min == 0 && _hour == 0) {
        [_timer invalidate];
        self.inviteTimeLabel.text = @"活动已结束";
        return;
    }
    if (_sec == 0) {
        _sec = minToSec;
        if (_min == 0) {
            _min = minToSec;
            _hour--;
        }
        _min--;
    }
    NSString* text = [NSString stringWithFormat:@"%.0f小时 %.0f分 %.0f秒",_hour, _min, --_sec];
    self.inviteTimeLabel.text = text;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
