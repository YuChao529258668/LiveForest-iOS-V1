//
//  HSCommentCell.h
//  LiveForest
//
//  Created by Swift on 15/5/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCommentCell : UITableViewCell
/**
 发表评论的用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
/**
 发表评论的用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 发表评论的时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 发表评论的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;




@end
