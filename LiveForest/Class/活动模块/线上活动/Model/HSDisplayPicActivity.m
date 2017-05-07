//
//  HSDisplayPicActivity.m
//  LiveForest
//
//  Created by wangfei on 7/27/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSDisplayPicActivity.h"

@implementation HSDisplayPicActivity

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activity_id = dict[@"activity_id"];
        self.activity_name = dict[@"activity_name"];
        self.activity_summary = dict[@"activity_summary"];
        self.activity_img_path = [dict objectForKey:@"activity_img_path"];
        self.activity_user_num = dict[@"activity_user_num"];
    }
    return self;
}
+(instancetype)displayPicActivityWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}
/**
 *  生成模型数组
 *
 *  @param array
 *
 *  @return
 */
+(NSMutableArray *)displayPicActivityWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self displayPicActivityWithDic:dict]];
    }
    return  arrayM;
}

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSDisplayPicActivity *a = [HSDisplayPicActivity new];
    a.activity_id = @"0";
    a.activity_name = @"晒图活动1";
    a.activity_summary = @"晒图活动1的描述";
    a.activity_img_path = @[@"http://www.kuaihou.com/uploads/allimg/130130/1-1301300103061P.jpg",
                            @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                            @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                            @"http://t1.niutuku.com/960/22/22-435778.jpg",
                            @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                            @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                            @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                            @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                            @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    a.activity_user_num = @"10";
    
    HSDisplayPicActivity *a2 = [HSDisplayPicActivity new];
    a2.activity_id = @"1";
    a2.activity_name = @"晒图活动2";
    a2.activity_summary = @"晒图活动2的描述";
    a2.activity_img_path = @[@"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                            @"http://t1.niutuku.com/960/22/22-435778.jpg",
                            @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                            @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                            @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                            @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                            @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    a2.activity_user_num = @"20";

    [array addObject:a];
    [array addObject:a2];
    return array;
}

@end
