//
//  HSUserInfoHandler.m
//  LiveForest
//
//  Created by 傲男 on 15/6/20.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSUserInfoHandler.h"
#import "HSDataFormatHandle.h"
@implementation HSUserInfoHandler

- (instancetype)init{
    self = [super init];
    if(self){
        
        self.requestCtrl = [[HSRequestDataController alloc]init];
        
        logoCompleted = false;
        blurLogoCompleted = false;
    }
    return self;
}

//回调函数,标识完成
- (void) getUserInfoAndSaveHandler:(void(^)(BOOL))CallBack{
    //现获取本地图片
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //判断是否已经有个人信息
    if([userDefaults objectForKey:@"user_logo_blurImg"] && [userDefaults objectForKey:@"user_logo_img"] && [userDefaults objectForKey:@"user_nickname"] && [userDefaults objectForKey:@"user_sex"] && [userDefaults objectForKey:@"rong_cloud_id"] &&[userDefaults objectForKey:@"user_city"]){
        return CallBack(true);
        //存在本地缓存，则直接用
    }
    else
    {
       //请求个人信息，并缓存到本地
        [self.requestCtrl getPersonalInfo:^(BOOL code,id responseObject, NSString *error){
            if(code){
                //读取数据
                //todo：先保存头像和用户名
                if(responseObject){
                    //个人信息
                    NSDictionary* userInfo = responseObject;
                    //持久化
                    [self saveToLocal:userInfo];
                   
                    //用户头像持久化
                    NSString *user_logo_img_path = [[NSString alloc] initWithString:[userInfo objectForKey:@"user_logo_img_path"]];
                    //用户头像url持久化
                    [userDefaults setObject:user_logo_img_path forKey:@"user_logo_url"];
                    
//                    NSString *urlImg = [[NSString alloc]initWithFormat:@"%@%s",user_logo_img_path,QiNiuImageYaSuo];
//                    
//                    
//                    NSURL * urlLogo = [NSURL URLWithString:[urlImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                    NSLog(@"urlLogo:%@",urlLogo);
                    
                    if(!user_logo_img_path || [user_logo_img_path isEqualToString:@""]){
                        NSLog(@"头像不存在");
                        return CallBack(true) ;
                    }
                    //如果用户头像缓存不存在，则重新请求
                    if(![userDefaults objectForKey:@"user_logo_img"]){
                        self.tmpImgView = [[UIImageView alloc]init];
//                        [self.tmpImgView sd_setImageWithURL:urlLogo
//                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                      logoCompleted = true;
//                                                      
//                                                      //头像图片获取成功
//                                                      //                                                           持久化
//                                                      //持久化头像,只能保存data
//                                                      //2.添加任务到队列中，就可以执行任务
//                                                      //异步函数：具备开启新线程的能力
//                                                      //                                                       dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                                      //                                                       dispatch_async(queue, ^{
//                                                      //如果异步处理，在信息补全页，图片显示错误todo！！！
//                                                      if(image){
//                                                          [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_img"];
//                                                          
//                                                          
//                                                      }
//                                                      else{
//                                                          //默认头像
//                                                          [userDefaults setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"Home.jpg"], 1) forKey:@"user_logo_img"];
//                                                      }
//                                                      [userDefaults synchronize];
////                                                      if(logoCompleted && blurLogoCompleted){
////                                                          return CallBack(true);  //为了处理完头像再返回，没必要，可以异步处理
////                                                      }
//                                                      //                                                       });
//                                                  }];
                        [HSDataFormatHandle getImageWithUri:user_logo_img_path isYaSuo:true imageTarget:self.tmpImgView defaultImage:[UIImage imageNamed:@"Home.jpg"] andRequestCB:^(UIImage *image) {
                            if(image){
                                [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_img"];
                                                            }
                            else{
                                //默认头像
                                [userDefaults setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"Home.jpg"], 1) forKey:@"user_logo_img"];
                            }
                            [userDefaults synchronize];
                        }];
                    }else{
//                        logoCompleted = true;
                    }
                    //如果用户模糊头像不存在，则重新请求
                    if(![userDefaults objectForKey:@"user_logo_blurImg"]){
                        //用户模糊头像持久化
                        NSString *urlBlurImg = [[NSString alloc]initWithFormat:@"%@%s",[userInfo objectForKey:@"user_logo_img_path"],QiNiuImageBlur];
                        self.tmpImgView2 = [[UIImageView alloc]init];
//                        [self.tmpImgView2 sd_setImageWithURL:urlBlurLogo
//                                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                       
//                                                       blurLogoCompleted = true;
//                                                       //头像图片获取成功
//                                                       //                                                           持久化
//                                                       //持久化头像,只能保存data
//                                                       //2.添加任务到队列中，就可以执行任务
//                                                       //异步函数：具备开启新线程的能力
//                                                       //                                                  dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                                       //                                                  dispatch_async(queue, ^{
//                                                       if(image){
//                                                           [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_blurImg"];
//                                                           
//                                                           
//                                                       }
//                                                       else{
//                                                           [userDefaults setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"HomeBlur.png"], 1) forKey:@"user_logo_blurImg"];
//                                                       }
//                                                       [userDefaults synchronize];
////                                                       if(logoCompleted && blurLogoCompleted){
////                                                           return CallBack(true);//为了处理完头像再返回，没必要，可以异步处理
////                                                       }
//                                                       //                                                      });
//                                                   }];
                        [HSDataFormatHandle getImageWithUri:urlBlurImg isYaSuo:NO imageTarget:self.tmpImgView2 defaultImage:[UIImage imageNamed:@"HomeBlur.png"] andRequestCB:^(UIImage *image) {
                            if(image){
                                [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_blurImg"];
                                
                                
                            }
                            else{
                                [userDefaults setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"HomeBlur.png"], 1) forKey:@"user_logo_blurImg"];
                            }
                            [userDefaults synchronize];
                        }];
                    }else{
//                        logoCompleted = true;
                    }
                    //完成后返回
//                    if(logoCompleted && blurLogoCompleted){//为了处理完头像再返回，没必要，可以异步处理
//                        return CallBack(true);
//                    }
                    return CallBack(true); //可以直接返回，头像的速度太慢，可以异步
                    
                }
            }
            else{
                NSLog(@"获取数据失败：%@",error);
                return CallBack(true);
            }
        }];
    }
}
#pragma mark 更新用户个人模糊头像
- (void) updateUserAvarlAndSaveHandler:(NSString*)url{
    
    if(!url || [url isEqualToString:@""]){
        NSLog(@"头像不存在");
        return ;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //用户头像url持久化
//    [userDefaults setObject:url  forKey:@"user_logo_url"];
    
    //用户头像持久化
//    NSString *urlImg = [[NSString alloc]initWithFormat:@"%@%s",url,QiNiuImageYaSuo];
    

//    NSURL * urlLogo = [NSURL URLWithString:[urlImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    //                    NSLog(@"urlLogo:%@",urlLogo);
    
   
//    self.tmpImgView = [[UIImageView alloc]init];
//    [self.tmpImgView sd_setImageWithURL:urlLogo
//                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                  //头像图片获取成功
//                                  //                                                           持久化
//                                  //持久化头像,只能保存data
//                                  //2.添加任务到队列中，就可以执行任务
//                                  //异步函数：具备开启新线程的能力
//                                  dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                  dispatch_async(queue, ^{
//                                      if(image){
//                                          [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_img"];
//                                          
//                                          
//                                      }
//                                      [userDefaults synchronize];
//                                  });
//                              }];
    
    //用户模糊头像持久化
    NSString *urlBlurImg = [[NSString alloc]initWithFormat:@"%@%s",url,QiNiuImageBlur];
//    NSURL * urlBlurLogo = [NSURL URLWithString:[urlBlurImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.tmpImgView2 = [[UIImageView alloc]init];
//    [self.tmpImgView2 sd_setImageWithURL:urlBlurLogo
//                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                  //头像图片获取成功
//                                  //                                                           持久化
//                                  //持久化头像,只能保存data
//                                  //2.添加任务到队列中，就可以执行任务
//                                  //异步函数：具备开启新线程的能力
//                                  dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                  dispatch_async(queue, ^{
//                                      if(image){
//                                          [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_blurImg"];
//                                          
//                                      }
//                                      [userDefaults synchronize];
//                                  });
//                              }];
    [HSDataFormatHandle getImageWithUri:urlBlurImg isYaSuo:NO imageTarget:self.tmpImgView2 defaultImage:[UIImage imageNamed:@"Home.jpg"] andRequestCB:^(UIImage *image) {
        //持久化头像,只能保存data
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if(image){
                [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_blurImg"];
                
            }
            [userDefaults synchronize];
        });
        
    }];
    
}

#pragma mark 更新用户信息补全页（头像已经单独处理）
- (void)updateUserInfoAndSaveHandler:(NSDictionary *)dic{
    
    NSData *JSONData = [[dic objectForKey:@"requestData"] dataUsingEncoding:NSUTF8StringEncoding];
    dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//    dic = [dic objectForKey:@"requestData"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
//    NSString *url = [[NSString alloc]init];
//    url = [dic objectForKey:@"user_logo_img_path"];
//    
//    
//    if(!url || [url isEqualToString:@""]){
//        NSLog(@"头像不存在");
//        return ;
//    }
//    //用户头像持久化
//    NSString *urlImg = [[NSString alloc]initWithFormat:@"%@%s",url,QiNiuImageYaSuo] ;
//    
//    
//    NSURL * urlLogo = [NSURL URLWithString:[urlImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    //                    NSLog(@"urlLogo:%@",urlLogo);
//    
//    
//    self.tmpImgView = [[UIImageView alloc]init];
//    [self.tmpImgView sd_setImageWithURL:urlLogo
//                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                  //头像图片获取成功
//                                  //                                                           持久化
//                                  //持久化头像,只能保存data
//                                  //2.添加任务到队列中，就可以执行任务
//                                  //异步函数：具备开启新线程的能力
//                                  dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                  dispatch_async(queue, ^{
//                                      if(image){
//                                          [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_img"];
//                                          
//                                          
//                                      }
//                                      [userDefaults synchronize];
//                                  });
//                              }];
//    
//    //用户模糊头像持久化
//    NSString *urlBlurImg = [[NSString alloc]initWithFormat:@"%@%s",url,QiNiuImageBlur];
//    NSURL * urlBlurLogo = [NSURL URLWithString:[urlBlurImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    self.tmpImgView2 = [[UIImageView alloc]init];
//    [self.tmpImgView2 sd_setImageWithURL:urlBlurLogo
//                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                   //头像图片获取成功
//                                   //                                                           持久化
//                                   //持久化头像,只能保存data
//                                   //2.添加任务到队列中，就可以执行任务
//                                   //异步函数：具备开启新线程的能力
//                                   dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                                   dispatch_async(queue, ^{
//                                       if(image){
//                                           [userDefaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"user_logo_blurImg"];
//                                           
//                                       }
//                                       [userDefaults synchronize];
//                                   });
//                               }];
    if([dic objectForKey:@"user_nickname"]){
        [userDefaults setObject:[dic objectForKey:@"user_nickname"] forKey:@"user_nickname"];
    }
    if([dic objectForKey:@"user_birthday"]){
        [userDefaults setObject:[dic objectForKey:@"user_birthday"] forKey:@"user_birthday"];
    }
    if([dic objectForKey:@"user_sex"]){
        [userDefaults setObject:[dic objectForKey:@"user_sex"] forKey:@"user_sex"];
    }
    if([dic objectForKey:@"user_city"]){
        [userDefaults setObject:[dic objectForKey:@"user_city"] forKey:@"user_city"];
    }
    if([dic objectForKey:@"user_sport_id"]){
        [userDefaults setObject:[dic objectForKey:@"user_sport_id"] forKey:@"user_sport_id"];
    }
    
    [userDefaults synchronize];
}
//基本信息持久化
- (void)saveToLocal:(NSDictionary*)userInfo{
//    将userInfo转化为string
    //todo
//    userInfo = [self DictionaryFormatHandler:userInfo];
/*
user_id:String用户ID
user_logo_img_path:String用户头像地址
user_nickname:String用户昵称
user_sex:String用户性别
user_city:String用户所在城市
user_introduction:String用户个人简介
user_sport_id:String用户喜欢的体育类型
user_fans_num:String用户粉丝数量
user_following_num:String用户关注的人数
user_credit_num:String用户积分数
user_birthday:String用户生日，时间戳
user_phone:String用户号码
wechat_nickname:String用户微信昵称
wechat_logo_img_path:String用户微信头像
weco_nickname:String用户微博昵称
weco_logo_img_path:String用户微博头像
*/
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //rong_cloud_id:String个人融云ID
    [userDefaults setObject:[userInfo objectForKey:@"rong_cloud_id"] forKey:@"rong_cloud_id"];
    
    
    NSString *user_nickname = [[NSString alloc] initWithString:
                               [[userInfo objectForKey:@"user_nickname"] isEqualToString:
                                @"-10086"]?@"" : [userInfo objectForKey:@"user_nickname"]];
    [userDefaults setObject:user_nickname forKey:@"user_nickname"];
    
    [userDefaults setObject:[userInfo objectForKey:@"user_credit_num"] forKey:@"user_credit_num"];
   
    [userDefaults setObject:[userInfo objectForKey:@"user_fans_num"] forKey:@"user_fans_num"];
    
    [userDefaults setObject:[userInfo objectForKey:@"user_following_num"] forKey:@"user_following_num"];
    
    NSString *user_introduction = [[NSString alloc] initWithString:
                                   [[userInfo objectForKey:@"user_introduction"] isEqualToString:@"-10086"]?@"爱运动、爱分享——LiveForest" : [userInfo objectForKey:@"user_introduction"]];
    [userDefaults setObject:user_introduction forKey:@"user_introduction"];

//    if([[userInfo objectForKey:@"user_city"] isKindOfClass:[NSNumber class]]){
//        NSString *user_city = [userInfo objectForKey:@"user_city"];
//        if([user_city isEqualToString :@"-10086"])
//            user_city = @"";
//        [userDefaults setObject:user_city forKey:@"user_city"];
//    }
    NSString *user_city = [userInfo objectForKey:@"user_city"];
    if (user_city == nil || user_city.length == 0) {
        user_city = @"-10086";//未知
    }
    [userDefaults setObject:user_city forKey:@"user_city"];
    [userDefaults setObject:[userInfo objectForKey:@"user_sex"] forKey:@"user_sex"];
    

//    NSString *user_age = [[NSString alloc] initWithString:
//                               [[userInfo objectForKey:@"user_age"] isEqualToString:
//                                @"-10086"]?@"" : [userInfo objectForKey:@"user_age"]];
//    [userDefaults setObject:user_age forKey:@"user_age"];
    
    //生日
    NSString *user_birthday = [userInfo objectForKey:@"user_birthday"];
    user_birthday = [user_birthday isEqualToString:
                           @"-10086"]?@"" : user_birthday;
    user_birthday = [HSDataFormatHandle dateformaterWithTimestamp:user_birthday andFormater:@"yyyy-MM-dd"];
    [userDefaults setObject:user_birthday forKey:@"user_birthday"];
    
    //用户运动标签
    NSArray *user_sport_id = [userInfo objectForKey:@"user_sport_id"];
    [userDefaults setObject:user_sport_id forKey:@"user_sport_id"];
    
    //用户手机
    [userDefaults setObject:[userInfo objectForKey:@"user_phone"] forKey:@"user_phone"];
    [userDefaults synchronize];
    
    //用户第三方信息
    //用户微信绑定信息
    [userDefaults setObject:[[userInfo objectForKey:@"wechat_nickname"]
                                        isEqualToString:@"-10086"]?@"未绑定":
                                            [userInfo objectForKey:@"wechat_nickname"]
                            forKey:@"wechat_nickname"];
    [userDefaults setObject:[userInfo objectForKey:@"wechat_logo_img_path"] forKey:@"wechat_logo_img_path"];
    
    //用户微博绑定信息
    [userDefaults setObject:[userInfo objectForKey:@"weco_logo_img_path"] forKey:@"weco_logo_img_path"];
    
    [userDefaults setObject:[[userInfo objectForKey:@"weco_nickname"] isEqualToString:@"-10086"]?@"未绑定":
                     [userInfo objectForKey:@"weco_nickname"] forKey:@"weco_nickname"];
}


#pragma -mark 更新用户城市信息
- (void) updateUserCity:(NSString*)cityID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (cityID == nil || cityID.length == 0) {
        cityID = @"-10086";
    }
    [userDefaults setObject:cityID forKey:@"user_city"];
}

#pragma -mark 更新用户生日
-(void)updateUserBirthday:(NSString *)dateString
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dateString == nil || dateString.length == 0) {
        dateString = @"-10086";
    }
    [userDefaults setObject:dateString forKey:@"user_birthday"];
}
#pragma -mark 更新用户昵称
-(void)updateUserNickname:(NSString *)nickname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (nickname == nil) {
        nickname = @"";
    }
    [userDefaults setObject:nickname forKey:@"user_nickname"];
}
#pragma -mark 更新用户运动标签
- (void)updateUserSportsID:(NSArray *)sportsID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sportsID forKey:@"user_sport_id"];

    [userDefaults synchronize];
}
#pragma mark 更新用户微信信息
- (void)updateUserWechatInfo:(NSDictionary*)wechatInfo{

    //获取默认全局缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //存放当前的用户的微信信息
    [userDefaults setObject:[wechatInfo objectForKey:@"nickname"] forKey:@"wechat_nickname_default"];

    //存放当前的用户头像
    [userDefaults setObject:[wechatInfo objectForKey:@"profileImage"] forKey:@"wechat_logo_img_path_default"];
    
    //存放用户的微信的ID
    [userDefaults setObject:[wechatInfo objectForKey:@"openId"] forKey:@"wechat_id"];
}

//#pragma mark 转string
//- (NSString*)NSStringFormated:(id)string{
//    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//    if([string isKindOfClass:[NSNumber class]]){
//        return [numberFormatter stringFromNumber:string];
//    }
//    return string;
//}
//#pragma mark nsdictionnary
//- (NSDictionary *) DictionaryFormatHandler:(NSDictionary *)dic{
//    for(id key in dic){
//        if([[dic objectForKey:key] isKindOfClass:[NSNumber class]]){ //数组不处理
//            NSString *tmp = [self NSStringFormated:[dic objectForKey:key]];
//            [dic setValue:tmp forKey:key];
//        }
//    }
//    return dic;
//}
//#pragma mark nsarray
//-(NSMutableArray *) NSMutableArrayFormatHandler:(NSMutableArray *)array{
//    for(int i=0;i<[array count];i++){
//        if([[array objectAtIndex:i] isKindOfClass:[NSDictionary class]]){
//            NSDictionary *tmp = [self DictionaryFormatHandler:[array objectAtIndex:i]];
//            array[i] = tmp;
//        }
//    }
//    return array;
//}
@end
