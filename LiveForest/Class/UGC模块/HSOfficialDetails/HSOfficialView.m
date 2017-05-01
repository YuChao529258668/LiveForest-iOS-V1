//
//  HSOfficialView.m
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSOfficialView.h"
#import "HSCommentViewController.h"

#import "Macros.h"

@interface HSOfficialView()
@property (nonatomic, strong) HSCommentViewController *commentVC;
@end

@implementation HSOfficialView{
    bool isreported;
}

//评论视图
@synthesize commentView;
@synthesize shareID;

//large
@synthesize avataImgBtnLarge;
@synthesize contentImgViewLarge;
@synthesize nameLabelLarge;
@synthesize timeLabelLarge;
@synthesize textLabelLarge;
@synthesize praiseBtnLarge;
@synthesize praiseLabelLarge;
@synthesize commentBtnLarge;
@synthesize progressView;
//@synthesize commentViewController;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews;
//        if([UIScreen mainScreen].bounds.size.height==568) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSOfficialView" owner:self options:nil];
//        } else if([UIScreen mainScreen].bounds.size.height==667) {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSOfficialView@6" owner:self options:nil];
//        } else if([UIScreen mainScreen].bounds.size.height==480) {
//            
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSOfficialView@4s" owner:self options:nil];
//        }else {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSOfficialView@6P" owner:self options:nil];
//        }
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
    
        
        // 加载nib
        self = arrayOfViews[0];
        
        //屏幕适配
        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
        
        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
        CGRect frame=self.frame;
        frame.origin=CGPointZero;
        self.frame=frame;

        
//        //添加评论
//        self.addCommentView.alpha=0;
//        self.blackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
//        self.blackImageView.backgroundColor=[UIColor blackColor];
//        self.blackImageView.alpha=0;
//        
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCommentViewDisappearWithAnimation)];
//        //        tap.numberOfTouchesRequired = 1; //手指数
//        //        tap.numberOfTapsRequired = 1; //tap次数
//        //        tap.delegate= self;
//        
//        self.blackImageView.userInteractionEnabled=YES;
//        [self.blackImageView addGestureRecognizer:tap];
//        
//        
//        [self addSubview:self.blackImageView];
//        [self insertSubview:self.addCommentView aboveSubview:self.blackImageView];
//        
//        [self.commentBtnLarge addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.addCommentViewSendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        
        
        //7.30
        //评论模块
//        [self initComment];
//        为了方便评论控制器判断是谁的评论按钮。。。
        [commentBtnLarge setTitle:@"HSOfficialView" forState:UIControlStateDisabled];
//        [self addTarget];
        
        //图片交互处理
//        UITapGestureRecognizer *tapContentImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellContentImage)];
//        [self.contentImgViewLarge setUserInteractionEnabled:YES];
//        [self.contentImgViewLarge addGestureRecognizer:tapContentImage];
        
        
        //图片交互
        self.contentImgArray = [[NSMutableArray alloc]init];
        
        //头像
        avataImgBtnLarge.layer.cornerRadius = avataImgBtnLarge.frame.size.width/2;
        avataImgBtnLarge.clipsToBounds = YES;
        
        //举报按钮  todo
        isreported = false;
        [self.reportBtn addTarget:self action:@selector(reportBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

//#pragma mark <评论按钮>
//-(void)commentBtnClick {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentBtnClick" object:self];
//}

//#pragma mark <发送评论按钮>
//- (void)sendComment{
//    [self addCommentViewDisappearWithAnimation];
//}

//#pragma mark <提示发送评论成功>
//-(void)showSendCommentSuccess {
//    [UIView animateWithDuration:2 animations:^{
//        self.addCommentView.transform=CGAffineTransformMakeScale(1.4, 1.4);
//        self.blackImageView.alpha=0.7;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.addCommentView.transform=CGAffineTransformMakeScale(1, 1);
//        }];
//    }];
//}

//#pragma mark <添加评论视图的显示动画>
//-(void)addCommentViewShowWithAnimation {
//    //    [self.addCommentViewTextView becomeFirstResponder];
//    self.commentView=[[HSCommentView alloc]init];
//    //    NSLog(@"%@",self.addCommentView);
//    static HSCommentViewController *commentVC;
//    commentVC=[[HSCommentViewController alloc]init];
//    commentView.tableView.dataSource=commentVC;
//    commentView.tableView.delegate=commentVC;
//    //    NSLog(@"%@",commentVC);
//    
//    self.commentView.backgroundColor=[UIColor clearColor];
//    self.commentView.alpha=1;
//    [self addSubview:self.commentView];
//    
//    self.commentView.transform=CGAffineTransformMakeScale(0.1, 0.1);
//    
//    [UIView animateWithDuration:0.15 animations:^{
//        self.commentView.transform=CGAffineTransformMakeScale(1.4, 1.4);
//        //        self.blackImageView.alpha=0.7;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.commentView.transform=CGAffineTransformMakeScale(1, 1);
//        }];
//    }];
//}
//-(void)addCommentViewShowWithAnimation2 {
//    [self.addCommentViewTextView becomeFirstResponder];
//    self.addCommentView.alpha=1;
//    self.addCommentView.transform=CGAffineTransformMakeScale(0.1, 0.1);
//    
//    [UIView animateWithDuration:0.15 animations:^{
//        self.addCommentView.transform=CGAffineTransformMakeScale(1.4, 1.4);
//        self.blackImageView.alpha=0.7;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.addCommentView.transform=CGAffineTransformMakeScale(1, 1);
//        }];
//    }];
//}
//
//#pragma mark <添加评论视图的消失动画>
//-(void)addCommentViewDisappearWithAnimation {
//    [self.addCommentViewTextView resignFirstResponder];
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        self.addCommentView.transform=CGAffineTransformMakeScale(1.4, 1.4);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15 animations:^{
//            self.addCommentView.transform=CGAffineTransformMakeScale(0.1, 0.1);
//            self.blackImageView.alpha=0;
//        } completion:^(BOOL finished) {
//            self.addCommentView.alpha=0;
//        }];
//    }];
//}

//#pragma mark 评论模块，创建评论视图和评论控制器
//- (void)initComment {
//    //创建评论视图
//    commentView =[[HSCommentView alloc]init];
//    //    NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSCommentView" owner:nil options:nil];
//    //    commentView=array[0];
//    commentView.alpha=0;
//    
//    //    //设置评论视图的shareID
//    //    commentView.shareID=self.shareID;
//    
//    //todo commentview应该放在最高层
////    [self addSubview:commentView];
////    [[[UIApplication sharedApplication] keyWindow] insertSubview:commentView aboveSubview:self];
////    commentView
//}

//yc 7.30
//- (HSCommentViewController *)commentViewController {
//    if (!commentViewController) {
//        commentViewController = [[HSCommentViewController alloc]init];
//    }
//    return commentViewController;
//}

//yc 7.30
//- (void)addTarget {
//    commentViewController = [[HSCommentViewController alloc]init];
//
//    [self.commentBtnLarge addTarget:commentViewController action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//}


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

- (void)awakeFromNib {
    [self.commentBtnLarge addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.avataImgBtnLarge.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.avataImgBtnLarge.backgroundColor = [UIColor redColor];
//    self.avataImgBtnLarge.imageView.backgroundColor = [UIColor blueColor];
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.avataImgBtnLarge.imageView.layer.cornerRadius = self.avataImgBtnLarge.imageView.frame.size.width / 2;
//    self.avataImgBtnLarge.imageView.clipsToBounds = YES;
//
//}
- (void)updateCommentCountLabel {
//    int commentCount = [self.commentCountLabel.text intValue];
//    commentCount ++;
//    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentCount];
}

- (void)commentBtnClick:(UIButton *)btn {
    if (!self.commentVC) {
        __weak HSOfficialView *weakSelf = self;
        self.commentVC = [[HSCommentViewController alloc]initWithShareID:self.shareID
                                               sendCommentSuccessHandler:^{
            [weakSelf updateCommentCountLabel];
         }];
    }
    [self.commentVC showOrHide];
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
