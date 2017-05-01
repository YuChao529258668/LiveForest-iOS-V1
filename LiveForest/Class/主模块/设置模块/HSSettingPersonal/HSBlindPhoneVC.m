//
//  HSBlindPhoneVC.m
//  LiveForest
//
//  Created by wangfei on 7/31/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSBlindPhoneVC.h"
#import "HSCountDownButton.h"
#import "Macros.h"
#import "HSRequestDataController.h"

@interface HSBlindPhoneVC ()<UITextFieldDelegate>

/*手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;

/*验证码*/
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextField;
@property (weak, nonatomic) IBOutlet HSCountDownButton *requestCodeBtn;
//数据请求类
@property (strong,nonatomic) HSRequestDataController* requestCtrl;
@end

@implementation HSBlindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //由上个页面传入的号码值，判断是新绑定还是更换绑定
    if (self.phoneNumber == nil || self.phoneNumber.length == 0 || [self.phoneNumber isEqualToString:@"未绑定"]) {
        self.title = @"绑定手机号";
    }else{
        self.title = @"更换手机号绑定";
    }
    //navigationItem设置
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeConfirm)];
    self.phoneTextFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.phoneTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.phoneTextFiled.delegate = self;
    
    self.confirmCodeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.confirmCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据请求类
    self.requestCtrl = [[HSRequestDataController alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)requestCode:(HSCountDownButton *)sender
{
    //判断输入的手机号码格式
    if (![self checkPhoneNumber:self.phoneTextFiled.text]) {
        return;
    }
    
    //请求验证码
    sender.enabled = NO;
    
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:10];
    
    [sender didChange:^NSString *(HSCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"重新获取(%d)",second];
        return title;
    }];
    [sender didFinished:^NSString *(HSCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"获取验证码";
    }];
    
    /*请求网络验证码*/
    
    //构造请求数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTextFiled.text,@"user_phone",nil];
    
    //封装请求数据
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    
    //向后台手机发起请求
    [self.requestCtrl doPhoneVerify:requestData
                       andRequestCB:^(BOOL code, id responseObject, NSString *error){
                           if(code){
                               [self.requestCtrl doVerificationCodeSend:requestData
                                                           andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                                               if(code){
//                                                                   ShowHudWithDelay(@"发送验证码成功", NO, 0.5);
                                                                   ShowHud(@"发送验证码成功", NO);
                                                               }
                                                               else{
//                                                                   ShowHudWithDelay(@"发送验证码失败", NO,0.5);
                                                                   ShowHud(@"发送验证码失败", NO);
                                                               }
                                                           }];
                           }
                           else{
                               self.phoneTextFiled.text = @"";
                               ShowHud(@"请输入未注册的手机号", NO);
                           }
    }];

}

#pragma mark - 提交验证码去后台
- (void)completeConfirm
{
    //检查手机号
    if (![self checkPhoneNumber:self.phoneTextFiled.text]) {
        ShowHud(@"请输入手机号", NO);
        return;
    }
    //检查code
    if (self.confirmCodeTextField.text.length == 0) {
        ShowHud(@"请输入验证码", NO);
        return;
    }
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值

    
    //构造请求数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTextFiled.text,@"user_phone",self.confirmCodeTextField.text,@"checkCode",user_token,@"user_token",nil];
    
    //封装请求数据
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    
    //提交网络验证正确性
    [self.requestCtrl doUserPhoneBind:requestData andRequestCB:^(BOOL code, id result, NSString *error) {
        
        if(code){
            
//            ShowHudWithDelay(@"绑定成功!", code, 0.7);
            ShowHud(@"绑定成功!", NO);
            //如果绑定成功，更新用户本地缓存
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.phoneTextFiled.text forKey:@"user_phone"];
            
            //如果绑定成功，则发出通知让上一个界面更改信息
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SettingDataRefreshNotification"
             object:nil
             userInfo:[[NSDictionary alloc]initWithObjectsAndKeys:self.phoneTextFiled.text,@"label_user_phone", nil ]];
            
            
        }else{
            //否则提示错误
            ShowHud(error, NO);
        }
    }];
    
    
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField代理状态
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //最多输入11位手机号
    return range.location < 11;
}

#pragma mark - 检查提交手机号
- (BOOL)checkPhoneNumber:(NSString *)phone
{
    //判断输入的手机号码的正确定，11位
    if (phone.length != 11) {
        ShowHud(@"请输入正确的手机号", NO);
        return false;
    }
    //判断手机号是否和上一个绑定的相同
    if ([phone isEqualToString:self.phoneNumber]){
        ShowHud(@"您输入的是当前账号", NO);
        return false;
    }
    return true;
}
@end
