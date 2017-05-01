//
//  HSMyCurrentGameModel.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSMyCurrentGameModel : NSObject



//task_time_limit:任务时限(整数)

//任务奖励描述
@property(nonatomic,copy)NSString *task_description;
@property(nonatomic,copy)NSString *to_who;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *task_end_time;

//task_leave_words:发起人所留的留言
@property(nonatomic,copy)NSString *task_leave_words;
@property(nonatomic,copy)NSString *task_state;

//task_id:多人任务id
@property(nonatomic,copy)NSString *task_id;
@property(nonatomic,copy)NSString *_id;
@property(nonatomic,copy)NSString *task_time_limit;

//task_goal:任务目标
@property(nonatomic,copy)NSString *task_goal;

//receptNum:接受该任务的人数
@property(nonatomic,copy)NSString *receptNum;


//task_description":"hehe",
//"to_who":"hhhh",
//"task_create_time":1441470370000,
//"user_id":"14321850037342437",
//"task_end_time":1442479409000,
//"task_leave_words":"hehe",
//"task_state":"0",
//"task_id":5,
//"_id":1,
//"task_time_limit":500,
//"task_goal":300,
//"receptNum":1


@end
