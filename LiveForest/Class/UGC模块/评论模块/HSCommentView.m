//
//  HSCommentView.m
//  LiveForest
//
//  Created by Swift on 15/5/13.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSCommentView.h"
//#import "HSCommentCell.h"
//@interface HSCommentView()<UITextViewDelegate>
//@end
@implementation HSCommentView

//@synthesize containView;
//@synthesize fitFactor;
//@synthesize blackBtn;
//@synthesize backBtn;

//static NSString *reuseIdentifier=@"CommentCell";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self =  [super initWithFrame:frame]) {
        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSCommentView"
                                                     owner:nil options:nil];
        self=array[0];
    }
    return self;
}

- (void)awakeFromNib {
    
    //视图透明
    self.backgroundColor=[UIColor clearColor];
    
    //textView边框
    self.commentTextView.layer.borderWidth = 0.5;
    self.commentTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.commentTextView.layer.cornerRadius = 6;
    
    //缩小容器视图
    self.containView.transform=CGAffineTransformMakeScale(0.85, 0.85);
    
    self.uilabel.text = @"我也说一句";
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];
}


@end
