//
//  HSCommentView.h
//  LiveForest
//
//  Created by Swift on 15/5/13.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCommentView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *smileBtn;//表情按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;//黑色背景按钮
@property (weak, nonatomic) IBOutlet UIView *containView;//放很多控件

//屏幕适配因子
@property (nonatomic) float fitFactor;

@property (strong, nonatomic) IBOutlet UILabel *uilabel;//占位符

@end
