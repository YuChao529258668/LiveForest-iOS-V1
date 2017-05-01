//
//  HSShareView.m
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSShareView.h"

@implementation HSShareView

@synthesize blackImageView;
@synthesize scrollView;

@synthesize imageViewArray;
@synthesize imageView0;
@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize imageView5;
@synthesize imageView6;
@synthesize imageView7;
@synthesize imageView8;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init {
    self=[super init];
    if (self) {
        NSArray *arrayOfViews;
//        if([UIScreen mainScreen].bounds.size.height==568) {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSShareActivityViewController" owner:self options:nil];
//        }
//        else if([UIScreen mainScreen].bounds.size.height==667) {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSShareActivityViewController@2x" owner:self options:nil];
//        }else if([UIScreen mainScreen].bounds.size.height==480) {
//            
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSShareActivityViewController@4s" owner:self options:nil];
//        }
//        else {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSShareActivityViewController@3x" owner:self options:nil];
//        }
        
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSShareActivityViewController@2x" owner:self options:nil];
        
        self=arrayOfViews[0];
        
        //屏幕适配
        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
        
        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
        CGRect frame=self.frame;
        frame.origin=CGPointZero;
        self.frame=frame;
        

        //初始化imageview数组
        [self initImageViewArray];
    }
    
    blackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    blackImageView.backgroundColor=[UIColor blackColor];
    blackImageView.alpha=0.7;
    [self insertSubview:blackImageView belowSubview:self.shareView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(txtFieldResign)];
    [self addGestureRecognizer:tap];
    
//    [self.shareBtn addTarget:self action:@selector(addCommentViewDisappearWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    
//    self.shareView.layer.cornerRadius=10;
    self.avarlImage.layer.cornerRadius=self.avarlImage.frame.size.width/2;
    self.avarlImage.clipsToBounds=YES;
//    self.bottomBarImage.layer.cornerRadius=4;
    self.shareView.clipsToBounds=YES;
    
    
    //跟大家分享些什么？
    self.shareTextView.delegate = self;
    self.uilabel.text = @"跟大家分享些什么？";
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];



    return self;
}
#pragma mark shareTextView代理实现
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.commentTextView.text =  textView.text;
    if (textView.text.length == 0) {
        self.uilabel.text = @"跟大家分享些什么？";
    }else{
        self.uilabel.text = @"";
    }
}

#pragma txtFieldResign
- (void) txtFieldResign{
    if([self.shareTextView isFirstResponder]){
        [self.shareTextView resignFirstResponder];
    }
}
#pragma mark 消失动画
//-(void)addCommentViewDisappearWithAnimation {
//    [self.shareTxtField resignFirstResponder];
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        self.shareView.transform=CGAffineTransformMakeScale(1.4, 1.4);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15 animations:^{
//            self.shareView.transform=CGAffineTransformMakeScale(0.1, 0.1);
//            blackImageView.alpha=0;
//        } completion:^(BOOL finished) {
//            self.shareView.alpha=0;
//        }];
//    }];
//}

#pragma mark 初始化imageView数组
- (void)initImageViewArray {
    imageViewArray= [[NSMutableArray alloc]initWithObjects:imageView0, imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8, nil];
    
    //配置iamgeview
    for (UIImageView *iv in imageViewArray) {
        iv.clipsToBounds = YES;
        iv.contentMode=UIViewContentModeScaleAspectFill;
        iv.userInteractionEnabled=YES;
    }
}
@end
