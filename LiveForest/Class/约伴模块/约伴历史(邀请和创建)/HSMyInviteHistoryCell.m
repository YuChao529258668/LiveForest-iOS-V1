//
//  HSMyInviteHistoryCell.m
//  LiveForest
//
//  Created by 傲男 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMyInviteHistoryCell.h"
#import <UIImageView+WebCache.h>
#import "HSDataFormatHandle.h"
@implementation HSMyInviteHistoryCell

- (void)awakeFromNib {
    // Initialization code
    _avartaImage.layer.cornerRadius = _avartaImage.frame.size.width/2;
    _avartaImage.clipsToBounds = YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//@property (strong, nonatomic) IBOutlet UIImageView *avartaImage;
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
//@property (strong, nonatomic) IBOutlet UILabel *inviteState;
//@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
//
////记录每个创建约伴信息
//@property (nonatomic, copy) NSString *yueban_id;  //约伴纪录id
-(void)setMyYueBanList:(HSMyYueBanDetailList *)myYueBanList{
    
    NSURL *avatarUrl = [NSURL URLWithString:myYueBanList.user_logo_img_path];
    
    if (!avatarUrl) {
        NSString *avatarUrlString = [myYueBanList.user_logo_img_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        avatarUrl = [NSURL URLWithString:avatarUrlString];
    }
    [_avartaImage sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"mineAvarl.png"]];
    NSString *sport = [HSDataFormatHandle sportFormatHandleWithSportID:myYueBanList.yueban_sport_id];
    
//    NSString *sport = [HSDataFormatHandle sportFormatHandleWithSportID:yuebanDetail.yueban_sport_id];
    NSString *sportId = [NSString stringWithFormat:@"%@",myYueBanList.yueban_sport_id];
    if ([sportId isEqualToString:@"20"]) {
        sport = myYueBanList.user_sport;
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"%@ 邀请 你 参加 %@",myYueBanList.user_nickname,sport];
    
//    _titleLabel.text =  [HSDataFormatHandle dateformaterWithTimestamp:myYueBanList.create_time andFormater:@"yyyy-MM-dd"];
    
//    yueban_state:约伴状态,'1':进行中,'0':已停止约伴
    if ([myYueBanList.yueban_state isEqualToString:@"1"]) {
        _inviteState.text = @"进行中";
    }else if([myYueBanList.yueban_state isEqualToString:@"0"]){
        _inviteState.text = @"已停止";
    }else{
        _inviteState.text = @"未知";
    }
    
    _descriptionLabel.text = myYueBanList.yueban_text_info;
}
@end
