//
//  GamePlugin.h
//  LiveForest
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "CDVPlugin.h"

@interface GamePlugin : CDVPlugin

//根据今日任务启动计步器
-(void)startTodaySingleGameRecord:(CDVInvokedUrlCommand*)command;

@end
