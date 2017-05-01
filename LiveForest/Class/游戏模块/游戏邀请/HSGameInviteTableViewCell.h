//
//  HSGameInviteTableViewCell.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSGameInviteModel;

@interface HSGameInviteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(strong,nonatomic)HSGameInviteModel *gameInviteModel;

+(id)ID;
- (IBAction)avatarButtonClicked:(id)sender;

@end
