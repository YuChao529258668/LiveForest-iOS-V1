//
//  HSVisitMineView.h
//  LiveForest
//
//  Created by Swift on 15/4/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSMineDetailViewController.h"

@interface HSVisitMineView : UIView

//@region 界面元素绑定

/*头部背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

/*底部倒影图片*/
@property (nonatomic, weak) IBOutlet UIImageView *reflected;

/*头像图片*/
@property (weak, nonatomic) IBOutlet UIImageView *avartarImage;

/*关注的人字样*/
@property (strong, nonatomic) IBOutlet UILabel *attendStateLabel;

/*关注的人数*/
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;

/*显示粉丝字样*/
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

/*显示个人详细资料*/
@property (weak, nonatomic) IBOutlet UIButton *friendRankBtn;

/*聊天按钮*/
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

/*关注按钮*/
@property (weak, nonatomic) IBOutlet UIButton *attendBtn;

/*用户名*/
@property (weak, nonatomic) IBOutlet UILabel *nickName;

/*用户性别与年龄*/
@property (weak, nonatomic) IBOutlet UILabel *sexAge;

/*判断是否已经关注过*/
@property (nonatomic, assign) bool hasAttended;

//获取个人详情
@property (strong, nonatomic) IBOutlet UIButton *showDetailInfoBtn;

/*回退按钮,Deprecated*/
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

//@region 公开类成员
/*指向当前UIView对应的父类的Controller*/
@property (weak, nonatomic) UIViewController* parentUIVIewController;

//@region 外部接口
-(instancetype)initWithParentController:(UIViewController*) parentUIViewController;

/*响应用户点击详细资料的事件*/
- (IBAction)onClickByDetailButton:(id)sender;

@end
