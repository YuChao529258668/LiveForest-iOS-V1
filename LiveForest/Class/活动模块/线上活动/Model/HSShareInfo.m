//
//  HSShareInfo.m
//  LiveForest
//
//  Created by wangfei on 7/29/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSShareInfo.h"
#import "HSDataFormatHandle.h"

@implementation HSShareInfo

-(instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.share_img_path = [dict objectForKey:@"share_img_path"];
        self.user_logo_img_path = [dict objectForKey:@"user_logo_img_path"];
        self.user_nickname = [dict objectForKey:@"user_nickname"];
        self.share_id = [dict objectForKey:@"share_id"];
        self.share_creat_time = [HSDataFormatHandle dateFormaterString:dict[@"share_create_time"]];
        self.share_description = [dict objectForKey:@"share_description"];
        
        self.share_like_num = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"share_like_num"]];
        self.comment_count = [HSDataFormatHandle handleStringNumber:[dict objectForKey:@"comment_count"]];
    }
    return self;
}

+(instancetype)shareInfoWithDic:(NSDictionary *)dict
{
    return [[self alloc]initWithDic:dict];
}

+(NSArray *)shareInfoArrayWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        [arrayM addObject:[self shareInfoWithDic:dict]];
    }
    return  arrayM;
}

//- (NSString *)handleStringNumber:(NSString *)stringNumber
//{
//    //空返回0
//    if (stringNumber == nil || stringNumber.length == 0) {
//        return @"0";
//    }
//    
//    //>99 返回99+
//    if (stringNumber.length > 2) {
//        stringNumber = @"99+";
//    }
//    return stringNumber;
//}

/// 用于演示
+ (NSMutableArray *)test {
    NSMutableArray *array = [NSMutableArray array];
    
    HSShareInfo *i = [HSShareInfo new];
    i.share_description = @"分享描述分享描述分享描述分享描述分享描述分享描述";
    i.share_id = @"0";
    i.user_nickname = @"小红";
    i.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    i.comment_count = @"0";
    i.share_like_num = @"9";
    i.share_creat_time = @"2017-1-1 13:30:00";
    i.share_img_path = @[@"http://www.kuaihou.com/uploads/allimg/130130/1-1301300103061P.jpg",
                         @"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
                         @"http://img2.niutuku.com/desk/anime/1913/1913-7515.jpg",
                         @"http://t1.niutuku.com/960/22/22-435778.jpg",
                         @"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=aef92f0b09f79052ef4a4f3a39c3fbfc/aa64034f78f0f736219e10190a55b319ebc41341.jpg",
                         @"http://pic.wenwen.soso.com/p/20091004/20091004223808-749075817.jpg",
                         @"http://dynamic-image.yesky.com/600x-/uploadImages/2012/229/62SW1O3LI8UQ.jpg",
                         @"http://e.hiphotos.baidu.com/zhidao/pic/item/342ac65c103853431f0bcc079313b07ecb8088d4.jpg",
                         @"http://s3.sinaimg.cn/orignal/4c42990eaf4e962a49782"];
    
    HSShareInfo *i2 = [HSShareInfo new];
    i2.share_description = @"分享描述分享描述分享描述分享描述分享描述分享描述";
    i2.share_id = @"1";
    i2.user_nickname = @"小红";
    i2.user_logo_img_path = @"http://p.store.itangyuan.com/p/chapter/attachment/etMsEgjseS/EgfwEgfSegAuEtjUE_EtETuh4bsOJgetjmilgNmii_EV87ocJn9L5Cb.jpg";
    i2.comment_count = @"0";
    i2.share_like_num = @"9";
    i2.share_creat_time = @"2017-1-1 13:30:00";
    i2.share_img_path = @[@"http://www.sznews.com/travel/images/attachement/jpg/site3/20150603/7427ea33bc7416d8b93b4c.jpg",
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
