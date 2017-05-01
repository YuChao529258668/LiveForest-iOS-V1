//
//  HSSettingPersonalViewController.h
//  LiveForest
//
//  Created by Swift on 15/5/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSUserInfoHandler.h"
#import "ServiceHeader.h"
#import "UtilsHeader.h"
#import "HSRequestDataController.h"
#import "Macros.h"

//蒲公英反馈与更新
#import <PgySDK/PgyManager.h>

#import "HSPhoneBindViewController.h"

@interface HSSettingPersonalViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *avarlImage;

@property (weak, nonatomic) IBOutlet UILabel *label_wechatName;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  系统消息关闭与否显示
 */
@property (weak, nonatomic) IBOutlet UISwitch *systemMessageSwith;
@property (weak, nonatomic) IBOutlet UILabel *systemMessageState;

@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;

@property (strong, nonatomic) IBOutlet UIButton *updateAppBtn;
@property (strong, nonatomic) IBOutlet UIButton *feedBackBtn;
@property (strong, nonatomic) HSRequestDataController* hSRequestDataController;

//第三方账户绑定系列
/*用户手机号*/
@property (strong, nonatomic) IBOutlet UILabel *label_user_phone;

/*用户微信账户*/
@property (strong, nonatomic) IBOutlet UILabel *label_user_wechatName;

/*用户微博账户号*/
@property (strong, nonatomic) IBOutlet UILabel *label_user_wecoName;


@end
