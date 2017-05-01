//
//  HSMineDetailViewController.h
//  LiveForest
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDataFormatHandle.h"

@interface HSMineDetailViewController : UITableViewController
- (IBAction)onClickByBackButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label_sex;
@property (weak, nonatomic) IBOutlet UILabel *label_age;
@property (weak, nonatomic) IBOutlet UILabel *label_education;
@property (weak, nonatomic) IBOutlet UILabel *label_city;
@property (weak, nonatomic) IBOutlet UILabel *label_wechatNickname;
@property (weak, nonatomic) IBOutlet UILabel *label_weicoNickname;

/*存放当前用户信息*/
@property(strong,nonatomic) NSDictionary* userInfo;
@end
