//
//  StringUtils.m
//  LiveForest
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils



/**
 *@function 判断字符串是否有效
 **/
+ (BOOL)isValid:(NSString*)str{

    if(!str || [str isEqualToString:@""] || [str isEqualToString:@"-10086"]){
        
        return FALSE;
    }
    
    return TRUE;
    
}

/**
 *@function 判断字符串是否有效的手机号
 **/
+ (BOOL)isValidPhoneNumber:(NSString*)phone{
    
    //判断输入的手机号码的正确定，11位
    if (phone.length != 11) {
        return false;
    }
    
    return true;
    
}

@end
