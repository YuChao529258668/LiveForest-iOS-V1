//
//  UserInfoPlugin.m
//  LiveForest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "UserInfoPlugin.h"
#import "ServiceHeader.h"

@implementation UserInfoPlugin


#pragma mark - Public Interface

#pragma mark 获取用户信息
- (void)getUserInfo:(CDVInvokedUrlCommand*)command{
    
    NSLog(@"Cordova Plugins - getUserInfo");

    CDVPluginResult* pluginResult = nil;
    
    //获取用户基本信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //构造返回数据
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                 messageAsDictionary:[[NSDictionary alloc]
                                                      initWithObjectsAndKeys:
                                                      [userDefaults objectForKey:@"user_token"], @"user_token",
                                                      [userDefaults objectForKey:@"user_id"],@"user_id",
                                                      [userDefaults objectForKey:@"user_nickname"],@"user_nickname",
                                                      [userDefaults objectForKey:@"user_logo_img_path"],@"user_logo_img_path",
                                                      nil]];
    
//    NSLog([userDefaults objectForKey:@"user_token"]); // 测试代码，打印出用户的user_token
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

#pragma mark 跳回上个界面
- (void)goBack:(CDVInvokedUrlCommand*)command{
    
    [[CordovaService getSingletonInstance].cordovaViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"goBack");
    }];
}

@end
