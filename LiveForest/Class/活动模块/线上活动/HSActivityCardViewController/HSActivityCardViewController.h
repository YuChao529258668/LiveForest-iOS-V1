//
//  HSActivityCardViewController.h
//  LiveForest
//
//  Created by 余超 on 15/7/20.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSActivityCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSObject *largeCardViewData;

#pragma mark <设置cell的子视图透明度>
- (void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber;


@end
