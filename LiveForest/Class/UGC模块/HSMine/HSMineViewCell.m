//
//  HSMineViewCell.m
//  
//
//  Created by 余超 on 15/4/4.
//
//

#import "HSMineViewCell.h"
#import "HSCommentViewController.h"

@interface HSMineViewCell ()
@property(nonatomic, strong) HSCommentViewController *commentVC;
@end

@implementation HSMineViewCell

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
@synthesize deleteShareBtn;
@synthesize mapLocationBtn;
@synthesize mapLocationLabel;
@synthesize shareThird;
@synthesize largedImage;
@synthesize blackCellEnlargeImage;

@synthesize commentView;

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews;
//        if([UIScreen mainScreen].bounds.size.height==568) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSMineCell" owner:self options:nil];
//        } else if([UIScreen mainScreen].bounds.size.height==667) {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSMineCell@2x" owner:self options:nil];
//        }else if([UIScreen mainScreen].bounds.size.height==480) {
//            
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSMineCell@4s" owner:self options:nil];
//        }
//        else {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSMineCell@3x" owner:self options:nil];
//        }
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            NSLog(@"xib不属于UICollectionViewCell类");
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
        
        
        
        [self initArrays];
        
//        //添加评论
//        self.commentView.alpha=0;
//        self.blackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
//        self.blackImageView.backgroundColor=[UIColor blackColor];
//        self.blackImageView.alpha=0;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCommentViewDisappearWithAnimation)];
//        UIPanGestureRecognizer *panCommentBackground = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(addCommentViewDisappearWithAnimation)];

        //        tap.numberOfTouchesRequired = 1; //手指数
        //        tap.numberOfTapsRequired = 1; //tap次数
        //        tap.delegate= self;
        
//        self.blackImageView.userInteractionEnabled=YES;
//        [self.blackImageView addGestureRecognizer:tap];
//        [commentView addGestureRecognizer:panCommentBackground];
//
//        //5.13
//        self.addCommentViewSendBtn=self.commentView.sendBtn;
//        self.addCommentViewTextView=self.commentView.commentTextView;
//
//        [self addSubview:self.commentView];
//        [self insertSubview:self.blackImageView belowSubview:self.addCommentView];
        //发送评论后，弹窗消失
//        [self.addCommentViewSendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        
//        [self.commentBtnLarge addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];

        
        [self.praiseBtnLarge addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.shareThird addTarget:self action:@selector(sendThirdShare) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapContentImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellContentImage)];
        [self.contentImgViewLarge setUserInteractionEnabled:YES];
        [self.contentImgViewLarge addGestureRecognizer:tapContentImage];
        //        self.enlargeImage = NO;
        
        self.largedImage = [[CRPixellatedView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.largedImage.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *taplargedImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellLargedImage)];
        [self.largedImage setUserInteractionEnabled:YES];
        [self.largedImage addGestureRecognizer:taplargedImage];
        UIPanGestureRecognizer *panBlackCellEnlargeCell = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellLargedImage)];
        //        为了防止用户滑动，只要滑动就退出，todo，换一种方式，通知方式
        [self.largedImage addGestureRecognizer:panBlackCellEnlargeCell];
        
        //抹黑加载图片的view
        blackCellEnlargeImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        blackCellEnlargeImage.backgroundColor=[UIColor blackColor];
        //        blackCellEnlargeImage.alpha=0;
        UITapGestureRecognizer *tapBlackCellEnlargeCell=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageDisappear)];
        blackCellEnlargeImage.userInteractionEnabled=YES;
        [blackCellEnlargeImage addGestureRecognizer:tapBlackCellEnlargeCell];

        
        //评论模块
        [self initComment];
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
                deleteShareBtn,
                mapLocationLabel,
                mapLocationBtn,
                self.commentCount,
                nil];
    
    //为了方便评论控制器判断是谁的评论按钮。。。
    [commentBtnLarge setTitle:@"HSMineViewCell" forState:UIControlStateDisabled];

}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
    //factor初始值为0.5
    for (UIView *view in arraySmall) {
//        view.alpha=(0.95-factor)*2;
                view.alpha=2-factor;
    }
    for (UIView *view in arrayLarge) {
//        view.alpha=(factor-0.5)*2;
                view.alpha=factor-1;
    }
}
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];
    //factor值为1-2.22222
    for (UIView *view in arraySmall) {
        //        view.alpha=(0.95-factor)*2;
        view.alpha=2-factor;
    }
    for (UIView *view in arrayLarge) {
        //        view.alpha=(factor-0.5)*2;
        view.alpha=factor-1;
    }
}




- (void)praiseBtnClick {
    //    [self.indexController praiseBtnClick:self];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSMineCellPraise" object:self];
    NSLog(@"praise按钮发通知啦！");
}

//#pragma mark <评论按钮>
//-(void)commentBtnClick {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentBtnClick" object:self];
//}
//
//#pragma mark <发送评论按钮>
//- (IBAction)addCommentViewSendBtnClick:(UIButton *)sender {
//    //添加评论视图消失动画
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
////-(void)addCommentViewShowWithAnimation2 {
////    [self.addCommentViewTextView becomeFirstResponder];
////    self.commentView.alpha=1;
////    self.commentView.transform=CGAffineTransformMakeScale(0.1, 0.1);
////    
////    [UIView animateWithDuration:0.15 animations:^{
////        self.commentView.transform=CGAffineTransformMakeScale(1.4, 1.4);
////        self.blackImageView.alpha=0.7;
////    } completion:^(BOOL finished) {
////        [UIView animateWithDuration:0.1 animations:^{
////            self.commentView.transform=CGAffineTransformMakeScale(1, 1);
////        }];
////    }];
////}
//
//#pragma mark <添加评论视图的消失动画>
//-(void)addCommentViewDisappearWithAnimation {
////    [self.addCommentViewTextView resignFirstResponder];
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        self.commentView.transform=CGAffineTransformMakeScale(1.4, 1.4);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15 animations:^{
//            self.commentView.transform=CGAffineTransformMakeScale(0.1, 0.1);
////            self.blackImageView.alpha=0;
//        } completion:^(BOOL finished) {
//            self.commentView.alpha=0;
//        }];
//    }];
//}

#pragma mark enlargeImageDisappear
- (void)enlargeImageDisappear{
    
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        [self.largedImage removeFromSuperview];
        [self.blackCellEnlargeImage removeFromSuperview];
    }];
}

//#pragma mark <发送评论按钮>
//- (void)sendComment{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSMineCellComment" object:self];
//    NSLog(@"评论按钮发通知啦！");
//
//    [self addCommentViewDisappearWithAnimation];
//}

#pragma mark <第三方>
- (void)sendThirdShare{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSMineCellThird" object:self];
    NSLog(@"第三方按钮发通知啦！");
    
}

#pragma mark 点击图片放大缩小处理
- (void)tapCellContentImage{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSIndexCellContentImage" object:self];
    NSLog(@"image图片放大按钮发通知啦！");
}

#pragma mark tapCellLargedImage
-(void)tapCellLargedImage{
    //    blackCellEnlargeImage.alpha = 0.6;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSIndexCellLargedImage" object:self];
    NSLog(@"image图片缩小按钮发通知啦！");
}

#pragma mark 评论模块，创建评论视图和评论控制器
- (void)initComment {
    //创建评论视图
    commentView =[[HSCommentView alloc]init];
    //    NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSCommentView" owner:nil options:nil];
    //    commentView=array[0];
    commentView.alpha=0;
    
    //    //设置评论视图的shareID
    //    commentView.shareID=self.shareID;
    [self addSubview:commentView];
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

- (void)commentBtnClick:(UIButton *)btn {
    if (!self.commentVC) {
        __weak HSMineViewCell *weakSelf = self;
        self.commentVC = [[HSCommentViewController alloc]initWithShareID:self.shareID
                                               sendCommentSuccessHandler:^{
                                                   [weakSelf updateCommentCountLabel];
                                                   //            self.commentVC = nil;
                                               }];
    }
    [self.commentVC showOrHide];
    
    //    UIViewController *vc;
    //    if ([self.delegate isKindOfClass:[UIViewController class]]) {
    //        vc = (UIViewController *)self.delegate;
    //    } else {
    //        UIResponder *nextResponder;
    //        for (UIView *next = [self superview]; next; next = next.superview) {
    //            nextResponder = [next nextResponder];
    //            if ([nextResponder isKindOfClass:[UIViewController class]]) {
    //                vc = (UIViewController*)nextResponder;
    //            }
    //        }
    //    }
    //    [vc presentViewController:self.commentVC animated:YES completion:nil];
}
- (void)updateCommentCountLabel {
//    int commentCount = [self.commentCountLabel.text intValue];
//    commentCount ++;
//    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentCount];
}

- (void)awakeFromNib {
    [self.commentBtnLarge addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


@end
