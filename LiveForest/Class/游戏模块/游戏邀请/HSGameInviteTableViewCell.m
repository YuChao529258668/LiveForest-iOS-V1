//
//  HSGameInviteTableViewCell.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameInviteTableViewCell.h"
#import "HSGameInviteModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HSGameInviteTableViewCell

+(id)ID{
    return @"HSGameInviteTableViewCell";
}

- (void)setGameInviteModel:(HSGameInviteModel *)gameInviteModel {
    _gameInviteModel = gameInviteModel;
    _nameLabel.text = gameInviteModel.user_nickname;
    _timeLabel.text = gameInviteModel.task_create_time;
    
    NSURL *url = [NSURL URLWithString:gameInviteModel.user_logo_img_path];
    [_avatarButton.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"评论头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImageView *iv = [[UIImageView alloc]initWithImage:image];
        iv.backgroundColor = [UIColor redColor];
        iv.frame = _avatarButton.frame;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.cornerRadius = iv.frame.size.width/2;
        iv.clipsToBounds = YES;
        [self.contentView addSubview:iv];
        
        //        [self setNeedsDisplay];
        //        [_avatarButton setImage:image forState:UIControlStateNormal];
        
        if (error) {
            NSLog(@"下载头像错误%@",error);
//            self.backgroundColor = [UIColor redColor];
        } else {
            //            NSLog(@"头像下载完成");
            //            self.backgroundColor = [UIColor greenColor];
        }
    }];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)avatarButtonClicked:(id)sender {
    
}

@end
