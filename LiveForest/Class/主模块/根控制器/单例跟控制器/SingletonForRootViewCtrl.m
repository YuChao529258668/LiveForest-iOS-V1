//
//  SingletonForRootViewCtrl.m
//  LiveForest
//
//  Created by 微光 on 15/6/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "SingletonForRootViewCtrl.h"

@implementation SingletonForRootViewCtrl

static HSViewController *sharedObj = nil; //第一步：静态实例，并初始化。


+ (HSViewController *) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[HSViewController alloc] init];
        }
    }
    return sharedObj;
}

	
@end
