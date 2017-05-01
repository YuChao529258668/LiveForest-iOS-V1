//
//  HSVisitMineCell.m
//  LiveForest
//
//  Created by 余超 on 15/4/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSVisitMineCell.h"

#import "Macros.h"

#import "HSCommentViewController.h"

@interface HSVisitMineCell()
@property (nonatomic, strong) HSCommentViewController *commentVC;
@end
@implementation HSVisitMineCell{
    bool isreported;
}

@synthesize arrayLarge;
@synthesize arraySmall;

//small
@synthesize contentImgViewSmall;
@synthesize nameLabelSmall;
@synthesize timeLabelSmall;
@synthesize textLabelSmall;

//large
@synthesize contentImgViewLarge;
@synthesize nameLabelLarge;
@synthesize timeLabelLarge;
@synthesize textLabelLarge;
@synthesize praiseBtnLarge;
@synthesize praiseLabelLarge;
@synthesize commentBtnLarge;
@synthesize progressView;

//添加评论
@synthesize addCommentView;
@synthesize addCommentViewAvartar;
@synthesize addCommentViewTextView;
@synthesize addCommentViewSmileBtn;
@synthesize addCommentViewAtBtn;
@synthesize addCommentViewSendBtn;
@synthesize blackImageView;

@synthesize shareThird;

@synthesize commentView;

- (void)awakeFromNib {
    [self.commentBtnLarge addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)updateCommentCountLabel {
    int commentCount = [self.commentCount.text intValue];
    commentCount ++;
    self.commentCount.text = [NSString stringWithFormat:@"%d",commentCount];
}

- (void)commentBtnClick:(UIButton *)btn {
    if (!self.commentVC) {
        __weak HSVisitMineCell *weakSelf = self;
        self.commentVC = [[HSCommentViewController alloc]initWithShareID:self.shareID
                                               sendCommentSuccessHandler:^{
                                                   [weakSelf updateCommentCountLabel];
                                               }];
    }
    [self.commentVC showOrHide];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HSVisitMineCell" owner:self options:nil];
        self = array[0];
        
        //屏幕适配
        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
        CGRect frame=self.frame;
        frame.origin=CGPointZero;
        self.frame=frame;

        
        [self initArrays];
        
        
        [self.praiseBtnLarge addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.shareThird addTarget:self action:@selector(sendThirdShare) forControlEvents:UIControlEventTouchUpInside];

        //举报按钮  todo
        isreported = false;
        [self.reportBtn addTarget:self action:@selector(reportBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark <初始化子视图数组>
-(void)initArrays {
    
    arraySmall=[[NSMutableArray alloc]initWithObjects:
                contentImgViewSmall,
                nameLabelSmall,
                timeLabelSmall,
                textLabelSmall, nil];
    arrayLarge=[[NSMutableArray alloc]initWithObjects:
                contentImgViewLarge,
                nameLabelLarge,
                timeLabelLarge,
                textLabelLarge,
                praiseBtnLarge,
                praiseLabelLarge,
                commentBtnLarge,
                progressView,
                shareThird,
                _mapLocationLabel,
                _mapLocationImg,
                self.reportBtn,
                self.reportLabel,
                self.commentCount, nil];
}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
    for (UIView *view in arraySmall) {
        view.alpha=2-factor;
    }
    for (UIView *view in arrayLarge) {
        view.alpha=factor-1;
    }
}

- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];
    for (UIView *view in arraySmall) {
        view.alpha=2-factor;
    }
    for (UIView *view in arrayLarge) {
        view.alpha=factor-1;
    }
}


- (void)praiseBtnClick {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSMineCellPraise" object:self];
    NSLog(@"praise按钮发通知啦！");
}

#pragma mark <第三方>
- (void)sendThirdShare{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSMineCellThird" object:self];
    NSLog(@"第三方按钮发通知啦！");
    
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
        textView.text=textLabelLarge.text;
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

#pragma mark 举报按钮
- (void)reportBtnPress:(UIButton*)btn{
    if(isreported){
        ShowHud(@"您已举报过了，正在审核中。", NO);
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要举报此用户发的内容吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        isreported = true;
        ShowHud(@"正在审核中", NO);
    }
}
@end
