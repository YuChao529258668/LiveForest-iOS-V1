//
//  HSEditEntryView.h
//  LiveForest
//
//  Created by Swift on 15/4/18.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <TuSDK/TuSDK.h>

@interface HSEditEntryView : TuSDKPFEditEntryView 

@property(nonatomic, strong) UIImage *image;//TuSDK的图片
@property(nonatomic, strong) TuSDKICGPUImageView *gpuImageView;//放图的控件
@property(nonatomic, strong) UIButton *tagBtn;//标签按钮
@property(nonatomic, strong) UITextField *tagTF;//输入标签

@property(nonatomic, strong) UITapGestureRecognizer *tap;
@property(nonatomic, strong) UIButton *closeKeyboardBtn;

@end
