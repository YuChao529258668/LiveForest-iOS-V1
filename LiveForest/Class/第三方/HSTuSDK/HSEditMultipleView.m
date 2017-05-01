//
//  HSEditMultipleView.m
//  LiveForest
//
//  Created by Swift on 15/6/2.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSEditMultipleView.h"
#import "AppDelegate.h"
#import "HSLabelViewController.h"

@implementation HSEditMultipleView
@synthesize tagBtn;
@synthesize tagTF;
@synthesize tap;
@synthesize nextStepBtn;
@synthesize completeBtnOfTuSDK;
@synthesize editMultipleController;

/*
 // 操作步骤视图
 TuSDKPFEditEntryStepView *_stepView;
 // 后退按钮
 UIButton *_prevButton;
 // 前进按钮
 UIButton *_nextButton;
 
 // 选项栏目
 TuSDKPFEditMultipleOptionBar *_optionBar;
 // 横向滚动视图
 UIScrollView *_wrapView;
 // 模块按钮列表
 NSMutableArray *_buttons;
 
 // 图片视图
 UIImageView *_imageView;
 @property(nonatomic,retain) UIImage *image;    // default is nil

*/

-(void)initView {
    [super initView];
    
    self.optionBar.wrapView.backgroundColor=[UIColor blackColor];
    
//    self.optionBar.backgroundColor=[UIColor greenColor];

//    [self initTagBtn];
//    [self initTagTextField];
//    [self initTapGesture];
    
//    [self addNextStepBtn];
//    UIBarButtonItem *completeBtn=self.
    
    //6.15
    [self getTuSDKControllerAndCompleteBtn];
    
    
}



//标签按钮
- (void)initTagBtn {
    
    tagBtn=[[UIButton alloc]initWithFrame:CGRectZero];
    
    //    tagBtn.center=self.center;
    
    CGRect frame=tagBtn.frame;
    //    frame.size.height=frame.size.height*0.2;
    //    frame.size.width=frame.size.width*0.3;
    //    frame.origin.y=self.frame.size.height*0.7;
    frame.size.height=50;
    frame.size.width=100;
    frame.origin.x=self.center.x-frame.size.width/2;
    frame.origin.y=self.optionBar.frame.origin.y-frame.size.height;
    tagBtn.frame=frame;
    
    //    CGPoint center=self.center;
    //    center.y=self.optionBar.frame.origin.y-tagBtn.frame.size.height;
    //    tagBtn.center=center;
    
    [tagBtn setTitle:@"标签" forState:UIControlStateNormal];
    tagBtn.backgroundColor=[UIColor greenColor];
    
    [tagBtn addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:tagBtn];
}

//标签
- (void)initTagTextField {
    tagTF = [[UITextField alloc]initWithFrame:CGRectZero];
    CGRect frame=tagTF.frame;
    frame.size.height=40;
    frame.size.width=self.frame.size.width;
    
    tagTF.frame=frame;
    
    tagTF.center=self.imageView.center;
    
    tagTF.backgroundColor=[UIColor whiteColor];
    
    tagTF.alpha=0;
    
    tagTF.placeholder=@"输入标签";
    
    [self addSubview:tagTF];
    [self bringSubviewToFront:tagTF];
}

//添加标签
- (void)addTag {
    if (tagTF.alpha==0) {
        tagTF.alpha=0.8;
        [tagTF becomeFirstResponder];
    } else {
        tagTF.alpha=0;
        [tagTF resignFirstResponder];
    }
}

//手势关闭键盘
- (void)initTapGesture {
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
//    [self.imageView addGestureRecognizer:tap];
    [self addGestureRecognizer:tap];
    
}

//关闭键盘的时候保存标签的信息
- (void)closeKeyboard {
    [tagTF resignFirstResponder];
    
    //单例传值
    AppDelegate *d=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    d.imageOfTuSDK=screenShotCut;
    d.tagTextField=tagTF;
    TuSDKResult *result=d.result;
    NSLog(@"%@",d.result);
    NSLog(@"%@",d.result.image);

    [self getScreenShotCut];
    tagTF.alpha=0;

}
//屏幕截图
- (void)getScreenShotCut {
    
    
    TuSDKPFEditMultipleController *c;
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[TuSDKPFEditMultipleController
                                          class]]) {
            NSLog(@"%@",(UIViewController*)nextResponder);
            c=(TuSDKPFEditMultipleController *)nextResponder;
        }
    }
    //    self.imageView.image=c.loadOrginImage;
//    c.inputImage=[UIImage imageNamed:@"评论头像.png"];

    UIImageView *iv=[[UIImageView alloc]initWithImage:c.inputImage];
    
    
    //屏幕截图
//    UIGraphicsBeginImageContext(self.imageView.frame.size);
    UIGraphicsBeginImageContext(iv.frame.size);

    //绘制图片
//    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    [iv.layer renderInContext:UIGraphicsGetCurrentContext()];

    
    //平移
    CGContextRef r=UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(r, self.tagTF.frame.origin.x-self.imageView.frame.origin.x, self.tagTF.frame.origin.y-self.imageView.frame.origin.y);
    
    //绘制标签
    [tagTF.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //获取截图
    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //单例传值
    AppDelegate *d=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    d.imageOfTuSDK=screenShotCut;
    d.resultImage=screenShotCut;
    d.inputImage=screenShotCut;
    
    
    c.inputImage=screenShotCut;
    c.displayImage=c.inputImage;
//        c.inputImage=[UIImage imageNamed:@"评论头像.png"];

//    c.displayImage=screenShotCut;

//    c.displayImage=[UIImage imageNamed:@"评论头像.png"];
}


#pragma mark 6.15
- (void)getTuSDKControllerAndCompleteBtn {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[TuSDKPFEditMultipleController class]]) {
//            NSLog(@"%@",(UIViewController*)nextResponder);
            editMultipleController = (TuSDKPFEditMultipleController *)nextResponder;
            completeBtnOfTuSDK = editMultipleController.navigationItem.rightBarButtonItem;
            [self addNextStepBtn];
            break;
        }
    }
    
    if (editMultipleController==nil) {
        NSLog(@"获取editMultipleController失败，再次获取");
        [self performSelector:@selector(getTuSDKControllerAndCompleteBtn) withObject:nil afterDelay:0.1];
    }
}

//下一步
- (void)addNextStepBtn {
    nextStepBtn = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepBtnClick)];
    editMultipleController.navigationItem.rightBarButtonItem=nextStepBtn;
}

- (void)nextStepBtnClick {
    
    HSLabelViewController *labelViewController=[[HSLabelViewController alloc]init];
    labelViewController.view.backgroundColor=[UIColor whiteColor];
//    [labelViewController initTitleEditViewWithImage:editMultipleController.inputImage];
    labelViewController.image=editMultipleController.inputImage;
    labelViewController.navigationItem.rightBarButtonItem=completeBtnOfTuSDK;

    [editMultipleController pushViewController:labelViewController animated:YES];
    [labelViewController.navigationController setNavigationBarHidden:YES animated:YES];
//    [editMultipleController presentViewController:labelViewController animated:YES completion:nil];
    
//    NSLog(@"%@",editMultipleController.displayImage);
//    NSLog(@"%@",editMultipleController.inputImage);
//    NSLog(@"%@",completeBtnOfTuSDK.title);
//    NSLog(@"%@",completeBtnOfTuSDK.target);

}

@end
