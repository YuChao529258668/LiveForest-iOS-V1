//
//  RCHandShakeMessage.h
//  iOS-IMKit
//
//  Created by Heq.Shinoda on 14-6-30.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import "RCMessageContent.h"

#define RCHandShakeMessageTypeIdentifier @"RC:HsMsg"
/**
 *  客服握手消息
 */
@interface RCHandShakeMessage : RCMessageContent<RCMessageCoding,RCMessagePersistentCompatible>
/**
 *  init
 *
 *  @return return instance
 */
-(RCHandShakeMessage*)init;

@end
