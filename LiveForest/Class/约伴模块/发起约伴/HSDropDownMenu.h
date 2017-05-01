//
//  HSDropDownMenu.h
//  LiveForest
//
//  Created by wangfei on 8/5/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSDropDownMenu : UIView
+(instancetype)menuFrom:(UIView *)from sportID:(NSString *)sportID;
/**
 *  显示,加入到传入的视图下面
 */
-(void)showFrom:(UIView *)from;
/**
 *  销毁
 */
-(void)dismiss;

@end
