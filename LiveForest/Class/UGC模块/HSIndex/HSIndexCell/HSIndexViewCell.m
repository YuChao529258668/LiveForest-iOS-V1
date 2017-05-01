//
//  HSIndexViewCell.m
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSIndexViewCell.h"
#import "HSCommentViewController.h"

#import "Macros.h"

#import "HSIndexCellLargeView.h"
#import "HSIndexCellSmallView.h"


@interface HSIndexViewCell ()
@property(nonatomic, strong) HSCommentViewController *commentVC;
@end

@implementation HSIndexViewCell{
    bool isreported;
}

@synthesize arrayLarge;
@synthesize arraySmall;

//small
@synthesize avataImgBtnSmall;
@synthesize contentImgViewSmall;
@synthesize nameLabelSmall;
@synthesize timeLabelSmall;
@synthesize textLabelSmall;

//large
@synthesize avataImgBtnLarge;
@synthesize contentImgViewLarge;
@synthesize nameLabelLarge;
@synthesize timeLabelLarge;
@synthesize textLabelLarge;
@synthesize praiseBtnLarge;
@synthesize praiseLabelLarge;
@synthesize commentBtnLarge;
@synthesize commentCountLabel;
@synthesize progressView;
@synthesize mapLocationImg;
@synthesize mapLocationLabel;
//评论视图5.25
@synthesize commentView;
//@synthesize commentViewController;

@synthesize shareThird;
//@synthesize indexController;
@synthesize largedImage;
@synthesize blackCellEnlargeImage;
//@synthesize commentViewDelegate;

#pragma mark

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSIndexCell" owner:self options:nil];
        self = arrayOfViews[0];
//        self.bounds = [UIScreen mainScreen].bounds;
        //        [self addSmallView];
        //        [self addLargeView];
        //        [self shiPeiPingMu];

        
        //为了防止用户滑动，只要滑动就退出，todo，换一种方式，通知方式
//        [blackImageView addGestureRecognizer:panCommentBackground];
//        [commentView addGestureRecognizer:panCommentBackground];


        
        [self.praiseBtnLarge addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [self.shareThird addTarget:self action:@selector(sendThirdShare) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapContentImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellContentImage)];
        [self.contentImgViewLarge setUserInteractionEnabled:YES];
        [self.contentImgViewLarge addGestureRecognizer:tapContentImage];
//        self.enlargeImage = NO;
        
        self.largedImage = [[CRPixellatedView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.largedImage.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *taplargedImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellLargedImage)];
//        UITapGestureRecognizer *taplargedImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellLenlargeImageDisappearargedImage)];

        [self.largedImage setUserInteractionEnabled:YES];
        [self.largedImage addGestureRecognizer:taplargedImage];
        UIPanGestureRecognizer *panBlackCellEnlargeCell = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellLargedImage)];
//        UIPanGestureRecognizer *panBlackCellEnlargeCell = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageDisappear)];

        //        为了防止用户滑动，只要滑动就退出，todo，换一种方式，通知方式
        [self.largedImage addGestureRecognizer:panBlackCellEnlargeCell];
        
        //抹黑加载图片的view
        blackCellEnlargeImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        blackCellEnlargeImage.backgroundColor=[UIColor blackColor];
//        blackCellEnlargeImage.alpha=0;
        UITapGestureRecognizer *tapBlackCellEnlargeCell=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeImageDisappear)];
                blackCellEnlargeImage.userInteractionEnabled=YES;
        [blackCellEnlargeImage addGestureRecognizer:tapBlackCellEnlargeCell];
        
        //点击头像，发送通知
        [self.avataImgBtnLarge addTarget:self action:@selector(avataBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        //6.6by q
        self.imgViewTmp = [[UIImageView alloc]init];
        
        //6.20 图片数组
        self.imgHighQualityUrlArray = [[NSMutableArray alloc]init];
        
//        _photoGroupLarge = [[SDPhotoGroup alloc]initWithFrame:contentImgViewLarge.frame];
//        _photoGroupSmall = [[SDPhotoGroup alloc]initWithFrame:contentImgViewSmall.frame];
//        
//        [self addSubview: _photoGroupSmall];
//        [self addSubview: _photoGroupLarge];
        
        
        
        //在头像按钮上覆盖一个白色图片，实现圆角效果
        UIImageView *iv = [[UIImageView alloc]initWithFrame:avataImgBtnSmall.frame];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [iv setImage:[UIImage imageNamed:@"覆盖成圆"]];
        [self addSubview:iv];
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;

        //举报按钮  todo
        isreported = false;
        [self.reportBtn addTarget:self action:@selector(reportBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [self.commentBtnLarge addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setUpTapToScaleLargeBtn];
}
- (void)updateCommentCountLabel {
    int commentCount = [self.commentCountLabel.text intValue];
    commentCount ++;
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentCount];
}

- (void)commentBtnClick:(UIButton *)btn {
    if (!self.commentVC) {
        __weak HSIndexViewCell *weakSelf = self;
        self.commentVC = [[HSCommentViewController alloc]initWithShareID:self.shareID
                                               sendCommentSuccessHandler:^{
            [weakSelf updateCommentCountLabel];
        }];
    }
    [self.commentVC showOrHide];
}

#pragma mark <初始化子视图数组>
- (NSMutableArray *)arraySmall {
    if (!arraySmall) {
        arraySmall=[[NSMutableArray alloc]initWithObjects:
                    avataImgBtnSmall,
                    contentImgViewSmall,
                    nameLabelSmall,
                    timeLabelSmall,
                    textLabelSmall,
                    nil];
    }
    return arraySmall;
}

- (NSMutableArray *)arrayLarge {
    if (!arrayLarge) {
        arrayLarge=[[NSMutableArray alloc]initWithObjects:
                    avataImgBtnLarge,
                    contentImgViewLarge,
                    nameLabelLarge,
                    timeLabelLarge,
                    textLabelLarge,
                    praiseBtnLarge,
                    praiseLabelLarge,
                    commentBtnLarge,
                    commentCountLabel,
                    progressView,
                    shareThird,
                    mapLocationLabel,
                    mapLocationImg,
                    self.reportBtn,
                    self.reportLabel,
                    nil];
    }
    return arrayLarge;
}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {

    for (UIView *view in arraySmall) {
        view.alpha=2-factor;
    }
    for (UIView *view in arrayLarge) {
        view.alpha=factor-1;
    }
    
    
    self.smallView.alpha = 2 - factor;
    self.largeView.alpha = factor - 1;
    
//    if (self.largeView.alpha < 0.2) {
//        if (self.largeView.superview) {
//            [self.largeView removeFromSuperview];
//        }
//    } else {
//        if (self.largeView.superview == nil) {
//            [self addSubview:self.largeView];
//        }
//    }
//    
//    if (self.smallView.alpha < 0.2) {
//        if (self.smallView.superview) {
//            [self.smallView removeFromSuperview];
//        }
//    } else {
//        if (self.smallView.superview == nil) {
//            [self addSubview:self.smallView];
//        }
//    }
}

- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];

    [self setSubviewsAlphaWithFactor:factor];
}

#pragma mark <点赞按钮>
- (void)praiseBtnClick {
    NSDictionary *info = @{@"cell":self};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSIndexCellPraise" object:self userInfo:info];
    NSLog(@"praise按钮发通知啦！");
}


#pragma mark enlargeImageDisappear
- (void)enlargeImageDisappear{
    
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        [self.largedImage removeFromSuperview];
        [self.blackCellEnlargeImage removeFromSuperview];
    }];
}

#pragma mark <第三方>
- (void)sendThirdShare{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSIndexCellThird" object:self];
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

#pragma mark avataBtn 通知
- (void)avataBtn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSIndexCellavataBtn" object:self];
    NSLog(@"avataBtn按钮发通知啦！");
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

#pragma mark - 点击放大模块
- (void)setUpTapToScaleLargeBtn {
    self.tapToScaleLargeBtn = [[UIButton alloc]initWithFrame:self.frame];
//    self.tapToScaleLargeBtn.backgroundColor = [UIColor blueColor];
//    self.tapToScaleLargeBtn.alpha = 0.5;
    [self.tapToScaleLargeBtn addTarget:self action:@selector(tapToScaleLargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.tapToScaleLargeBtn];
    [self.arraySmall addObject:self.tapToScaleLargeBtn];
}
- (void)tapToScaleLargeBtnClick {
    [self.delegate tapToScaleLarge:self];
}



#pragma mark - 优化
- (HSIndexCellSmallView *)smallView {
    if (!_smallView) {
        _smallView = [HSIndexCellSmallView new];
    }
    return _smallView;
}

- (HSIndexCellLargeView *)largeView {
    if (!_largeView) {
        _largeView = [HSIndexCellLargeView new];
    }
    return _largeView;
}

- (void)addSmallView {
    [self addSubview:self.smallView];
}

- (void)addLargeView {
    [self addSubview:self.largeView];
}

- (void)shiPeiPingMu {
    static int width;
    static float factorWidth;
    static float factorHeight;
    static CGAffineTransform transform;
    
    width=[UIScreen mainScreen].bounds.size.width;
    switch (width) {
        case 320:
            factorWidth = 1;
            factorHeight = 1;
            break;
        case 375:
            factorWidth = 1.17;
            factorHeight = 1.174;
            break;
        case 414:
            factorWidth = 1.29;
            factorHeight = 1.296;
            break;
        default:
            factorWidth = 1.17;
            factorHeight = 1.174;
            break;
    }
    transform=CGAffineTransformMakeScale(factorWidth, factorHeight);
    
    CGPoint oldOrigin=self.frame.origin;
    float oldWidth=self.frame.size.width;
    self.transform=transform;
    CGRect newFrame=self.frame;
    newFrame.origin=oldOrigin;
    newFrame.size.width=oldWidth;
    self.frame=newFrame;

    NSLog(@"适配屏幕");
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    [self shiPeiPingMu];
//}
@end
