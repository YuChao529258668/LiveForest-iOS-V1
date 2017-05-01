//
//  HSIndexCellModel.h
//  LiveForest
//
//  Created by 余超 on 15/11/4.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSIndexCellModel : NSObject


@property (nonatomic, copy) NSString *share_desription;

@property (nonatomic, copy) NSString *share_like_num;

@property (nonatomic, copy) NSString *share_comment_num;

@property (nonatomic, copy) NSString *delete_state;

@property (nonatomic, copy) NSString *share_category;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *share_create_time;

@property (nonatomic, copy) NSString *sport_ids;

@property (nonatomic, copy) NSString *share_city;

@property (nonatomic, copy) NSString *share_id;

@property (nonatomic, copy) NSString *hasLiked;

@property (nonatomic, copy) NSString *share_img_path_with_lables;

@property (nonatomic, copy) NSString *user_nickname;

@property (nonatomic, copy) NSString *share_location;

@property (nonatomic, copy) NSString *user_logo_img_path;

@property (nonatomic, copy) NSString *share_county;

@property (nonatomic, copy) NSString *share_paster_ids;

@property (nonatomic, copy) NSString *share_lon;

@property (nonatomic, strong) NSArray<NSString *> *share_img_path;

@property (nonatomic, copy) NSString *share_description;

@property (nonatomic, copy) NSString *share_img_path_with_pasters;

@property (nonatomic, copy) NSString *comment_count;

@property (nonatomic, copy) NSString *share_lat;




//{
//    "comment_count" = 0;
//    "delete_state" = 1;
//    hasLiked = 0;
//    "share_category" = 0;
//    "share_city" = 2079;
//    "share_comment_num" = 0;
//    "share_county" = 2093;
//    "share_create_time" = 1445407981000;
//    "share_description" = "\U4e00\U5929\U7684\U8bfe\U7a0b\U53c8\U5f00\U59cb\U4e86";
//    "share_desription" = "-10086";
//    "share_id" = 289;
//    "share_img_path" =     (
//                            "http://7xiokh.com1.z0.glb.clouddn.com/005P1a4xgw1etkxli0kayj31kw0w749b_\U526f\U672c.jpg"
//                            );
//    "share_img_path_with_lables" = "-10086";
//    "share_img_path_with_pasters" = "-10086";
//    "share_lat" = 32;
//    "share_like_num" = 0;
//    "share_location" = "";
//    "share_lon" = 119;
//    "share_paster_ids" = "-10086";
//    "sport_ids" = "-10086";
//    "user_id" = 144540792914447223;
//    "user_logo_img_path" = "";
//    "user_nickname" = fgswm789;
//}

@end
