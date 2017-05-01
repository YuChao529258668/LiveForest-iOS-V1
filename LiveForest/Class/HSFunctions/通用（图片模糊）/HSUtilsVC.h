//
//  HSUtilsVC.h
//  LiveForest
//
//  Created by 微光 on 15/6/6.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMessage.h"

@interface HSUtilsVC : UIViewController

//高斯模糊
- (UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur;

//获取设备uuid
+(NSString*) getUuid;

@end
