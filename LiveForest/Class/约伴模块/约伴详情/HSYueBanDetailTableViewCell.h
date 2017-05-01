//
//  YueBanDetailTableViewCell.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSYueBanUserInfoList;

@interface HSYueBanDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property(nonatomic,copy)NSString *userID;


- (IBAction)ChatBtn:(id)sender;
@property(nonatomic,strong)HSYueBanUserInfoList *userInfo;

+(id)yueBaneListCell;
+(id)ID;
@end
