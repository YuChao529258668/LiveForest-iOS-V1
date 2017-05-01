//
//  RCPublicServiceMenu.h
//  RongIMLib
//
//  Created by litao on 15/4/14.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//


/* Menu -> MenuGroup -> MenuItem
 *                   -> MenuItem
 *
 *         MenuGroup -> MenuItem
 *                   -> MenuItem
 *                   -> MenuItem
 */
#import <Foundation/Foundation.h>
#import "RCPublicServiceMenuGroup.h"
#import "RCPublicServiceMenuItem.h"

/**
 * 公众服务账号菜单类
 */
@interface RCPublicServiceMenu : NSObject
/**
 * 菜单名称
 */
@property (nonatomic, strong)NSString *title;
/**
 * 菜单组
 * 类型为RCPublicServiceMenuGroup
 */
@property (nonatomic, strong)NSArray *menuGroups; //of RCPublicServiceMenuGroup
/**
 * 根据JSON 字典初始化Menu
 * @param  data    存储菜单属性的字典
 */
- (void)decodeWithData:(NSData *)data;
@end
