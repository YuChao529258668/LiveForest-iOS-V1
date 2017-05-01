//
//  HSEditMultipleView.h
//  LiveForest
//
//  Created by Swift on 15/6/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <TuSDK/TuSDK.h>

@interface HSEditMultipleView : TuSDKPFEditMultipleView
@property(nonatomic, strong) UIButton *tagBtn;//标签按钮
@property(nonatomic, strong) UITextField *tagTF;//输入标签

@property(nonatomic, strong) UITapGestureRecognizer *tap;

//6.15
@property(nonatomic, strong) UIBarButtonItem *nextStepBtn;//下一步按钮
@property(nonatomic, strong) UIBarButtonItem *completeBtnOfTuSDK;//涂图的完成按钮
@property(nonatomic, strong) TuSDKPFEditMultipleController *editMultipleController;//该界面的控制器

@end
