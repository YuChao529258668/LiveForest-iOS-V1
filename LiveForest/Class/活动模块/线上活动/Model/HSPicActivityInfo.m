//
//  HSPicActivityInfo.m
//  LiveForest
//
//  Created by wangfei on 7/28/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSPicActivityInfo.h"
#import "HSDataFormatHandle.h"
#import "HSShareInfo.h"


@implementation HSPicActivityInfo

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activity_name = [dict objectForKey:@"activity_name"];
        NSString *timestamp = [dict objectForKey:@"create_time"];
        self.create_time = [NSString stringWithFormat:@"%@  发布",[HSDataFormatHandle dateformaterWithTimestamp:timestamp andFormater:@"yyyy-MM-dd HH:mm"]];
        self.activity_summary = [dict objectForKey:@"activity_summary"];
        //数组中的字段转化
        NSArray *handelArray = [[[HSDataFormatHandle alloc] init] handleDictArray:[dict objectForKey:@"shareList"]];
        self.shareList = [HSShareInfo shareInfoArrayWithArray:handelArray];
        self.activity_img_path = [dict objectForKey:@"activity_img_path"];
    }
    return self;
}

+(instancetype)picActivityInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSPicActivityInfo *i = [HSPicActivityInfo new];
    i.activity_id = @"0";
    i.activity_name = @"晒图活动1";
    i.activity_summary = @"这是晒图活动1的简述";
    i.create_time = @"2017-1-1 13:30:00";
    i.activity_time = @"2017-2-2 13:30:00";
    i.shareList = [HSShareInfo test];
    i.activity_img_path = @[@"http://www.kuaihou.com/uploads/allimg/130130/1-1301300103061P.jpg",
                            @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                            @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                            @"http://t1.niutuku.com/960/22/22-435778.jpg",
                            @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                            @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                            @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                            @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                            @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    
    HSPicActivityInfo *i2 = [HSPicActivityInfo new];
    i2.activity_id = @"1";
    i2.activity_name = @"晒图活动2";
    i2.activity_summary = @"这是晒图活动2的简述";
    i2.create_time = @"2017-1-1 13:30:00";
    i2.activity_time = @"2017-2-2 13:30:00";
    i2.shareList = [HSShareInfo test];
    i2.activity_img_path = @[@"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                             @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                             @"http://t1.niutuku.com/960/22/22-435778.jpg",
                             @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                             @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                             @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                             @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                             @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    
    [array addObject:i];
    [array addObject:i2];
    return array;
}


@end
