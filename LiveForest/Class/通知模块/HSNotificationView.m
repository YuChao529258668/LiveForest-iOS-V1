//
//  HSNotificationView.m
//  LiveForest
//
//  Created by 微光 on 15/4/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSNotificationView.h"

@implementation HSNotificationView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews;
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSNotificationView" owner:self options:nil];
        
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 加载nib
        self = arrayOfViews[0];
        
        
        //cell的注册
        [self.tableView registerNib:[UINib nibWithNibName:@"HSNotificationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HSNotificationCell"];
        
        //        用imageview实现不了，手势监听事件bug
        //        self.backGroundView = [[UIImageView alloc]init];
        //        self.backGroundView.frame = CGRectMake(0, 0, 1000, 1000);
        //        self.backGroundView.backgroundColor = [UIColor blackColor];
        //        self.backGroundView.alpha = 0.4;
        //        [self.backGroundView setUserInteractionEnabled:YES];
        //        UIGestureRecognizer *tapBackGroundView = [[UIGestureRecognizer alloc]initWithTarget: self action:@selector(tapToDismiss)];
        //        tapBackGroundView.delegate = self;
        //        [self.backGroundView addGestureRecognizer:tapBackGroundView];
        
        //        [self addSubview:self.backGroundView];
        
        
        //用button可以实现点击监听
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        [_backBtn setBackgroundColor:[UIColor blackColor]];
        _backBtn.alpha = 0.4;
        [self.notiView setUserInteractionEnabled:YES];
        [self insertSubview:self.backBtn belowSubview:self.notiView];
        //点击消失动画
        [_backBtn addTarget:self action:@selector(tapToDismiss) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
        //屏幕适配
        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
        
        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
        CGRect frame=self.frame;
        frame.origin=CGPointZero;
        self.frame=frame;
    }
    
    return self;
}

//#program mark 点击消失 动画
- (void)tapToDismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.1;
        self.notiView.transform=CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

@end
