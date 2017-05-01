//
//  RCPublicServiceMenuItem.h
//  RongIMLib
//
//  Created by litao on 15/4/14.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 公众服务账号菜单条目类
 */
@interface RCPublicServiceMenuItem : NSObject
/**
 * 菜单标题
 */
@property (nonatomic, strong)NSString *text;
/**
 * 菜单链接
 */
@property (nonatomic, strong)NSString *url;
/**
 * 根据JSON 字典创建菜单项实体
 * @param  jsonDic   存储菜单项属性的字典
 * @return 返回对象实例
 */
+ (instancetype)menuItemFromJsonDic:(NSDictionary *)jsonDic;
@end
