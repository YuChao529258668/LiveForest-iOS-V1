//
//  UserInfoPlugin.h
//  LiveForest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "CDVPlugin.h"
#import <Cordova/CDV.h>

@interface UserInfoPlugin : CDVPlugin

- (void)getUserInfo:(CDVInvokedUrlCommand*)command;

@end
