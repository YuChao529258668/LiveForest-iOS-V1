//
//  HSLoadViewController.m
//  HotSNS
//
//  Created by Swift on 15/3/27.
//  Copyright (c) 2015年 余超. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSViewController.h"
#import "HSRegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
//#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SingletonForRootViewCtrl.h"

#import "WXApi.h"
#import "WeiboSDK.h"

@interface HSLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *whoTF;
@property (strong, nonatomic) IBOutlet UITextField *passworldTF;
- (IBAction)jumpBtn:(UIButton *)sender;
@property(strong,nonatomic) HSUserInfoHandler* hSUserInfoHandler;
@end

@implementation HSLoginViewController

- (IBAction)registerPress:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:[[HSRegisterViewController alloc]init] animated:YES completion:nil];
//    [self.view removeFromSuperview];
    
    [self presentViewController:[[HSRegisterViewController alloc]init] animated:NO completion:nil];
}

- (void)loadView{
    
  
//    NSArray *arrayOfViews;
//    if([UIScreen mainScreen].bounds.size.height==568) {
        //            self=[[HSLoginViewController alloc]initWithNibName:@"HSLoginViewController" bundle:[NSBundle mainBundle]];
        //            self = [HSLoginViewController alloc] loa
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"HSLoginViewController" owner:self options:nil] firstObject];
        
//        //loadNibName
//    } else if([UIScreen mainScreen].bounds.size.height==667) {
////        self=[[HSLoginViewController alloc]initWithNibName:@"HSLoginViewController@2x" bundle:[NSBundle mainBundle]];
//        self.view = [[[NSBundle mainBundle] loadNibNamed:@"HSLoginViewController@2x" owner:self options:nil] firstObject];
//    } else if([UIScreen mainScreen].bounds.size.height==480) {
////        self=[[HSLoginViewController alloc]initWithNibName:@"HSLoginViewController@4s" bundle:[NSBundle mainBundle]];
//        self.view = [[[NSBundle mainBundle] loadNibNamed:@"HSLoginViewController@4s" owner:self options:nil] firstObject];
//    }
//    else {
////        self=[[HSLoginViewController alloc]initWithNibName:@"HSLoginViewController@3x" bundle:[NSBundle mainBundle]];
//        self.view = [[[NSBundle mainBundle] loadNibNamed:@"HSLoginViewController@3x" owner:self options:nil] firstObject];
//    }
    
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

-(instancetype)init {
    self=[super init];
    
    self.requestCtrl = [[HSRequestDataController alloc]init];
    
    if (self) {
        
//        self.passworldTF = [[UITextField alloc]init];
//        self.whoTF = [[UITextField alloc]init];
        
      //        NSLog(@"passworldTF:%@",self.passworldTF);
    }
    
    self.hSUserInfoHandler = [[HSUserInfoHandler alloc]init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"viewDidLoad");
    
    self.whoTF.text = @"";
    self.passworldTF.text = @"";
    
    self.whoTF.placeholder = @"手机号";
    self.whoTF.delegate = self;
    self.passworldTF.placeholder = @"密码";
    self.passworldTF.delegate = self;
    
    //设置placeHolder的颜色
    [self.whoTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passworldTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.whoTF.keyboardType = UIKeyboardTypeNumberPad;
    self.passworldTF.keyboardType = UIKeyboardTypeDefault;
    self.passworldTF.secureTextEntry= YES;
    
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
}
#pragma -mark -忘记密码
- (IBAction)forgetBtnClick:(id)sender {
}
#pragma mark -登陆事件


/**
 *  登陆按钮
 *
 *  @param sender sender button
 */
- (IBAction)loadBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self readyLogin];
}

#pragma mark -检测账号密码是否为空
/**
 *  检测账号密码
 */
- (void)readyLogin
{
    if (self.whoTF.text == nil || self.whoTF.text.length == 0 || [[self.whoTF.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        ShowHud(@"账号名称不能为空", NO);
        return;
    }
    if (self.passworldTF.text == nil || self.passworldTF.text.length == 0 || [[self.passworldTF.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        ShowHud(@"密码不能为空", NO);
        return ;
    }
    
    //发起网络请求，账号&密码登陆
    [self postRequestComplete];
}

//#pragma mark -AFNetworking初始化
///**
// *  AFNetworking初始化，申明使用JSON解析器，申明接受的数据类型为 text/html text/plain text/json application/json
// */
//-(void)httpInit{
//    self.manager = [AFHTTPRequestOperationManager manager];
//    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    self.manager.responseSerializer.acceptableContentTypes =[[NSSet alloc]
//                                                             initWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", nil];
//}


#pragma mark -请求数据，并处理
/**
 *  请求数据，并在回调函数（代码块中）处理
 */
- (void)postRequestComplete
{
    //销毁键盘
    [_whoTF resignFirstResponder];
    [_passworldTF resignFirstResponder];
    
    
    
    //构造请求数据
    //user_uuid
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         _whoTF.text,@"user_phone",
                         _passworldTF.text,@"user_login_pwd",
                         @"1",@"user_login_platform",
                         uuid,@"user_mac",
                         nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    
    [self.requestCtrl doLogin:requestData
                                andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                    if(code){
                                        ShowHud(@"登录成功", NO);
                                        [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                        
                                        if([[responseObject objectForKey:@"user_id"] isKindOfClass:[NSString class]]){
                                            
                                            [self setUserID:[responseObject objectForKey:@"user_id"]];
                                        }
                                        else{
                                            NSLog(@"没有返回id,id不是string");
                                        }
//                                        [self.view removeFromSuperview];
                                        //因为是手机号登陆，所以肯定已经注册过了
                                        [self.view removeFromSuperview];
                                        [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
//                                        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasRegistered"] isEqualToString:@"1"]){
//                                            
//                                            
//                                        }
//                                        else{
//                                            //保存用户已经注册，下次微信登陆不进入信息补全页面
//                                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hasRegistered"];
//                                            HSInfoCompletingVC *infoVC = [[HSInfoCompletingVC alloc]init];
//                                            [self presentViewController:infoVC animated:YES completion:nil];
//                                        }
                                    }
                                    else{
                                        ShowHud(@"登录失败", NO);
                                        self.passworldTF.text = @"";
                                        NSLog(@"%@",error);

                                    }
    }];

}

#pragma mark 使用md5加密
/**
 *  MD5加密函数
 *
 *  @param str 输入字符串
 *
 *  @return 返回加密字符串
 */
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
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
-(void) setUserID:(NSString*)setUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:setUserID forKey:@"user_id"];
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



#pragma mark
#pragma mark -随便看看
/**
 *  随便看看
 *
 *  @param sender sender button
 */
- (IBAction)jumpBtn:(UIButton *)sender {
    HSViewController *tabBarControl = [[HSViewController alloc] init];
    
    //todo
    [self setUserToken:@"ha6loqWgRkxgF4aT2q2O1yJAXGqiUoxc8dSWfp2c6Js3D"];
    [self presentViewController:tabBarControl animated:YES completion:nil];
}

#pragma mark -微信登陆
/**
 *  微信登陆
 *
 *  @param sender 微信登陆
 */
- (IBAction)weiXinBtnClick:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiTimeline];
            //提交微信资料
            NSString *uid = [[NSString alloc] initWithFormat:@"%@",[[[userInfo credential] extInfo] objectForKey:@"unionid"]];
            NSString *nickname = [[NSString alloc] initWithFormat:@"%@",[userInfo nickname]];
            NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"];
            
            //封装当前基本的用户信息
            NSMutableDictionary* userInfoDict = [[NSMutableDictionary alloc] init];
            
            //获取用户uid信息
            [userInfoDict setObject:[[[userInfo credential] extInfo] objectForKey:@"unionid"] forKey:@"openId"];
            
            //获取用户昵称
            [userInfoDict setObject:[userInfo nickname] forKey:@"nickname"];
            
            //获取用户头像
            [userInfoDict setObject:[userInfo profileImage] forKey:@"profileImage"];
            
            //更新当前本地缓存的微信信息
            [self.hSUserInfoHandler updateUserWechatInfo:userInfoDict];
            
            
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
                                            
                                            //头像上传七牛
                                            NSString *profileImage = [[NSString alloc] initWithFormat:@"%@",[userInfo profileImage]];
                                            
                                            [self avarlImageHandler:profileImage andRequestCB:^(BOOL code, NSString* imgUrl, NSString* error){
                                                if(code){
                                                    
                                                    NSString *educations = [[NSString alloc] initWithFormat:@"%@",[userInfo educations]];
                                                    NSString *gender = [[NSString alloc] initWithFormat:@"%ld",(long)[userInfo gender]];
                                                    NSString *work = [[NSString alloc] initWithFormat:@"%@",[userInfo works]];
                                                    
                                                    //user_uuid
                                                    NSLog(@"umtokenid:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UMtokenId"]);
                                                   
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
                                                                              
//                                                                              [self.view removeFromSuperview];
                                                                              //如果是 第一次，需要个人信息补全
                                                                                  //                     保信息补全页面
                                                                                  HSInfoCompletingVC *infoVC = [[HSInfoCompletingVC alloc]init];
                                                                                  [self presentViewController:infoVC animated:YES completion:nil];
                                                                              
                                                                              
                                                                              
                                                                          }
                                                                          else{
                                                                              ShowHud(@"登录失败", NO);
                                                                              //                                                        self.passworldTF.text = @"";
                                                                              NSLog(@"%@",error);
                                                                              
                                                                          }
                                                                      }];
                                                }
                                                else{
                                                    ShowHud(@"登录失败,请重试", NO);
                                                    NSLog(@"头像上传有问题");
                                                }
                                            }];
                                        }
                                        else{
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

#pragma mark -微博登录
/**
 *  微博登录
 *
 *  @param sender sender button
 *
 */
- (IBAction)weiBoxBtnClick:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
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
                                        @"1",@"thirdSource",
                                         @"1",@"user_login_platform",
                                         uuid,@"user_mac",
                                         nil];
            NSDictionary *requestDataForThird = [[NSDictionary alloc] initWithObjectsAndKeys:[dicForThird JSONString],@"requestData", nil];
            [self.requestCtrl doThirdIdCheck:requestDataForThird
                              andRequestCB:^(BOOL code, id responseObject, NSString *error){
                                  if(code){
                                      NSDictionary *userInfo = responseObject;
                                      if([[userInfo objectForKey:@"user_id"] isEqualToString:@"-10086"]){
                                          //表示不存在用户信息
                                          
                                          //头像上传七牛
                                          [self avarlImageHandler:profileImage andRequestCB:^(BOOL code, NSString* imgUrl, NSString* error){
                                              if(code){
                                                  
                                                  //!!!!!birthday 为空
                                                  //NSString *birthday = [[NSString alloc] initWithFormat:@"%@",[userInfo birthday]];
                                                  NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                       uid,@"uid",
                                                                       @"1",@"thirdSource",
                                                                       gender,@"sex",
                                                                       nickname,@"nickname",
                                                                       imgUrl,@"profileImage",
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
                                                                            
                                                                                //进入信息补全页面
                                                                                HSInfoCompletingVC *infoVC = [[HSInfoCompletingVC alloc]init];
                                                                                [self presentViewController:infoVC animated:YES completion:nil];
                                                                            
                                                                        }
                                                                        else{
                                                                            ShowHud(@"登录失败", NO);
                                                                            self.passworldTF.text = @"";
                                                                            NSLog(@"%@",error);
                                                                            
                                                                        }
                                                                    }];
                                              }
                                              else{
                                                  ShowHud(@"头像上传失败", NO);
                                              }}];
                                         
                                      }
                                      else{
                                          //用户已经存在，直接进入应用
                                          [self setUserToken:[responseObject objectForKey:@"user_token"]];
                                          [self setUserID:[responseObject objectForKey:@"user_id"]];
                                          [self.view removeFromSuperview];
                                          
                                          [[UIApplication sharedApplication] keyWindow].rootViewController = [SingletonForRootViewCtrl sharedInstance];
                                          
                                      }
                                  }
                                  else{
                                      NSLog(@"网络请求有误:%@",error);
                                  }
                              }];
            
          
            
        }
    }];
    
}






#pragma mark

//给下一个界面传递用户信息
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
//设置为密码输入状态
- (IBAction)editingDidBegin:(id)sender {
}

//如果什么都没输入的话，设置初始提示文字
- (IBAction)editingDidEnd:(id)sender {
}

//关闭键盘
- (IBAction)closeKeyboard:(id)sender {
    if([self.whoTF isFirstResponder])
        [self.whoTF resignFirstResponder];
    else if([self.passworldTF isFirstResponder])
        [self.passworldTF resignFirstResponder];
}

#pragma 关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    //判断是否是密码键盘
    if(textField == self.passworldTF){
        [self readyLogin];
    }
    
    
    return YES;
}
- (IBAction)returnCloseKeyboard:(id)sender {
    [self.whoTF resignFirstResponder];
    [self.passworldTF resignFirstResponder];
    
}

#pragma mark 头像处理
- (void) avarlImageHandler:(NSString *)url andRequestCB:(void(^)(BOOL ,NSString *, NSString *))CallBack{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSString *fileName= url; //必须
    NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
    NSString *data = [dic JSONString];
    NSDictionary *requestData = @{@"requestData"  : data};
    
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
//                                              if(image){
//                                                  NSData* dataImag = UIImageJPEGRepresentation(image, 1);
//                                                  [upManager putData:dataImag key:saveKey token:upToken
//                                                            complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                                                                if(resp){
//                                                                    [[NSUserDefaults standardUserDefaults] setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
//                                                                    
//                                                                    NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
//                                                                    //用户头像url持久化
//                                                                    [[NSUserDefaults standardUserDefaults] setObject:imgUrl  forKey:@"user_logo_url"];
//                                                                    return CallBack(true, imgUrl,@"");
//                                                                }
//                                                            }
//                                                               option:nil
//                                                                ];
//                                              }
//                                              else{
//                                                  NSLog(@"头像上传失败，请重试");
//                                                  return CallBack(false,@"", @"头像上传失败，请重试");
//                                              }
//                                      }];
            [HSDataFormatHandle getImageWithUri:url isYaSuo:true imageTarget:self.tmpImgView defaultImage:[UIImage imageNamed:@"default"] andRequestCB:^(UIImage *image) {
                if(image){
                    NSData* dataImag = UIImageJPEGRepresentation(image, 1);
                    [upManager putData:dataImag key:saveKey token:upToken
                              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                  if(resp){
                                      [[NSUserDefaults standardUserDefaults] setObject:dataImag forKey:@"user_logo_img"]; //直接存取到本地
                                      
                                      NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
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
                    return CallBack(false,@"", @"头像上传失败，请重试");
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
