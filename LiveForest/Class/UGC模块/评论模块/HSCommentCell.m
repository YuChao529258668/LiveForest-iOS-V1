//
//  HSCommentCell.m
//  LiveForest
//
//  Created by Swift on 15/5/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSCommentCell.h"

@implementation HSCommentCell
@synthesize avatar;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize commentLabel;

- (void)awakeFromNib {
    // Initialization code
    
    //配置头像imageView
    avatar.contentMode=UIViewContentModeScaleAspectFill;
    avatar.layer.masksToBounds =YES;
    avatar.layer.cornerRadius =avatar.layer.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////手动计算cell高度的时候用到
//+(UILabel *)getCommentLabel {
//    NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSCommentCell" owner:nil options:nil];
//    HSCommentCell *cell=array[0];
//    return cell.commentLabel;
//}
@end
