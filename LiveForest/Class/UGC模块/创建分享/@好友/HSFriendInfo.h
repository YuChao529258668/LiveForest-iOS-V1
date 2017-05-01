//
//  HSFriendInfo.h
//  LiveForest
//
//  Created by wangfei on 7/30/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFriendInfo : NSObject

@property (nonatomic, copy) NSString *friend_id;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *user_introduction;
@property (nonatomic, copy) NSString *user_logo_img_path;
@property (nonatomic, copy) NSString *user_sex;
//是否选中
@property (nonatomic, assign) BOOL ischecked;

- (instancetype)initWithDic:(NSDictionary *)dict;
+ (instancetype)friendInfoWithDic:(NSDictionary *)dict;
+ (NSMutableArray *)friendArrayWithArray:(NSArray *)array;

@end
