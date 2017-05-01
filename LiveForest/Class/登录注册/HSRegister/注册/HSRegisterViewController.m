//
//  HSRegisterViewController.m
//  LiveForest
//
//  Created by 微光 on 15/4/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//checkCode

#import "HSRegisterViewController.h"
//#import "HSTabBarController.h"
#import "HSViewController.h"
#import <ShareSDK/ShareSDK.h>

#import "SingletonForRootViewCtrl.h"

#import "WeiboSDK.h"
#import "WXApi.h"

@interface HSRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *checkNumber;

- (IBAction)registerSubmit:(id)sender;

- (IBAction)getCheckNum:(id)sender;

- (IBAction)weixinRegister:(id)sender;
- (IBAction)weiboRegister:(id)sender;
@end

@implementation HSRegisterViewController

@synthesize password= _password;

-(instancetype)init {
    self=[super init];
    if (self) {
//        if([UIScreen mainScreen].bounds.size.height==568) {
            self=[[HSRegisterViewController alloc]initWithNibName:@"HSRegisterViewController" bundle:[NSBundle mainBundle]];
//        } else if([UIScreen mainScreen].bounds.size.height==667) {
//            self=[[HSRegisterViewController alloc]initWithNibName:@"HSRegisterViewController@2x" bundle:[NSBundle mainBundle]];
//        }else if([UIScreen mainScreen].bounds.size.height==480) {
//            self=[[HSRegisterViewController alloc]initWithNibName:@"HSRegisterViewController@4s" bundle:[NSBundle mainBundle]];
//        }
//        else {
//            self=[[HSRegisterViewController alloc]initWithNibName:@"HSRegisterViewController@3x" bundle:[NSBundle mainBundle]];
//        }
        //屏幕适配
        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.view.frame.size.width;
        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.view.frame.size.height;
        
        self.view.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
        CGRect frame=self.view.frame;
        frame.origin=CGPointZero;
        self.view.frame=frame;
        
        if (![WXApi isWXAppInstalled]) {
            //判断是否有微信
            self.weixinBtn.alpha = 0;
            self.weixinLabel.alpha = 0;
        }
        if(![WeiboSDK isWeiboAppInstalled]){
            self.weiboxLabel.alpha = 0;
            self.weiboBtn.alpha = 0;
        }
        if(self.weiboBtn.alpha == 0 && self.weixinBtn.alpha == 0){
            self.progress1.alpha = 0;
            self.progress2.alpha = 0;
            self.descriptionLabel.alpha = 0;
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumber.text = @"";
    self.checkNumber.text = @"";
    
    self.phoneNumber.placeholder = @"手机号";
    self.checkNumber.placeholder = @"验证码";
    _password.placeholder = @"密码";
    [self.phoneNumber setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.checkNumber setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.checkNumber.keyboardType = UIKeyboardTypeNumberPad;
    _password.keyboardType = UIKeyboardAppearanceDefault;
    _password.secureTextEntry= YES;
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    
    //    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    //sharesdk  
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    
    //网络请求
    self.requestCtrl = [[HSRequestDataController alloc]init];

}


- (void)viewTapped:(UITapGestureRecognizer *)tap{
    if([self.phoneNumber isFirstResponder]){
        [self.phoneNumber resignFirstResponder];
    }
    else if([self.checkNumber isFirstResponder]){
        [self.checkNumber resignFirstResponder];
    }
    else if([_password isFirstResponder]){
        [_password resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerSubmit:(id)sender {
    
    //todo for测试
//    [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];

        if (self.checkNumber.text == nil || self.checkNumber.text.length == 0 || [[self.checkNumber.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
            ShowHud(@"验证码不能为空", NO);
            return ;
        }
    [self doVerificationCodeCheck];
}

- (IBAction)getCheckNum:(id)sender {
    if (self.phoneNumber.text == nil || self.phoneNumber.text.length == 0 || [[self.phoneNumber.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        ShowHud(@"账号名称不能为空", NO);
        return;
    }
    [self checkPhoneValidated];

}

- (BOOL)passwordCheck{
    if (_password.text == nil || _password.text.length == 0 || [[_password.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        ShowHud(@"密码不能为空", NO);
        return NO;
    }
    return  YES;
}
- (IBAction)weixinRegister:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiTimeline];
            //提交微信资料
            NSString *uid = [[NSString alloc] initWithFormat:@"%@",[credential uid]];
            NSString *nickname = [[NSString alloc] initWithFormat:@"%@",[userInfo nickname]];
            //user_uuid
            NSLog(@"umtokenid:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"]);
            NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
            
            //首先判断是否已经在我们平台，是的话直接登陆，否则注册后登陆
            NSDictionary *dicForThird = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         uid,@"uid",
                                         @"0",@"thirdSource",
                                         @"1",@"user_login_platform",
                                         uuid,@"user_mac",
                                         nil];
            NSDictionary *requestDataForThird = [[NSDictionary alloc] initWithObjectsAndKeys:[dicForThird JSONString],@"requestData", nil];
            [self.requestCtrl doThirdIdCheck:requestDataForThird
                                andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                    if(code){
                                        NSDictionary *userInfoFromCheck = responseObject;
                                        if([[userInfoFromCheck objectForKey:@"user_id"] isEqualToString:@"-10086"]){
                                            //用户没有登陆过，需要注册
                                            //头像上传七牛，todo，有问题
                                            NSString *profileImage = [[NSString alloc] initWithFormat:@"%@",[userInfo profileImage]];
                                            
                                            [self avarlImageHandler:profileImage andRequestCB:^(BOOL code, NSString* imgUrl, NSString* error){
                                                if(code){
                                                    
                                                    NSString *educations = [[NSString alloc] initWithFormat:@"%@",[userInfo educations]];
                                                    NSString *gender = [[NSString alloc] initWithFormat:@"%ld",(long)[userInfo gender]];
                                                    NSString *work = [[NSString alloc] initWithFormat:@"%@",[userInfo works]];
                                                    
                                                    
                                                    //!!!!!birthday 为空
                                                    //NSString *birthday = [[NSString alloc] initWithFormat:@"%@",[userInfo birthday]];
                                                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                         uid,@"uid",
                                                                         @"0",@"thirdSource",
                                                                         gender,@"sex",
                                                                         nickname,@"nickname",
                                                                         imgUrl,@"profileImage",   //此时图片路径为七牛的
                                                                         educations,@"educations",
                                                                         work,@"work",
                                                                         @"1",@"user_login_platform",
                                                                         uuid,@"user_mac",
                                                                         nil];
                                                    
                                                    NSMutableDictionary *dicCopy = [[NSMutableDictionary alloc] init];
                                                    for (id item in dic) {
                                                        if ([[dic objectForKey:item] isEqualToString:@"(null)"]) {
                                                            [dicCopy setValue:@"" forKey:item];
                                                        }else{
                                                            [dicCopy setValue:[dic objectForKey:item] forKey:item];
                                                        }
                                                    }
                                                    
                                                    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dicCopy JSONString],@"requestData", nil];
                                                    //头像上传七牛成功，写入后台
                                                    [self.requestCtrl doThirdLogin:requestData
                                                                      andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                                                          if(code){
                                                                              
                                                                              //将个人信息存取到本地
                                                                              [self saveName:nickname];
                                                                              [self saveSex:gender];
                                                                              
                                                                              ShowHud(@"登录成功", NO);
                                                                              [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                                                              
                                                                              if([[responseObject objectForKey:@"user_id"] isKindOfClass:[NSString class]]){
                                                                                  
                                                                                  [self setUserID:[responseObject objectForKey:@"user_id"]];
                                                                              }
                                                                              else{
                                                                                  NSLog(@"没有返回id,id不是string");
                                                                              }
                                                                              //进入信息补全页面
                                                                              HSInfoCompletingVC *infoVC = [[HSInfoCompletingVC alloc]init];
                                                                              [self presentViewController:infoVC animated:YES completion:nil];
                                                                              
                                                                          }
                                                                          else{
                                                                              ShowHud(@"登录失败", NO);
                                                                              NSLog(@"%@",error);
                                                                              
                                                                          }
                                                                      }];
                                                }
                                                else{
                                                    ShowHud(@"登录失败,请重试", NO);
                                                    NSLog(@"头像上传有问题");
                                                }
                                            }];
                                            
                                        }else{
                                            //用户已经登陆过，不需要注册
                                            [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                            [self setUserID:[responseObject objectForKey:@"user_id"]];
                                            [self.view removeFromSuperview];
                                            
                                            [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
                                        }
                                    }else{
                                        NSLog(@"网络请求有误:%@",error);
                                    }
                                }];
           
            
        }
    }];

}

- (IBAction)weiboRegister:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
            NSString *uid = [[NSString alloc] initWithFormat:@"%@",[credential uid]];
            NSString *nickname = [[NSString alloc] initWithFormat:@"%@",[userInfo nickname]];
            NSString *profileImage = [[NSString alloc] initWithFormat:@"%@",[userInfo profileImage]];
            NSString *educations = [[NSString alloc] initWithFormat:@"%@",[userInfo educations]];
            NSString *gender = [[NSString alloc] initWithFormat:@"%ld",(long)[userInfo gender]];
            NSString *work = [[NSString alloc] initWithFormat:@"%@",[userInfo works]];
            //user_uuid
            NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
            
            //首先判断是否已经在我们平台，是的话直接登陆，否则注册后登陆
            NSDictionary *dicForThird = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         uid,@"uid",
                                         @"0",@"thirdSource",
                                         @"1",@"user_login_platform",
                                         uuid,@"user_mac",
                                         nil];
            NSDictionary *requestDataForThird = [[NSDictionary alloc] initWithObjectsAndKeys:[dicForThird JSONString],@"requestData", nil];
            [self.requestCtrl doThirdIdCheck:requestDataForThird
                                andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                    if(code){
                                        NSDictionary *userInfoFromCheck = responseObject;
                                        if([[userInfoFromCheck objectForKey:@"user_id"] isEqualToString:@"-10086"])
                                        {
                                            
                                            //!!!!!birthday 为空
                                            //NSString *birthday = [[NSString alloc] initWithFormat:@"%@",[userInfo birthday]];
                                            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 uid,@"uid",
                                                                 @"1",@"thirdSource",
                                                                 gender,@"sex",
                                                                 nickname,@"nickname",
                                                                 profileImage,@"profileImage",
                                                                 educations,@"educations",
                                                                 work,@"work",
                                                                 @"1",@"user_login_platform",
                                                                 uuid,@"user_mac",
                                                                 nil];
                                            
                                            NSMutableDictionary *dicCopy = [[NSMutableDictionary alloc] init];
                                            for (id item in dic) {
                                                if ([[dic objectForKey:item] isEqualToString:@"(null)"]) {
                                                    [dicCopy setValue:@"" forKey:item];
                                                }else{
                                                    [dicCopy setValue:[dic objectForKey:item] forKey:item];
                                                }
                                            }
                                            
                                            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dicCopy JSONString],@"requestData", nil];
                                            
                                            [self.requestCtrl doThirdLogin:requestData
                                                              andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                                                  if(code){
                                                                      
                                                                      //将个人信息存取到本地
                                                                      [self saveName:nickname];
                                                                      [self saveSex:gender];
                                                                      
                                                                      ShowHud(@"登录成功", NO);
                                                                      [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                                                      
                                                                      if([[responseObject objectForKey:@"user_id"] isKindOfClass:[NSString class]]){
                                                                          
                                                                          [self setUserID:[responseObject objectForKey:@"user_id"]];
                                                                      }
                                                                      else{
                                                                          NSLog(@"没有返回id,id不是string");
                                                                      }
                                                                      //需要个人信息补全
                                                                      HSInfoCompletingVC *infoVC = [[HSInfoCompletingVC alloc]init];
                                                                      [self presentViewController:infoVC animated:YES completion:nil];
                                                                      
                                                                  }
                                                                  else{
                                                                      ShowHud(@"登录失败", NO);
                                                                      NSLog(@"%@",error);
                                                                      
                                                                  }
                                                              }];
                                            
                                        }else{
                                            //用户已经登陆过，不需要注册
                                            [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                            [self setUserID:[responseObject objectForKey:@"user_id"]];
                                            [self.view removeFromSuperview];
                                            
                                            [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
                                        }
                                    }else{
                                        NSLog(@"网络请求有误:%@",error);
                                    }
                                }];
          
            
        }
    }];
}


//  请求数据完成后的处理
- (void)checkPhoneValidated
{
   
    //构造请求数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneNumber.text,@"user_phone",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    NSLog(@"%@",requestData);
    [self.requestCtrl doPhoneVerify:requestData
                      andRequestCB:^(BOOL code, id responseObject, NSString *error){
                          if(code){
                              [self.requestCtrl doVerificationCodeSend:requestData
                                                 andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                                     if(code){
                                                        ShowHud(@"发送验证码成功", NO);
                                                     }
                                                     else{
                                                         ShowHud(@"发送验证码失败", NO);                                                         
                                                     }
                                                 }];
                          }
                          else{
                              self.phoneNumber.text = @"";
                              ShowHud(@"请输入未注册的手机号", NO);
                              
                          }
                      }];
    
}

#pragma doVerificationCodeCheck
- (void) doVerificationCodeCheck{
     if([self passwordCheck ]){
    //构造请求数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneNumber.text,@"user_phone",self.checkNumber.text,@"checkCode",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    NSLog(@"%@",requestData);
         
         [self.requestCtrl doVerificationCodeCheck:requestData
                                     andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                         if(code){
                                             ShowHud(@"校验成功", NO);
                                             
                                             [self postPasswordRequestComplete];
                                         }
                                         else{
                                             ShowHud(@"校验失败，请重新获取验证码", NO);
                                             _password.text = @"";
                                             _checkNumber.text = @"";
                                         }
                                     }];
         
     }
}
#pragma mark 关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 密码注册
//  请求数据完成后的处理
- (void)postPasswordRequestComplete
{
    //构造请求数据
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         _phoneNumber.text,@"user_phone",
                         _password.text,@"user_login_pwd",
                         @"1",@"user_login_platform",
                         nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    NSLog(@"%@",requestData);

    [self.requestCtrl doRegister:requestData
                                 andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                     if(code){
                                         NSLog(@"%@",@"注册成功");
                                         //销毁AlertView
                                         ShowHud(@"注册成功", NO);
                                         //TODO !!!!!!!!!!!!!!!用户登录信息持久化
                                         
                                         [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                         [self setUserID:[responseObject objectForKey:@"user_id"]];
                                         
                                         //因为是注册，所以肯定要进入信息补全页
                                         //记录是通过手机号进入的信息补全页，这个时候不用加载个人信息，因为没有
                                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"enterInfoCompletingVCByPhone"];
                                         
                                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hasRegistered"];
                                         HSInfoCompletingVC *infoVC = [[HSInfoCompletingVC alloc]init];
                                         [self presentViewController:infoVC animated:YES completion:nil];

                                     }
                                     else{
                                         ShowHud(@"登录失败", NO);
                                         _password.text = @"";
                                         _checkNumber.text = @"";
                                     }
                                 }];
    
    
}
#pragma mark -持久化user_token
/**
 *  持久化user_token
 *
 *  @param usertoken
 */
-(void) setUserToken:(NSString*)usertoken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:usertoken forKey:@"user_token"];
    [userDefaults synchronize];
}

#pragma mark -获取持久化的user_token
/**
 *  获取持久化的user_token
 *
 *  @return 返回user_token
 */
-(NSString*) getUserToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"user_token"];
}

#pragma mark -删除user_token
/**
 *  删除user_token
 */
-(void) removeUserToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_token"];
     [userDefaults synchronize];
}


#pragma mark setuserid
-(void) setUserID:(NSString*)setUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:setUserID forKey:@"user_id"];
    [userDefaults synchronize];
}


#pragma mark 将第三方头像变为系统头像处理
- (void) avarlImageHandler:(NSString *)url andRequestCB:(void(^)(BOOL ,NSString *, NSString *))CallBack{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSString *fileName= url; //必须
    NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
    NSString *data = [dic JSONString];
    NSDictionary *requestData = @{@"requestData"  : data};
    //        NSLog(@"data:%@",data);
    //        NSString * requestAddress = @"http://121.41.104.156:8888/Infra/Storage/Qiniu/getQiniuUpToken";
    
    //      后台交互
    [self.requestCtrl getQiniuUpTokenWithParam:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            NSString *saveKey = [responseObject objectForKey:@"saveKey"];
            NSString *upToken = [responseObject objectForKey:@"upToken"];
            //先请求头像数据
            self.tmpImgView = [[UIImageView alloc]init];
//            NSURL * urlLogo = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            [self.tmpImgView sd_setImageWithURL:urlLogo
//                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                          
//                                          if(image){
//                                              NSData* dataImag = UIImageJPEGRepresentation(image, 1);
//                                              [upManager putData:dataImag key:saveKey token:upToken
//                                                        complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                                                            //                                  将key存入数组
//                                                            if(resp){
//                                                                NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
//                                                                [[NSUserDefaults standardUserDefaults] setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
//                                                                //用户头像url持久化
//                                                                [[NSUserDefaults standardUserDefaults] setObject:imgUrl  forKey:@"user_logo_url"];
//                                                                return CallBack(true, imgUrl,@"");
//                                                            }
//                                                        }
//                                                          option:nil
//                                               ];
//                                          }
//                                          else{
//                                              NSLog(@"头像上传失败，请重试");
//                                          }
//                                      }];
           
            [HSDataFormatHandle getImageWithUri:url isYaSuo:true imageTarget:self.tmpImgView defaultImage:nil andRequestCB:^(UIImage *image) {
                if(image){
                    NSData* dataImag = UIImageJPEGRepresentation(image, 1);
                    [upManager putData:dataImag key:saveKey token:upToken
                              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                  //                                  将key存入数组
                                  if(resp){
                                      NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
                                      [[NSUserDefaults standardUserDefaults] setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
                                      //用户头像url持久化
                                      [[NSUserDefaults standardUserDefaults] setObject:imgUrl  forKey:@"user_logo_url"];
                                      return CallBack(true, imgUrl,@"");
                                  }
                              }
                                option:nil
                     ];
                }
                else{
                    NSLog(@"头像上传失败，请重试");
                }
            }];
            
        }
        else{
            return CallBack(false,@"", @"fail");
        }
    }];
    
}

#pragma mark 资料补全页所需的信息缓存
/*
 设置用户性别
 */
- (void) saveSex:(id)sex{
    
    NSString *user_sex = [HSDataFormatHandle handleNumber:sex];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //性别
    [userDefaults setObject:user_sex forKey:@"user_sex"];
    
}
/*
 设置用户昵称
 */
- (void) saveName:(id)name{
    
    NSString *nickName = [HSDataFormatHandle handleNumber:name];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //昵称
    NSString *user_nickname = [[NSString alloc] initWithString:
                               [nickName isEqualToString:
                                @"-10086"]?@"" : nickName];
    [userDefaults setObject:user_nickname forKey:@"user_nickname"];
    
}
@end
