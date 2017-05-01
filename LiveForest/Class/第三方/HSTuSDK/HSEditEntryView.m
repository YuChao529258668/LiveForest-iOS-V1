//
//  HSEditEntryView.m
//  LiveForest
//
//  Created by Swift on 15/4/18.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSEditEntryView.h"
#import "AppDelegate.h"

@implementation HSEditEntryView

@synthesize image;
@synthesize gpuImageView;
@synthesize tagBtn;
@synthesize tagTF;
@synthesize tap;
@synthesize closeKeyboardBtn;


//-(instancetype)init {
//    self=[super init];
//    if (self) {
//
//    }
//    return self;
//}

- (void)initView {
    [super initView];
    
//    self.optionBar.filterButton.frame = self.optionBar.cutButton.frame;
//
//    
//    self.optionBar.cutButton.hidden = YES;
//    self.optionBar.cutButton.alpha = 0.2;
//    [self.optionBar.cutButton removeFromSuperview];
    
    
}

- (void)layoutSubviews {
//    self.optionBar.filterButton.frame = self.optionBar.cutButton.frame;
    self.optionBar.stickerButton.frame = self.optionBar.filterButton.frame;
    
    self.optionBar.cutButton.hidden = YES;
    self.optionBar.filterButton.hidden = YES;
    
//    [self.optionBar.cutButton removeFromSuperview];

}
//-(void)initView {
//    [super initView];
//    
//    self.optionBar.cutButton.backgroundColor=[UIColor redColor];
//    [self.optionBar.cutButton setImage:[UIImage imageNamed:@"评论头像.png"] forState:(UIControlStateNormal)];
//    
//    self.optionBar.filterButton.backgroundColor=[UIColor yellowColor];
//    self.optionBar.stickerButton.backgroundColor=[UIColor blueColor];
//    
//    self.optionBar.backgroundColor=[UIColor greenColor];
//    
//    self.bottomBar.backButton.backgroundColor=[UIColor grayColor];
//    self.bottomBar.backgroundColor=[UIColor brownColor];
//    
//    
//    //获取放图的控件
//    [self setGpuImageView];
//    
//    [self initTagBtn];
//    [self initTagTextField];
//    //    [self initCloseKeyboardBtn];
//    [self initTapGesture];
//    
//    //    image=gpuImageView.image;
//    
//    //    NSLog(@"%@",self.optionBar.filterButton.superview);
//    //    NSLog(@"%@",gpuImageView.image.superclass);
//    //    NSLog(@"%@",gpuImageView.image);
//    
//    
//    [self.bottomBar.completeButton addTarget:self action:@selector(getScreenShotCut) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    
//    //    //self.imageView 是 TuSDKPFEditEntryImageView
//    //    NSArray *imageViewSubviews=[self.imageView subviews];
//    //    for (UIView *view in imageViewSubviews) {
//    //        NSLog(@"%@",view);
//    //        if ([view isKindOfClass:[TuSDKICGPUImageView class]]) {
//    //            gpuImageView=(TuSDKICGPUImageView *)view;//获取放图的控件
//    //            //            break;
//    //        }
//    //    }
//    //
//    //    NSArray *superViewSubViews=[[self superview]subviews];
//    //    for (UIView *view in superViewSubViews) {
//    //        NSLog(@"%@",view);
//    //    }
//    //
//    //    NSArray *gpuImageViewSubviews=[gpuImageView subviews];
//    //    for (UIView *view in gpuImageViewSubviews) {
//    //        NSLog(@"%@",view);
//    //    }
//    //
//    //    self.imageView.transform=CGAffineTransformMakeScale(0.3, 0.3);
//    //    gpuImageView.transform=CGAffineTransformMakeScale(0.3, 0.3);
//    //    [gpuImageView removeFromSuperview];
//    //    [self addSubview:gpuImageView];
//    
//    //    gpuImageView.clipsToBounds=YES;
//    
//    //    self.backgroundColor=[UIColor redColor];
//    
//    
//}

//屏幕截图
- (void)getScreenShotCut {
    //屏幕截图
    UIGraphicsBeginImageContext(tagTF.frame.size);
    
    //    [[[UIApplication sharedApplication]keyWindow].layer renderInContext:UIGraphicsGetCurrentContext()];
    //    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    [gpuImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    [tagTF.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //    UIGraphicsBeginImageContext(gpuImageView.frame.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSaveGState(context);
    //    UIRectClip(gpuImageView.frame);
    //    [self.layer renderInContext:context];
    //    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    d.imageOfTuSDK=theImage;
    
    
    AppDelegate *d=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    d.imageOfTuSDK=screenShotCut;
    
    NSLog(@"%@",gpuImageView.image);
    
    
    //    NSArray *gpuImageViewSubviews=[gpuImageView subviews];
    //    for (UIView *view in gpuImageViewSubviews) {
    //        NSLog(@"%@",view);
    //    }
    //    [self addSubview:gpuImageView];
    //    gpuImageView.p
}

//获取第三方的视图，缩放、裁剪子视图都没有效果，但是remove后就看不到图片了，但其image属性始终是nil
- (void)setGpuImageView {
    //self.imageView 是 TuSDKPFEditEntryImageView
    NSArray *subviews=[self.imageView subviews];
    for (UIView *view in subviews) {
        //        NSLog(@"%@",view);
        if ([view isKindOfClass:[TuSDKICGPUImageView class]]) {
            gpuImageView=(TuSDKICGPUImageView *)view;//获取放图的控件
            break;
        }
    }
    
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
    
    tagTF.center=gpuImageView.center;
    
    tagTF.backgroundColor=[UIColor redColor];
    
    tagTF.alpha=0;
    
    tagTF.placeholder=@"输入标签";
    
//    [self addSubview:tagTF];
    [gpuImageView addSubview:tagTF];
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
//关闭键盘按钮
- (void)initCloseKeyboardBtn {
    closeKeyboardBtn =[[UIButton alloc]initWithFrame:self.frame];
    [closeKeyboardBtn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:closeKeyboardBtn];
    [self.imageView sendSubviewToBack:closeKeyboardBtn];
}
//手势关闭键盘
- (void)initTapGesture {
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)closeKeyboard {
    [tagTF resignFirstResponder];
}



- (void)viewWillDestory {
    //    //屏幕截图
    //    UIGraphicsBeginImageContext(self.frame.size);
    //    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    gpuImageView.image=[UIImage imageNamed:@"评论头像2.jpg"];
    
    //    NSLog(@"%@",gpuImageView);
    //    cuterResult.imageNamed;
}

@end
