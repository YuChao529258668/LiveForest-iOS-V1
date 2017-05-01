//
//  HSInviteFriendsView.m
//  LiveForest
//
//  Created by 傲男 on 15/7/8.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSInviteFriendsView.h"
#import "HSMyInviteHistoryViewController.h"

@implementation HSInviteFriendsView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//-(instancetype)init {
//    self=[super init];
//    if (self) {
//        NSArray *array;
//        //        if([UIScreen mainScreen].bounds.size.height==568) {
//        array = [[NSBundle mainBundle] loadNibNamed:@"HSInviteFriendView" owner:self options:nil];
//        //        } else if([UIScreen mainScreen].bounds.size.height==667) {
//        //            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView@2x" owner:self options:nil];
//        //        } else if([UIScreen mainScreen].bounds.size.height==480) {
//        //
//        //            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView@4s" owner:self options:nil];
//        //        }else {
//        //            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView@3x" owner:self options:nil];
//        //        }
//        self=array[0];
//        
//        //屏幕适配
//        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
//        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
//        
//        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
//        //调整缩放后的位置
//        CGRect frame=self.frame;
//        frame.origin=CGPointZero;
//        self.frame=frame;
//        
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        NSArray *array;
        
        array = [[NSBundle mainBundle] loadNibNamed:@"HSInviteFriendView" owner:self options:nil];

        self=array[0];

        //初始化视图
        [self initView];
        
        [self setupCreateYueBanBtn];
        [self setupYueBanDescriptionLabel];
        
//        //屏幕适配
//        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
//        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
//        
//        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
//        //调整缩放后的位置
//        CGRect frame=self.frame;
//        frame.origin=CGPointZero;
//        self.frame=frame;
        
        self.frame = [UIScreen mainScreen].bounds;
        
    }
    return self;
}

- (void)setupCreateYueBanBtn {
    self.clickYueBanBtn = [[UIButton alloc]init];
    UIImage *image = [UIImage imageNamed:@"yueBan_create"];
    [self.clickYueBanBtn setImage:image forState:UIControlStateNormal];
    [self addSubview:self.clickYueBanBtn];
    [self bringSubviewToFront:self.clickYueBanBtn];
}

- (void)setupYueBanDescriptionLabel {
    self.yueBanDescriptionLabel = [[UILabel alloc]init];
    self.yueBanDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.yueBanDescriptionLabel.text = @"发起约伴邀请";
    self.yueBanDescriptionLabel.textColor = [UIColor whiteColor];
    [self.yueBanDescriptionLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self addSubview:self.yueBanDescriptionLabel];
    [self bringSubviewToFront:self.yueBanDescriptionLabel];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    //设置发起约伴按钮
    UIImage *image = self.clickYueBanBtn.currentImage;
    CGRect btnFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    CGPoint btnCenter = CGPointMake(self.center.x, self.frame.size.height * 0.3);
    self.clickYueBanBtn.frame = btnFrame;
    self.clickYueBanBtn.center = btnCenter;
    if ([UIScreen mainScreen].bounds.size.width>320) {
        self.clickYueBanBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }
    
    //设置约伴按钮下面的标签
    CGRect f = self.yueBanDescriptionLabel.frame;
    f.size.width = self.frame.size.width;
    f.size.height = 30;
    f.origin.y = CGRectGetMaxY(self.clickYueBanBtn.frame) +10;
    self.yueBanDescriptionLabel.frame = f;
    
}

- (void) initView{
    
//    //点击我的邀请按钮
//    [self.historyBtn addTarget:self action:@selector(showMyInviteList:) forControlEvents:UIControlEventTouchUpInside];
    
    //shimmer
    _shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
    [self addSubview:_shimmeringView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentLeft;
    
    loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.shadowColor = [UIColor colorWithWhite:0.4f alpha:0.8f];
    loadingLabel.text = NSLocalizedString(@"约伴", nil);
    _shimmeringView.contentView = loadingLabel;
    //        _shimmeringView.shimmeringDirection =
    // Start shimmering.
    _shimmeringView.shimmeringPauseDuration = 0.1;
    _shimmeringView.shimmeringAnimationOpacity = 0.3;
    _shimmeringView.shimmeringSpeed = 40;
    _shimmeringView.shimmeringHighlightLength = 1;
    //        _shimmeringView.shimmeringSpeed = 40;
    _shimmeringView.shimmering = YES;

    
    //背景反射图片
    _reflectedImage.contentMode = UIViewContentModeScaleAspectFill;
    _reflectedImage.clipsToBounds = YES;
    _reflectedImage.transform = CGAffineTransformMakeScale(1.0, -1.0);
    //渐隐
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    CGRect rect = _reflectedImage.bounds;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    gradientReflected.frame = rect;
    gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_reflectedImage.layer insertSublayer:gradientReflected atIndex:0];
}

#pragma mark 点击我的邀请按钮
- (void)showMyInviteList:(UIButton *)btn{
//    self.myInviteHistoryView = [[HSMyInviteHistoryView alloc]init];
    //    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    //    [window insertSubview:self.myInviteHistoryView aboveSubview:self];
    //    [self show:self.myInviteHistoryView];
    static HSMyInviteHistoryViewController *m;
    m = [[HSMyInviteHistoryViewController alloc]init];
    [[UIApplication sharedApplication].keyWindow addSubview:m.view];
}
//- (void)showMyInviteList:(UIButton *)btn{
//    self.myInviteHistoryView = [[HSMyInviteHistoryView alloc]init];
//    //    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
//    //    [window insertSubview:self.myInviteHistoryView aboveSubview:self];
//    //    [self show:self.myInviteHistoryView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.myInviteHistoryView];
//}
- (void)show:(UIView *)view{
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect frame=appWindow.frame;
    frame.origin.y=kScreenHeight;
    view.frame=frame;
    [appWindow insertSubview:view aboveSubview:appWindow.rootViewController.view];
    
    [UIView animateWithDuration:1    animations:^{
        CGRect frame=appWindow.frame;
        frame.origin.y=0;
        view.frame=frame;
    }completion:^(BOOL finished) {
    }];
    
}
@end
