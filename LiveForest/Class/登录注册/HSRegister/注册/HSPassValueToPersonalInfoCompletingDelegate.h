//
//  UIViewPassValueDelegate.h
//  LiveForest
//
//  Created by 微光 on 15/4/19.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HSPassValueToPersonalInfoCompletingDelegate <NSObject>

@required
- (void)passValue:(NSDictionary *)value;

@end
