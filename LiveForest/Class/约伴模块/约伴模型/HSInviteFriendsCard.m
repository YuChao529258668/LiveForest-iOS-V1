//
//  HSInviteFriendsCard.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/4.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSInviteFriendsCard.h"
#import "HSDataFormatHandle.h"
@implementation HSInviteFriendsCard
-(instancetype )initWithDic:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {

        _yueban_id = [dict objectForKey:@"yueban_id"];
        _create_time = [dict objectForKey:@"create_time"];
        _yueban_user_city = [dict objectForKey:@"yueban_user_city"];
        _yueban_sport_id = [dict objectForKey:@"yueban_sport_id"];
        _yueban_sport = [HSDataFormatHandle sportFormatHandleWithSportID:_yueban_sport_id ];
        
        NSString *sportId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"yueban_sport_id"]];
        if ([sportId isEqualToString:@"20"]) {
            _yueban_sport = [dict objectForKey:@"user_sport"];
        }

        
        _yueban_text_info = [dict objectForKey:@"yueban_text_info"];
        _yueban_voice_info = [dict objectForKey:@"yueban_voice_info"];
        _yueban_voice_second = [dict objectForKey:@"yueban_voice_second"];
        _user_id = [dict objectForKey:@"user_id"];
        _user_nickname = [dict objectForKey:@"user_nickname"];
        _user_logo_img_path = [dict objectForKey:@"user_logo_img_path"];
        _user_sex = [dict objectForKey:@"user_sex"];
        _user_introduction = [dict objectForKey:@"user_introduction"];
        _user_birthday = [dict objectForKey:@"user_birthday"];
        
        _yueban_title = [NSString stringWithFormat:@"邀请你参加 %@",_yueban_sport];
        
    }
    return  self;
    
}


+(instancetype)inviteFriendsModelWithDic:(NSDictionary *)dict{
    return [[self alloc]initWithDic:dict];
    
}

+(NSMutableArray *)inviteFriendsWithArray:(NSArray *)array{
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [mArray addObject:[self inviteFriendsModelWithDic:dict]];
    }
    return mArray;
}

@end
