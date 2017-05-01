//
//  IMService.m
//  LiveForest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "IMService.h"
#import <Cordova/CDVViewController.h>

@interface IMService()



@end

@implementation IMService

#pragma mark - Public Interface

#pragma mark 获取IMService实例
+ (IMService*)getSingletonInstance{

    static IMService *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;

}

#pragma mark 启动单人聊天室
- (void)singleChatroom:(NSString*)user_token withFriendInfo:(NSDictionary*)friend_info fromViewController:(UIViewController*)fromViewController{

    //初始化Cordova容器
    static CDVViewController* viewController;
    viewController  = [CDVViewController new];
    
    //将FriendId存入静态变量
    self.user_token = user_token;
    
    self.friend_info = friend_info;
    
    self.fromViewController = fromViewController;
    
    self.toViewController = viewController;
    
//    NSLog(viewController.startPage);
    
    if(fromViewController && viewController){
        
        viewController.startPage = @"game.html";
        
//        NSLog(viewController.startPage);
        
        //跳转到该WebView
        [fromViewController presentViewController:viewController animated:YES completion:^{}];
    }
    
}


@end
