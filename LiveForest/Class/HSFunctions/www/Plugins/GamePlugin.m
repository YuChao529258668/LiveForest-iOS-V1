//
//  GamePlugin.m
//  LiveForest
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "GamePlugin.h"
#import "HSDataFormatHandle.h"
#import "ServiceHeader.h"

@implementation GamePlugin

#pragma mark - 单人游戏接口

#pragma mark 启动今日的单人游戏
-(void)startTodaySingleGameRecord:(CDVInvokedUrlCommand*)command{
    
    NSLog(@"Cordova Plugin - startTodaySingleGameRecord");
    
    //获取到今日目标
    
    NSNumber* todayTarget = [NSNumber numberWithInt:[[command.arguments objectAtIndex:0] intValue]];
    
//    NSLog(@"todayTarget:%@" ,todayTarget);
    
    
    //在全局缓存中设置今日任务开始情况
    [self setGlobalState:[[NSDictionary alloc] initWithObjectsAndKeys:
                          @"single",@"type",
                          todayTarget,@"target",
                          [self getTodayDate],@"token" //存入今日的时间作为令牌
                          , nil]];
    
    //判断当前是否已经开始计分，通过 singleGameRecord2014-9-19 键值获取
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:[NSString stringWithFormat:@"singleGameRecord%@",[self getTodayDate]]]){
        //如果今日尚未计分，则直接创建为0的空项
        [userDefaults setValue:@0
                        forKey:[NSString stringWithFormat:@"singleGameRecord%@",[self getTodayDate]]
         ];
    }
    
    
    CDVPluginResult* pluginResult = nil;
    
    //构造返回数据
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                 messageAsInt:0];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

#pragma mark 关闭今日的单人游戏
-(void)stopTodaySingleGameRecord:(CDVInvokedUrlCommand*)command{
    
    NSLog(@"Cordova Plugin - stopTodaySingleGameRecord");
    
    CDVPluginResult* pluginResult = nil;
    
    //将当前的状态设置为空
    [self setGlobalState:[[NSDictionary alloc] initWithObjectsAndKeys:
                          nil,@"type",
                          nil,@"target",
                          nil,@"token"
                          , nil]];
    
    //单人模式下并不会清空今日的已记的步数，所以将目前的步数添加到缓存中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    //将计步值更新到缓存中
    [userDefaults setValue:
     [userDefaults objectForKey:[NSString stringWithFormat:@"singleGameRecordTemp%@",[self getTodayDate]]]
                    forKey:[NSString stringWithFormat:@"singleGameRecord%@",[self getTodayDate]]];
    
    //构造返回数据
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                 messageAsInt:0];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

#pragma mark 获取今日单人模式的计步值
-(void)getTodaySingleGameRecord:(CDVInvokedUrlCommand*)command{
    
//    NSLog(@"Cordova Plugin - getTodaySingleGameRecord");

    CDVPluginResult* pluginResult = nil;
    
    NSDictionary *globalGameState = [self getGlobalState];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* todaySingleKey = [NSString stringWithFormat:@"singleGameRecord%@",[self getTodayDate]];//存放今日的单人任务统计量的key值
    
    //判断当前是否正在单人模式
    if([@"single" isEqualToString:[globalGameState objectForKey:@"type"]]){

        //如果是单人模式，则首先将从上一次取分开始的计步器加入到今日的计步器中
        [[HealthKitService sharedInstance] getStepCountFrom:[globalGameState objectForKey:@"last_statistic_time"]
                                                         To:[HSDataFormatHandle toLocalTime:[[NSDate alloc] init]]
                                                andCallBack:^(double d, NSString *str) {
                                                    
                                                    //获取计步值之后的回调
                                                    
                                                    //获取当前已经记录的计步值
                                                    NSNumber* stepsCount =[userDefaults objectForKey:
                                                                           [NSString stringWithFormat:@"singleGameRecord%@",[self getTodayDate]]];
                                                    
                                                    //将计步值相加
                                                    stepsCount = @([stepsCount doubleValue] + d);
                                                    
                                                    //目前的累计值暂时放在缓存中
                                                    [userDefaults setValue:stepsCount forKey:[NSString stringWithFormat:@"singleGameRecordTemp%@",[self getTodayDate]]];
                                                    
                                                    //输出当前计步值
//                                                    NSLog(@"今日计步值：%@",stepsCount);
                                                    
                                                    CDVPluginResult* pluginResult = nil;
                                                    
                                                    //将最终的统计值进行返回
                                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                 messageAsDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: @TRUE,@"singlePlay",
                                                                                    stepsCount,@"singleSteps",
                                                                                    nil]];
                                                    
                                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                }];
        

    }else{
        
        //如果不是在单人模式，判断是否有今日的计步值
        if([userDefaults objectForKey:todaySingleKey]){
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: @FALSE,@"singlePlay"
                                                              ,[userDefaults objectForKey:todaySingleKey],@"singleSteps",
                                                              nil]];
        
        }else{
            //如果还未开始计步，则返回0
            //构造返回数据
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: @FALSE,@"singlePlay"
                                                              ,@0,@"singleSteps",
                                                              nil]];
        
        }
     
        //因为获取计步值是异步过程，所以不需要异步的就放在这里
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
    
}

#pragma mark - 多人游戏接口

#pragma mark 开始某个多人游戏
-(void)startMultipleGameRecord:(CDVInvokedUrlCommand*)command{
    
    NSString* taskId = [command.arguments objectAtIndex:0];
    
    NSString* taskGoal = [command.arguments objectAtIndex:1];
    
    CDVPluginResult* pluginResult = nil;
    
    //设置全局档案
    [self setGlobalState:[[NSDictionary alloc] initWithObjectsAndKeys:
                          @"multiple",@"type",
                          [NSNumber numberWithInt:[taskGoal intValue]],@"target",
                          taskId,@"token"
                          , nil]];
    
    //多人游戏记录的全局Key值：multipleGameRecord{taskId}
    
    //因为多人游戏不可能重复开始，所以直接将多人游戏的初始记录值设置为0
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:@0 forKey:[NSString stringWithFormat:@"multipleGameRecord%@",taskId]];
    
    //构造返回数据
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                 messageAsBool:@TRUE];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark 获取某个多人游戏的进度
-(void)getMultipleGameRecord:(CDVInvokedUrlCommand*)command{
    
    NSString* taskId = [command.arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    
    //获取当前全局的游戏状态
    NSDictionary* globalGameState = [self getGlobalState];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([@"multiple" isEqualToString:[globalGameState objectForKey:@"type"]]){
        
        //如果当前正在多人模式下，则从计步器中获取最新计步值，并且添加到缓存中
        [[HealthKitService sharedInstance] getStepCountFrom:[globalGameState objectForKey:@"last_statistic_time"]
                                                         To:[HSDataFormatHandle toLocalTime:[[NSDate alloc] init]]
                                                andCallBack:^(double d, NSString *str) {
                                                    
                                                    //获取计步值之后的回调
                                                    
                                                    //获取当前已经记录的计步值
                                                    NSNumber* stepsCount =[userDefaults objectForKey:
                                                                           [NSString stringWithFormat:@"multipleGameRecord%@",taskId]];
                                                    
                                                    //将计步值相加
                                                    stepsCount = @([stepsCount doubleValue] + d);
                                                    
                                                    //将计步值更新到缓存中
//                                                    [userDefaults setValue:stepsCount forKey:[NSString stringWithFormat:@"multipleGameRecord%@",taskId]];
                                                    
                                                    //设置最终的取值时间为现在
                                                    [self setGlobalState:nil];
                                                    
                                                    CDVPluginResult* pluginResult = nil;
                                                    
                                                    //将最终的统计值进行返回
                                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                 messageAsInt:[stepsCount intValue]
                                                                    ];
                                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                }];
    }else{
        //如果不是多人模式下，则返回-1
        //构造返回数据
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                            messageAsInt:@-1];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    

}

#pragma mark 关闭某个多人游戏
-(void)stopMultipleGameRecord:(CDVInvokedUrlCommand*)command{

    NSString* taskId = [command.arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    
    //清楚当前多人游戏的计步值
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"multipleGameRecord%@",taskId]];
    
    //将全局游戏状态设置为nil
    [self setGlobalState:[[NSDictionary alloc] initWithObjectsAndKeys:
                          nil,@"type",
                          nil,@"target"
                          , nil]];
    
    //构造返回数据
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                       messageAsBool:@TRUE];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

#pragma mark - 系统与辅助接口

#pragma mark 执行第三方分享动作
-(void)doThirdShare:(CDVInvokedUrlCommand*)command{

    NSString* url = [command.arguments objectAtIndex:0];
    
    NSString* title = [command.arguments objectAtIndex:1];
    
    //调用SocialService中的分享接口
    [SocialService.sharedInstance doSocialShareWithContent:title AndHref:url WithCallBack:^(bool code) {
        
        CDVPluginResult* pluginResult = nil;
        
        //构造返回数据
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                           messageAsBool:@TRUE];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    

}


#pragma mark - Inner Helper

#pragma mark 获取全局状态
/**
 * globalGameState:
 * type 当前正在计分的项目，单人模式为single，多人模式为multiple。无正在进行计步则设置为nil
 * last_statistic_time 上一次的计分时间
 * target 单人模式下为今日的单人目标 多人模式下为某个多人模式的目标
 * token 不同模式下的token，如果是单人模式则为今日时间 如果是多人模式则为taskId
 * 
 * 单人模式的今日计分：今日时间 -> 分值(NSNumber)
 * 多人模式的积分：编号 -> 分值(NSNumber)
 */
-(NSDictionary*)getGlobalState{
    
    //获取全局缓存对象
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"gameGlobalState"]){
        //如果当前已经存在Key值
        return [userDefaults objectForKey:@"gameGlobalState"];
    }else{
        return [[NSDictionary alloc] initWithObjectsAndKeys:nil,@"type", nil];
    }
}

#pragma mark 设置全局状态
-(void)setGlobalState:(NSDictionary*)dict{

    //获取全局缓存对象
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary* mDict;//存放当前可变的字典
    
    //判断当前在UserDefaults中是否存在gameGlobalState这个键，为了防止命名冲突，所以添加了这个命名空间
    if([userDefaults objectForKey:@"gameGlobalState"]){
        
        NSDictionary* gameGlobalState = [userDefaults objectForKey:@"gameGlobalState"];
        
        //如果存在gameGlobalState
        //由于从userDefaults中获取到的都是不可变对象，因此还是需要创建的
        mDict = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"gameGlobalState"]];
        
        //判断是否需要修正上一次读取健康计数值的时间
        if([@"single" isEqualToString:[gameGlobalState objectForKey:@"type"]]){
            //如果是单人模式，则判断是否已经开始了今日的计步
            if([[self getTodayDate] isEqualToString:[gameGlobalState objectForKey:@"token"]]){
                //如果是已经开始了今天的计步，则不重置时间
            }else{
                //否则重置时间
                [mDict setValue:[HSDataFormatHandle toLocalTime:[[NSDate alloc] init]] forKey:@"last_statistic_time"];
            }
        }
        
        if([@"multiple" isEqualToString:[gameGlobalState objectForKey:@"type"]]){
            //如果是多人模式，则判断当前正在进行的任务是否就是上一次的计数任务
            if(![[dict objectForKey:@"token"] isEqualToString:[gameGlobalState objectForKey:@"token"]]){
                //如果目前要设置的多人任务并不是正在计数的，则重置时间
                [mDict setValue:[HSDataFormatHandle toLocalTime:[[NSDate alloc] init]] forKey:@"last_statistic_time"];
            }
        }
        
    }else{
        
        //如果不存在，则创建新的对象
        mDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        
        //设置上一次的读取时间为当前
        //注意，考虑到苹果的HealthKit的数值存在延时，所以设置开始某个游戏时间为上一次取值时间
        [mDict setValue:[HSDataFormatHandle toLocalTime:[[NSDate alloc] init]] forKey:@"last_statistic_time"];
    }
    
    //判断如果是Type为nil，则表示重置当前时间
    if(![dict objectForKey:@"type"]){
        [mDict setValue:[HSDataFormatHandle toLocalTime:[[NSDate alloc] init]] forKey:@"last_statistic_time"];
    }
    
    //将Dict中的值依次覆盖到mDict中
    if(dict){
        for (NSString *key in dict) {
            
            [mDict setObject:dict[key] forKeyedSubscript:key];
            
        }
    }
    
    //存入当前的全局游戏状态
    [userDefaults setValue:mDict forKey:@"gameGlobalState"];
    
}

#pragma mark 获取今日的日期，譬如 2014-9-18
-(NSString*)getTodayDate{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //返回今日时间的数据
    return currentDateStr;

}

@end
