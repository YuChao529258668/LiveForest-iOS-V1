//
//  SingletonForRootViewCtrl.h
//  LiveForest
//
//  Created by 微光 on 15/6/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSViewController.h"



@interface SingletonForRootViewCtrl : NSObject

+ (HSViewController *) sharedInstance;


@end
