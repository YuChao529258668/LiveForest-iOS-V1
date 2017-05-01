//
//  HSRegisterView.h
//  LiveForest
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HSRegisterView : UIView

//界面元素
/*返回按钮*/
@property (weak, nonatomic) IBOutlet UIButton *button_back;

/*获取验证码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *button_getVerifyCode;

/*下一步或者绑定按钮*/
@property (weak, nonatomic) IBOutlet UIButton *button_doSubmit;

/*页面标题*/
@property (weak, nonatomic) IBOutlet UILabel *label_pageTitle;

/*手机号码输入框*/
@property (weak, nonatomic) IBOutlet UITextField *textfield_phone;

/*密码输入框*/
@property (weak, nonatomic) IBOutlet UITextField *textfield_password;

/*验证码输入框*/
@property (weak, nonatomic) IBOutlet UITextField *textfield_verifyCode;

//界面事件
- (IBAction)onClick_buttonBack:(id)sender;

//公共元素
@property(strong,nonatomic) UIViewController* parentViewController;

//公共接口
- (instancetype)initWithType:(NSString*)type;

@end
