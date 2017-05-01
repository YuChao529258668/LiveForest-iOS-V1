//
//  HSUpLoadToQiNiu.h
//  LiveForest
//
//  Created by 傲男 on 15/8/7.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSRequestDataController.h"

@interface HSUpLoadToQiNiu : NSObject

#pragma mark 七牛存储文件
/**
 * 上传七牛的文件封装
 * @param filePath 文件路径
 *
 *return url 七牛返回的路径
 **/
+ (void)upLoadDataByQiNiu:(NSString *)filePath andCallBack:(void(^)(BOOL, NSString * ,NSString *))CallBack;
@end
