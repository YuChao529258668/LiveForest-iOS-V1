//
//  HSNicknameViewController.m
//  LiveForest
//
//  Created by wangfei on 7/9/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSNicknameViewController.h"
#import "HSRequestDataController.h"
#import "HSUserInfoHandler.h"
#import "MBProgressHUD.h"
#import "Macros.h"
@interface HSNicknameViewController()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textFiled;
@end
@interface HSNicknameViewController ()

@end

@implementation HSNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNickname)];
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
    
    [self.view addSubview:self.textFiled];
    self.textFiled.delegate = self;
    self.textFiled.backgroundColor = [UIColor whiteColor];
    //textFiled成为第一响应者
    [self.textFiled becomeFirstResponder];
}
-(UITextField *)textFiled
{
    if (_textFiled == nil) {
        CGFloat padding = 30;
        CGFloat textFiledY = padding + self.navigationController.navigationBar.bounds.size.height;
        CGFloat textFiledW = self.view.bounds.size.width;
        CGFloat textFiledH = 40;
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, textFiledY, textFiledW, textFiledH)];
        //设置字体
        _textFiled.text = self.nickname;
        _textFiled.font = [UIFont systemFontOfSize:15.0];
        _textFiled.clearButtonMode = UITextFieldViewModeAlways;
        //前面加个缝隙
        _textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, textFiledH)];
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
        _textFiled.placeholder = @"请输入昵称";
        //修改键盘返回值
        _textFiled.returnKeyType = UIReturnKeyDone;
        //自动禁用
        _textFiled.enablesReturnKeyAutomatically = YES;
        //首字母不大写
        _textFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _textFiled;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  保存nickname后台和本地
 */
-(void)saveNickname
{
    //提交后台
    HSRequestDataController *requestDataCtrl = [[HSRequestDataController alloc]init];
    //修改本地
    HSUserInfoHandler *userInfoControl = [[HSUserInfoHandler alloc]init];
    //修改后的nickname
    NSString *editedNickname = self.textFiled.text;
    if(editedNickname == nil || editedNickname.length == 0)
    {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:@"没有输入昵称，请从新填写" delegate:nil
    cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alerView show];
        return;
    }
    //如果和原来不相等
    if ([editedNickname isEqualToString:self.nickname])
    {
        //直接关闭视图
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *user_token = [userDefaults objectForKey:@"user_token"];
        if(!user_token || editedNickname == nil){
            NSLog(@"user_token为空，或者Nickname为空");
        }else{
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                                 editedNickname,@"user_nickname",nil];
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
            
            NSLog(@"requestData:%@",requestData);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"更新昵称中";
            [requestDataCtrl updatePersonNickname:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
                if (code)
                {
                    NSLog(@"更新昵称成功");
                    //通知上一个页面修改
                    NSMutableDictionary *dicM  = [NSMutableDictionary dictionary];
                    [dicM setObject:editedNickname forKey:@"nickname"];
                    //关闭视图
                    [hud hide:YES];
                    //写入本地文件
                    [userInfoControl updateUserNickname:editedNickname];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else
                {
                    [hud hide:YES];
                    ShowHud(@"更新失败", NO);
                    NSLog(@"跟新昵称请求失败，%@",error);
                }
            }];
            
        }

    }
    
    
}
//点击完成，提交后台，关闭视图
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //保存后台和本本地
    [self saveNickname];
    return YES;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
