//
//  HSAddressInfoVC.h
//  LiveForest
//
//  Created by wangfei on 7/16/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSAddressInfo;
@interface HSAddressInfoVC : UIViewController

//保存编辑信息
@property (nonatomic, strong)HSAddressInfo *editAddressInfo;

//缓存用户地址信息数组，便于提交后台
@property (nonatomic, strong)NSMutableArray *tempAddressArrayM;

//更新后台用户收货地址，因为用户收货地址数据不多可以每次都全部更新
- (void)updateUserAddress:(NSMutableArray *)addressM showLabelTitle:(NSString *)title;
@end
