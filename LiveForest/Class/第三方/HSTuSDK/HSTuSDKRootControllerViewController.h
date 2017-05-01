//
//  HSTuSDKRootControllerViewController.h
//  TuSDKDemo
//
//  Created by 微光 on 15/3/23.
//  Copyright (c) 2015年 Lasque. All rights reserved.
//

#import <TuSDK/TuSDK.h>
//#import "HSRootView.h"
//#import "SimpleEditTurnAndCutView.h"
@interface HSTuSDKRootControllerViewController : TuSDKICViewController<TuSDKFilterManagerDelegate, UITextFieldDelegate>{
   
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
}
/**
 *  覆盖控制器视图
 */
//@property (nonatomic, retain) HSRootView *view;
@property (nonatomic, retain) UIImageView *imageView;
@end
