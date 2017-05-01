//
//  HSMineDetailViewController.m
//  LiveForest
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMineDetailViewController.h"



@interface HSMineDetailViewController ()



/*元胞高度*/
@property(nonatomic) float cellHeight;

@end

@implementation HSMineDetailViewController

@synthesize userInfo;

#pragma mark - LifeCycle

#pragma mark 带参构造函数

- (instancetype)initWithUserInfo:(NSDictionary*)userInfo{

    
    self = [super init];
    
    if(self){
        self.userInfo = userInfo;
    }
    
    return self;
}


#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //这一步已经获取到了用户数据，将用户数据显示到界面上
    /*
     {
     "rong_cloud_id" = "cywTt9Eqd3IFESi6APzVQNGtQfYVwcTOdszM2MN6Wo0knSDCxurFL4JUfcyzdrjfX4GzxXzUvud9UkFhua9OYovMTc9vNGUlmAU/H2GOmmg=";
     "user_birthday" = 2538835200000;
     "user_city" = "-10086";
     "user_credit_num" = 65;
     "user_fans_num" = 7;
     "user_following_num" = 1;
     "user_id" = 143472661116965310;
     "user_introduction" = "-10086";
     "user_logo_img_path" = "";
     "user_nickname" = "\U963f\U65af\U5170";
     "user_phone" = "";
     "user_relationship" = 2;
     "user_sex" = 0;
     "user_sport_id" = "-10086";
     "wechat_logo_img_path" = "http://wx.qlogo.cn/mmopen/zLoibiaicqzeHoTtY30Fk4ayt88tTIyvvtVQtKiaicR26RExAWGQBz4hSOQhDY2jtiasqUeobTVCWG3NPKnrRXaNFgsbZGocWrRsIb/0";
     "wechat_nickname" = "\U963f\U65af\U5170";
     "weco_logo_img_path" = "-10086";
     "weco_nickname" = "-10086";
     }
     */
    
    //将View的背景色设置为白色
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    //用户性别
    self.label_sex.text = [HSDataFormatHandle convertSexFromCode:[userInfo objectForKey:@"user_sex"]];
    
    //用户年龄
    self.label_age.text = [HSDataFormatHandle getAgeFromBirthday:[userInfo objectForKey:@"user_birthday"]];
    
    //用户教育水准
    self.label_education.text = @"未知";
    
    //用户城市
    HSDataFormatHandle* hSDataFormatHandle = [[HSDataFormatHandle alloc] init];
    
    self.label_city.text =
    
    [hSDataFormatHandle areaFormatHandleWithStringID:[userInfo objectForKey:@"user_city"]] == nil ? @"未知":
    [hSDataFormatHandle areaFormatHandleWithStringID:[userInfo objectForKey:@"user_city"]] ;
    
    //用户微信昵称
    self.label_wechatNickname.text = [userInfo objectForKey:@"wechat_nickname"];
    
    //用户微博昵称
    if([[userInfo objectForKey:@"weco_nickname"] isEqualToString:@"-10086"]){
        self.label_weicoNickname.text = @"未知";
    }else{
        self.label_weicoNickname.text = [userInfo objectForKey:@"weco_nickname"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickByBackButton:(id)sender {
    
    //返回上一级菜单
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
