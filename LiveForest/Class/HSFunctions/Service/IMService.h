//
//  IMService.h
//  LiveForest
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IMService : NSObject


@property(nonatomic,strong) NSString* user_token;

@property(nonatomic,strong) NSDictionary* friend_info;

@property(nonatomic,strong) UIViewController* fromViewController;

@property(nonatomic,strong) UIViewController* toViewController;

/**
 *@region 外部接口
 */
+ (IMService*)getSingletonInstance;

//启动单人聊天室
- (void)singleChatroom:(NSString*)user_token withFriendInfo:(NSDictionary*)friend_info fromViewController:(UIViewController*)fromViewController;

@end
