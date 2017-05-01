//
//  HSIndexCellLargeView.m
//  LiveForest
//
//  Created by 余超 on 15/11/4.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSIndexCellLargeView.h"

@implementation HSIndexCellLargeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    if (self = [super init]) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HSIndexCellLargeView" owner:nil options:nil];
        self = array[0];
    }
    return self;
}


#pragma mark 点击查看更多文字
- (IBAction)showDetailBtnClick:(UIButton *)btn {

    static UIView *view;

    if (!view) {
    view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];

    UITextView *textView=[[UITextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    CGRect f=textView.frame;
    f.size.width=textView.frame.size.width*0.9;
    f.size.height=textView.frame.size.height*0.9;
    textView.frame=f;
    textView.center=[UIApplication sharedApplication].keyWindow.center;
    textView.text=self.textLabelLarge.text;
    textView.editable=NO;
    textView.font=[UIFont systemFontOfSize:34];
        //        textView.textAlignment=UITextAlignmentCenter;
        
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, textView.contentSize.width, textView.contentSize.height)];
        [backBtn addTarget:self action:@selector(showDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:textView];
        [textView addSubview:backBtn];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        
    } else {
        [view removeFromSuperview];
        view=nil;
    }
}

//
//- (void)setAlpha:(CGFloat)alpha {
//    [super setAlpha:alpha];
//    
//    if (alpha) {
////        self
//    } else {
//        [self removeFromSuperview];
//    }
//}

@end
