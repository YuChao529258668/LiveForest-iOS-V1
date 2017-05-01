//
//  HSRequestDataController.m
//  LiveForest
//
//  Created by 微光 on 15/6/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSRequestDataController.h"

#import "HSLoginViewController.h"

@interface HSRequestDataController ()
@end

@implementation HSRequestDataController

@synthesize manager = _manager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AFNetworking初始化
-(void)httpInit{
    //如果没有初始化
//    if(!_manager){ //不可以，这种方法会造成同步，单例模式的缺陷，因此应该创建多个对象，为了速度
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    self.manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html",@"text/plain",@"text/json", nil];
    _manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", nil];
//    }
}

//wf 懒加载数据处理类  todo
-(HSDataFormatHandle *)dataFormatHandle
{
    if (_dataFormatHandle == nil) {
        _dataFormatHandle = [[HSDataFormatHandle alloc]init];
    }
    return _dataFormatHandle;
}

#pragma mark 通用请求接口1:返回三个结果
-(void)getDataWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(BOOL code, id responseObject, NSString *error))CallBack{
    
    if(!requestData || !url)
    {
        return CallBack(false,nil,@"请求参数缺失");
    }
    else{
        
        [self httpInit];
        
        [self.manager POST:url
                parameters:requestData
                   success:^(AFHTTPRequestOperation *operation, id responseObject){
                       
                       if ([[responseObject objectForKey:@"code"] intValue]==0) {
                           //需要数据处理
                           return CallBack(true,responseObject,nil);
                       }
                       else{
                           
                           int subCode = [[responseObject objectForKey:@"subCode"] intValue];
                           
                           NSString *error = @"";
                           
                           switch (subCode) {
                               case 0:
                                   error = @"请求参数缺失";
                                   break;
                                   case 1 :
                                   error = @"用户鉴权失败";
                                   
                                   ShowHud(@"鉴权失败，请重新登陆", NO);
                                   //这个时候跳转到登陆界面
                                   //和注销处理一样
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_token"];
                                   [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];

                                   [[UIApplication sharedApplication] keyWindow].rootViewController = [[HSLoginViewController alloc]init];

                                   break;
                               default:
                                   break;
                           }
                           
//                           NSLog([NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil]);
                           NSLog(@"%@",[responseObject objectForKey:@"desc"]);
                           //需要数据处理
                           return CallBack(false,nil,[responseObject objectForKey:@"desc"]);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //fail
                       NSLog(@"请求失败，%@",error);
                       return CallBack(false,nil,@"网络请求失败，请重试");
                   }];
        
    }
    return ;
}


#pragma mark 通用请求接口2返回两个结果，只有成功地参数和错误的参数即可
-(void)getResultWithURLAndParam:(NSDictionary*)requestData andURL:(NSString*)url andRequestCB:(void(^)(bool ,NSString *))CallBack{
    
    if(!requestData || !url)
    {
        return CallBack(false,@"请求参数缺失");
    }
    else{
        
        [self httpInit];
        
        [self.manager POST:url
                parameters:requestData
                   success:^(AFHTTPRequestOperation *operation, id responseObject){
                       
                       if ([[responseObject objectForKey:@"code"] intValue]==0) {
                           //需要数据处理
                           return CallBack(true,nil);
                       }
                       else{
                           
                           int subCode = [[responseObject objectForKey:@"subCode"] intValue];
                           
                           NSString *error = @"";
                           
                           switch (subCode) {
                               case 0:
                                   error = @"请求参数缺失";
                                   break;
                               case 1 :
                                   error = @"用户鉴权失败";
                                   ShowHud(@"鉴权失败，请重新登陆", NO);
                                   //这个时候跳转到登陆界面
                                   //和注销处理一样
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_token"];
                                   [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
                                   
                                   [[UIApplication sharedApplication] keyWindow].rootViewController = [[HSLoginViewController alloc]init];
                                   
                                   break;
                               default:
                                   break;
                           }

                           //需要数据处理
                           return CallBack(false,[responseObject objectForKey:@"desc"]);
                       }
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //fail
                       NSLog(@"请求失败，%@",error);
                       return CallBack(false,@"网络请求失败，请重试");
                   }];
        
    }
    return ;
}

#pragma mark 请求七牛图片路径
-(void)getQiniuUpTokenWithParam:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s",getQiniuUpToken];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];

}


#pragma mark 请求个人信息
-(void)getPersonalInfo:(void(^)(BOOL, id ,NSString *))CallBack{
    
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getPersonInfoURL];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //todo
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
        return;
    }
    
    NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dic JSONString],@"requestData", nil];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id userInfo = [responseObject objectForKey:@"userInfo"];
            
            if([userInfo isKindOfClass:[NSDictionary class]])
            {
                userInfo = [self.dataFormatHandle handleDict:userInfo];
                return CallBack(true,userInfo,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];

}
#pragma mark getUserInfo
-(void)getUserInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getPersonInfoURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id userInfo = [responseObject objectForKey:@"userInfo"];
            
            if([userInfo isKindOfClass:[NSDictionary class]])
            {
                userInfo = [self.dataFormatHandle handleDict:userInfo];
                return CallBack(true,userInfo,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
    
}
#pragma mark 注销个人信息
-(void)doLogout:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doLogoutURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
    
}

#pragma mark 关注某人
-(void)doFollowingAttention:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doFollowingAttentionURL];
    [self getResultWithURLAndParam:requestData andURL:url andRequestCB:^(bool code, NSString *error){
        if(code){
            return CallBack(true,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,@"code不为0，返回有问题");
        }
        
    }];
    
}

#pragma mark 取消关注某人
-(void)doFollowingCancel:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doFollowingCancelURL];
    [self getResultWithURLAndParam:requestData andURL:url andRequestCB:^(bool code, NSString *error){
        if(code){
            return CallBack(true,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,@"code不为0，返回有问题");
        }
        
    }];
    
}

#pragma mark 修改头像请求接口
-(void)updatePersonLogo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
//
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonLogoURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];

}
#pragma mark 修改用户城市接口
-(void)updatePersonCity:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonCityURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
        
    }];
}
#pragma mark 修改用户生日接口
-(void)updatePersonBirthday:(NSDictionary *)requestData andRequestCB:(void (^)(BOOL, id, NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonBirthdayURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
        
    }];
}
#pragma mark 修改用户昵称
-(void)updatePersonNickname:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonNicknameURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
}

#pragma mark 修改用户运动标签
-(void)updatePersonSports:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updatePersonSportsURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
}
#pragma mark 获取用户收货地址
-(void)getPersonAddress:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
//    {"code":0,"user_address":{"user_address":[{"user_name":"ssss","detail_address":"新模范马路66号","user_phone":"1233*****","area_id":"2079"},{"user_name":"ssss","detail_address":"新模范马路66号","user_phone":"1233*****","area_id":"2079"}]}}
    NSString *url = [NSString stringWithFormat:@"%s%s",requestPrefixURL,getPersonAddressURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id user_address = [responseObject objectForKey:@"user_address"];
            if ([user_address isKindOfClass:[NSDictionary class]]) {
                id userAddressArray = [user_address objectForKey:@"user_address"];
                if([userAddressArray isKindOfClass:[NSArray class]])
                {
                    userAddressArray = [self.dataFormatHandle handleDictArray:userAddressArray];
                    return CallBack(true,userAddressArray,nil);
                }
                return CallBack(true,nil,nil);//不是数组就返回nil
            }else{
                NSLog(@"user_address不是数组类型，不合法");
                return CallBack(true,nil,nil);
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
}
#pragma mark 更新用户收货地址
-(void)updatePersonAddress:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [NSString stringWithFormat:@"%s%s",requestPrefixURL,updatePersonAddressURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
    
}
#pragma mark 原生登陆接口
-(void)doLogin:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doLoginURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}

#pragma mark 第三方登陆接口
-(void)doThirdLogin:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doThirdLoginURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];

}

#pragma mark 根据用户第三方的openId判断用户是否存在
-(void)doThirdIdCheck:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doThirdIdCheckURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
//            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                                 [HSDataFormatHandle handleNumber:[responseObject objectForKey:@"user_id"]],@"user_id",
//                                 [HSDataFormatHandle handleNumber:[responseObject objectForKey:@"user_token"]],@"user_token",
//                                  nil];
            
//            NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:dic,@"userInfo", nil];
            id userInfo= [responseObject objectForKey:@"userInfo"];
            if([userInfo isKindOfClass:[NSDictionary class]]){
                userInfo = [self.dataFormatHandle handleDict:userInfo];
                
                return CallBack(true,userInfo,nil);
            }else{
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"-10086",@"user_id",nil];
                return CallBack(true,dic,nil);
            }
           
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,error);
            
        }
        
    }];
    
}

#pragma mark 信息补全
-(void)updateUserInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updateUserInfoURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];

}

#pragma mark 注册相关
//手机号验证
-(void)doPhoneVerify:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doPhoneVerifyURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//发送验证码
-(void)doVerificationCodeSend:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doVerificationCodeSendURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//校验验证码
-(void)doVerificationCodeCheck:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doVerificationCodeCheckURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//注册信息
-(void)doRegister:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doRegisterURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}

#pragma mark 分享模块
#pragma mark 创建分享
-(void)createShareWithParam:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doShareCreate];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
    
}

//创建分享可以At活动（一个）、群组（一个）、At好友(1-3个)
-(void)doShareCreateWithAt:(NSDictionary *)requestData andRequestCB:(void (^)(BOOL, id, NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doShareCreate];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
        
    }];
    
}
//获取官方分享列表
-(void)getMPShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMPShareListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id shareList = [responseObject objectForKey:@"shareList"];
            
            if([shareList isKindOfClass:[NSArray class]])
            {
                shareList = [self.dataFormatHandle handleDictArray:shareList];
                return CallBack(true,shareList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//分享评论doShareCommentURL
-(void)doShareComment:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doShareCommentURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//分享点赞
-(void)doShareLike:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doShareLikeURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//获取分享点赞状态
-(void)getUserShareLikeState:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, BOOL ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getUserShareLikeStateURL];
    
    if(!requestData || !url)
    {
        return CallBack(false,false,@"请求参数缺失");
    }
    else{
        
        [self httpInit];
        
        [self.manager POST:url
                parameters:requestData
                   success:^(AFHTTPRequestOperation *operation, id responseObject){
                       
                       if ([[responseObject objectForKey:@"code"] intValue]==0) {
                           //需要数据处理
                           return CallBack(true,false,nil);
                       }
                       else if([[responseObject objectForKey:@"code"] intValue]==1){
                           return CallBack(true,true,nil);
                       }
                       else{
                           //需要数据处理
                           return CallBack(false,false,@"code不为0，返回有问题");
                       }
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //fail
                       NSLog(@"请求失败，%@",error);
                       return CallBack(false,false,@"网络请求失败，请重试");
                   }];
        
    }
}

//ugc 下面的小卡片
//余超
//获取系统推荐分享列表
//-(void)getFollowingShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
//    //
//    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getFollowingShareListURL];
//    
//    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
//        if(code){
//            //相应成功，对字段 做判断
//            id shareList = [responseObject objectForKey:@"shareList"];
//            
//            if([shareList isKindOfClass:[NSArray class]])
//            {
//                shareList = [self.dataFormatHandle handleDictArray:shareList];
//                return CallBack(true,shareList,nil);
//            }
//            else
//            {
//                return CallBack(true,nil,nil);//空数组就返回nil
//            }
//            
//        }
//        else{
//            
//            NSLog(@"%@",error);
//            return CallBack(false,nil,@"code不为0，返回有问题");
//            
//        }
//        
//    }];
//}

//强强版
//获取系统推荐分享列表
-(void)getFollowingShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getFollowingShareListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id shareList = [responseObject objectForKey:@"shareList"];
            
            if([shareList isKindOfClass:[NSArray class]])
            {
                shareList = [self.dataFormatHandle handleDictArray:shareList];
                return CallBack(true,shareList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
            
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}

//获取个人分享列表
-(void)getShareList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getShareListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id shareList = [responseObject objectForKey:@"shareList"];
            
            if([shareList isKindOfClass:[NSArray class]])
            {
                shareList = [self.dataFormatHandle handleDictArray:shareList];
                return CallBack(true,shareList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}

//获取分享详情
-(void)getShareInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getShareInfoURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id shareInfo = [responseObject objectForKey:@"shareInfo"];
            
            if([shareInfo isKindOfClass:[NSDictionary class]])
            {
                shareInfo = [self.dataFormatHandle handleDict:shareInfo];
                return CallBack(true,shareInfo,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}

#pragma -mark 获取评论信息
/**
 *  获取共享评论
 */
-(void)getShareComment:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getShareCommentURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject,NSString *error){
        if(code){
            
            //相应成功，对字段 做判断
            id shareComment = [responseObject objectForKey:@"shareComment"];
            //数组，要判断是否是空数组
            if([shareComment isKindOfClass:[NSArray class]])
            {
                if([shareComment count] > 0)
                {
                    shareComment = [self.dataFormatHandle handleDictArray:shareComment];
                    return CallBack(true,shareComment,nil);
                }
                else
                {
                    return CallBack(true,nil,nil);//空数组就返回nil
                }
            }
            else
            {
                NSLog(@"shareComment不是数组类型，不合法");
                return CallBack(true,nil,nil);
            }
            
            
        }
        else{
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
    return ;
}
//删除分享
-(void)doShareDelete:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doShareDeleteURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,@"code不为0，返回有问题");
            
        }
        
    }];
}

#pragma mark 活动模块
#pragma mark 创建活动 doActivityCreateByUserURL
-(void)doActivityCreateByUser:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doActivityCreateByUserURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}

//获取官方推荐活动
-(void)getMPActivityList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMPActivityListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id activityList = [responseObject objectForKey:@"activityList"];
            
            if([activityList isKindOfClass:[NSArray class]])
            {
                activityList = [self.dataFormatHandle handleDictArray:activityList];
                return CallBack(true,activityList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//获取推荐活动列表
-(void)getMixActivityList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMixActivityListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id activityList = [responseObject objectForKey:@"activityList"];
            
            if([activityList isKindOfClass:[NSArray class]])
            {
                activityList = [self.dataFormatHandle handleDictArray:activityList];
                return CallBack(true,activityList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//参加活动
-(void)doActivityAttend:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doActivityAttendURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
//取消参加
-(void)doActivityAttendCancel:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doActivityAttendCancelURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            return CallBack(true,responseObject,nil);
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
}
/**
 *  获取官方晒图活动
 *
 *  @param requestData 请求数据
 *  @param CallBack    回调块
 */
-(void)getDisplayPicActivityList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getDisplayPicActivityListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id displayPicActivityList = [responseObject objectForKey:@"displayPicActivityList"];
            
            if([displayPicActivityList isKindOfClass:[NSArray class]])
            {
                displayPicActivityList = [self.dataFormatHandle handleDictArray:displayPicActivityList];
                return CallBack(true,displayPicActivityList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];

}
/**
 *  返回官方主题晒图活动详情
 *
 *  @param requestData 请求数据
 *  @param CallBack    回调块
 */
-(void)getDisplayPicActivityInfo:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getDisplayPicActivityInfoURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //相应成功，对字段 做判断
            id activityInfo = [responseObject objectForKey:@"activityInfo"];
            if ([activityInfo isKindOfClass:[NSDictionary class]]) {
                activityInfo = [self.dataFormatHandle handleDict:activityInfo];
                return CallBack(true,activityInfo,nil);
            }
            else
            {
                return CallBack(true,nil,nil);
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            
        }
        
    }];
    
}
#pragma -mark 获取请求的群组信息
/**
 *  获取群组信息
 */
-(void)getGroupList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getGroupListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            
            //相应成功，对字段 做判断
            id groupList = [responseObject objectForKey:@"groupList"];
            //数组，要判断是否是空数组
            if([groupList count] > 0)
            {
                groupList = [self.dataFormatHandle handleDictArray:groupList];
                return CallBack(true,groupList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
            
            }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
            }
        
    }];
}




#pragma mark -  获取用户的关注或者粉丝列表列表

-(void)getFansOrFollowingList:(NSDictionary*)requestData isFans:(BOOL)isFans andRequestCB:(DidRequestBlock)CallBack{
    
    //先声明字符串
    NSString *url;
    
    if(isFans){
        //拼接获取用户粉丝列表的
        url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getFansListURL];
    }else{
        //拼接获取用户关注的人的列表
        url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getFollowingListURL];
    }
    
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            if(isFans){
                //拼接获取用户粉丝列表的
                 return CallBack(true,[responseObject objectForKey:@"fansList"],nil);
            }else{
                //调用回调函数
                return CallBack(true,[responseObject objectForKey:@"followingList"],nil);
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
        
    }];
}

#pragma mark - 获取好友列表
-(void)getFriendsList:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL, id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getFriendsListURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            
            //相应成功，对字段 做判断
            id friendsList = [responseObject objectForKey:@"friendsList"];
            //数组，要判断是否是空数组
            if([friendsList count] > 0)
            {
                friendsList = [self.dataFormatHandle handleDictArray:friendsList];
                return CallBack(true,friendsList,nil);
            }
            else
            {
                return CallBack(true,nil,nil);//空数组就返回nil
            }
        }
        else{
            
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
        
    }];

    
}

#pragma mark 根据手机号绑定第三方
-(void)doThirdBind:(NSDictionary*)requestData andRequestCB:(DidRequestBlock)CallBack{

    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doThirdBindURL];
    
    //构造请求数据
    [self getDataWithURLAndParam:[self requestDataWrapper:requestData] andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            NSLog([responseObject JSONString]);
            return CallBack(code,responseObject,error);
        }
        else{
            return CallBack(false,nil,error);
        }
    }];
}

#pragma mark 根据第三方绑定手机号
-(void)doUserPhoneBind:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack{
    
    //构造请求地址
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doUserPhoneBindURL];
    
    //构造请求数据
    [self getDataWithURLAndParam:[self requestDataWrapper:requestData] andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            //请求成功，调用回调函数
            CallBack(code,responseObject,error);
        }
        else{
            return CallBack(false,nil,error);
        }
    }];
}



#pragma mark 二维码
//生成二维码
-(void)doQRcodeCreate:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doQRcodeCreateURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            id encodeUserInfo= [responseObject objectForKey:@"encodeUserInfo"];
            encodeUserInfo = [HSDataFormatHandle handleNumber:encodeUserInfo];
            return CallBack(true,encodeUserInfo,nil);
        }
        else{
            return CallBack(false,nil,error);
        }
    }];
    
}

//扫描二维码
-(void)doQRcodeScan:(NSDictionary*)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack{
    //
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doQRcodeScanURL];
    [self getResultWithURLAndParam:requestData andURL:url andRequestCB:^(bool code, NSString *error){
        if(code){
            return CallBack(true,nil);
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,error);
        }
        
    }];
    
}

#pragma mark - Intern Helper

#pragma mark 处理请求数据，添加md5、加密、压缩等操作
- (NSDictionary*)requestDataWrapper:(NSDictionary*)requestRawData{
    
    //待处理的请求字典
    NSMutableDictionary* requestData;
    
    //如果传入的是原始数据，即没有经过requestData封装的
    if(![requestRawData objectForKey:@"requestData"]){
        requestData = [NSMutableDictionary dictionaryWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[requestRawData JSONString],@"requestData", nil]];
    }else{
        //如果已经经过了requestData封装
        requestData = [NSMutableDictionary dictionaryWithDictionary:requestRawData];
    }
    
    //对于requestData数据进行加密操作
    
    //对于requestData数据进行MD5操作
    
    
    
    return requestData;

}

#pragma mark - 约伴模块
#pragma mark 创建约伴
- (void)doYueBanCreateByUser:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL, doYueBanCreateByUserURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            return CallBack(true,responseObject,nil);
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];

    
}
#pragma mark 获取熟人的推荐列表
- (void)getYueBanListFromFriends:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getYueBanListFromFriendsURL ];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            id yuebanListFromFriends = [responseObject objectForKey:@"yuebanList"];
            if([yuebanListFromFriends count]>0)
            {
                yuebanListFromFriends = [self.dataFormatHandle handleDictArray:yuebanListFromFriends];
                return CallBack(true,yuebanListFromFriends,nil);
            }else{
                return CallBack(true,nil,nil);
            }
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
    
}

#pragma mark 获取陌生人的推荐列表
- (void)getYueBanListFromStrangers:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack
{
    
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getYueBanListFromStrangersURL ];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            id yuebanListFromStrangers = [responseObject objectForKey:@"yuebanList"];
//            if([yuebanListFromStrangers count]>0)
//            {
//                yuebanListFromStrangers = [self.dataFormatHandle handleDictArray:yuebanListFromStrangers];
                return CallBack(true,yuebanListFromStrangers,nil);
//            }else{
//                return CallBack(true,nil,nil);
//            }
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];

}

#pragma mark 用户参与/拒绝约伴
- (void)updataUserYueBanState:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL , NSString*))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,updataUserYueBanStateURL];
    
    [self getResultWithURLAndParam:requestData andURL:url andRequestCB:^(bool code, NSString *error) {
        if (code) {
            return CallBack(true,nil);
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,@"code不为0,返回有问题");
        }
    
    }];
}

#pragma mark  获取我的约伴列表
- (void)getMyYueBanDetailList:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack
{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMyYueBanDetailListURL ];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            id myYueBanDetailList = [responseObject objectForKey:@"myYueBanDetailList"];
            if([myYueBanDetailList count]>0)
            {
                myYueBanDetailList = [self.dataFormatHandle handleDictArray:myYueBanDetailList];
                return CallBack(true,myYueBanDetailList,nil);
            }else{
                return CallBack(true,nil,nil);
            }
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
}
#pragma mark 获取我参与的约伴的历史记录的列表
-(void)getMyAttendYueBanList:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,id ,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMyAttendYueBanListURL ];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            id myAttendYueBanList = [responseObject objectForKey:@"yuebanList"];
            if([myAttendYueBanList count]>0)
            {
                myAttendYueBanList = [self.dataFormatHandle handleDictArray:myAttendYueBanList];
                return CallBack(true,myAttendYueBanList,nil);
            }else{
                return CallBack(true,nil,nil);
            }
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
    
}
#pragma mark 用户停止广播某个约伴
-(void)doYueBanStopByUser:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL ,NSString *))CallBack {
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,doYueBanStopByUserURL];
    
    [self getResultWithURLAndParam:requestData andURL:url andRequestCB:^(bool    code, NSString *error) {
        if (code) {
            return CallBack(true,nil);
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,@"code不为0,返回有问题");
        }
        
    }];
    
}
#pragma mark 获取某个约伴详情
-(void)getYueBanDetail:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getYueBanDetailURL ];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            id yueBanDetail = [responseObject objectForKey:@"yueBanDetail"];
            return CallBack(true,yueBanDetail,nil);
//            if([yueBanDetail count]>0)
//            {
//                yueBanDetail = [self.dataFormatHandle handleDictArray:yueBanDetail];
//                return CallBack(true,yueBanDetail,nil);
//            }else{
//                return CallBack(true,yu,nil);
//            }
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
}

#pragma mark  获取我参加的和我创建的约伴历史，创建的只返回停止了的
-(void)getMyYueBanRecordList:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMyYueBanRecordListURL ];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            id myAttendYueBanList = [responseObject objectForKey:@"yuebanList"];
            if([myAttendYueBanList count]>0)
            {
                myAttendYueBanList = [self.dataFormatHandle handleDictArray:myAttendYueBanList];
                return CallBack(true,myAttendYueBanList,nil);
            }else{
                return CallBack(true,nil,nil);
            }
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
}

#pragma mark - 游戏
#pragma mark 获取我正在进行的游戏任务列表
-(void)getMyCurrentMultiGameInfo:(NSDictionary *)requestData andRequestCB:(void(^)(BOOL,id,NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getMyCurrentMultiGameInfoURL ];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            return CallBack(true,responseObject,nil);
            
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];

}
#pragma mark 获取当日任务目标与互动值
-(void)getTaskTargetAndInteractionValue:(NSDictionary *)requestData andRequestCB:(void (^)(BOOL, id, NSString *))CallBack{
    NSString *url = [[NSString alloc]initWithFormat:@"%s%s",requestPrefixURL,getTaskTargetAndInteractionValueURL];
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            return CallBack(true,responseObject,nil);
            
        }
        else{
            NSLog(@"%@",error);
            return CallBack(false,nil,@"code不为0，返回有问题");
        }
    }];
    
}
//#pragma mark 获取多人游戏邀请列表
//- (void)getMyInvitationList:(NSDictionary *)requestData requestCallBack:(void (^)(BOOL code,id responseObject,NSString *error))callBack {
//    NSString *url = [NSString stringWithFormat:@"%s%s",requestPrefixURL,getMyInvitationListURL];
////    NSLog(@"%@",url);
//    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
//        if (code) {
//            callBack(YES,responseObject,nil);
//        } else {
//            NSLog(@"%@",error);
//            callBack(NO,nil,@"code不为0，返回有问题");
//        }
//    }];
//}
#pragma mark 获取多人游戏邀请列表
- (void)getMyInvitationListWithCallBack:(void (^)(BOOL code,id responseObject,NSString *error))callBack {
    NSString *user_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    if (!user_token) {
        NSLog(@"user_token为空 %s",__func__);
        return;
    }
    
    //测试
//    user_token = @"m4QIyZxSyoXOMppBXT2XUm1j2BHlNug7cnq8hXBy2eps3D";
    
    NSDictionary *requestData = @{@"requestData": [@{@"user_token":user_token} JSONString]};
    NSString *url = [NSString stringWithFormat:@"%s%s",requestPrefixURL,getMyInvitationListURL];

    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            callBack(YES,responseObject,nil);
        } else {
            NSLog(@"%@",error);
            callBack(NO,nil,@"code不为0，返回有问题");
        }
    }];
}

#pragma mark 获取多人游戏邀请列表
- (void)getMyScoreRankWithCallBack:(void (^)(BOOL code,id responseObject,NSString *error))callBack {
    NSString *user_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    if (!user_token) {
        NSLog(@"user_token为空 %s",__func__);
        return;
    }
    
    //测试
//    user_token = @"cG2YVSl2FFZcIs96siDeD50lq2pptQSjwn9i7xCM9CpY3D";
    
    NSDictionary *requestData = @{@"requestData": [@{@"user_token":user_token} JSONString]};
    NSString *url = [NSString stringWithFormat:@"%s%s",requestPrefixURL,getMyScoreRankURL];
    
    [self getDataWithURLAndParam:requestData andURL:url andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            callBack(YES,responseObject,nil);
        } else {
            NSLog(@"%@",error);
            callBack(NO,nil,@"code不为0，返回有问题");
        }
    }];
}

@end
