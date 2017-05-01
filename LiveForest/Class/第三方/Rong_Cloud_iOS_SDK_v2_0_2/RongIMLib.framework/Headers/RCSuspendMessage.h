//
//  RCInterruptMessage.h
//  iOS-IMKit
//
//  Created by xugang on 15/1/12.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCMessageContent.h"

#define RCInterruptMessageTypeIdentifier @"RC:SpMsg"
/**
 *  客服挂断消息
 */
@interface RCSuspendMessage : RCMessageContent<RCMessageCoding,RCMessagePersistentCompatible>


/**
 *  init
 *
 *  @return return instance
 */
-(instancetype)init;

@end
