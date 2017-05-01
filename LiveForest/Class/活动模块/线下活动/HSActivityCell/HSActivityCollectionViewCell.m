//
//  HSActivityCollectionViewCell.m
//  HotSNS
//
//  Created by 微光 on 15/3/31.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSActivityCollectionViewCell.h"

@implementation HSActivityCollectionViewCell

@synthesize arrayLarge;
@synthesize arraySmall;

//small
@synthesize backgroundImgSmall;
@synthesize avtivityNameSmall;
@synthesize publishTimeSmall;
@synthesize activityDescriptionSmall;
@synthesize activityTimeTagSmall;
@synthesize activityTimeSmall;
@synthesize activityJoinCountSmall;
//large
@synthesize backgroundImgLarge;
@synthesize avtivityNameLarge;
@synthesize publishTimeLarge;
@synthesize activityDescriptionLarge;
@synthesize activityTimeTagLarge;
@synthesize activityTimeLarge;
@synthesize activityAddressLarge;
@synthesize activityAddressTagLarge;
@synthesize activityChat;
@synthesize joinActivityBtn;
@synthesize cancelActivityBtn;
@synthesize activityJoinCountLarge;
@synthesize mapViewLarge;
@synthesize scrollView;

/*
 1.app尺寸，去掉状态栏
 CGRect r = [ UIScreen mainScreen ].applicationFrame;
 r=0，20，320，460
 2.屏幕尺寸
 CGRect rx = [ UIScreen mainScreen ].bounds;
 r=0，0，320，480
 3.状态栏尺寸
 CGRect rect; rect = [[UIApplication sharedApplication] statusBarFrame];
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews;
        if([UIScreen mainScreen].bounds.size.height==568) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSActivityCell" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSActivityCell@2x" owner:self options:nil];
        } else {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSActivityCell@3x" owner:self options:nil];
        }
        
        
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
        [self initArrays];
        
        
        //设置scrollView的contentSize，最下面的是参加活动按钮joinActivityBtn。
        float y=self.joinActivityBtn.frame.origin.y+self.joinActivityBtn.frame.size.height*1.4;
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width,y);
        
        
//        self.activityChat.alpha=0;
//        self.cancelActivityBtn.alpha=0;
        
        [self.joinActivityBtn addTarget:self action:@selector(joinActivityBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelActivityBtn addTarget:self action:@selector(cancelActivityBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.activityChat addTarget:self action:@selector(activityChatBtn) forControlEvents:UIControlEventTouchUpInside];
//
    }
    return self;
}

#pragma mark <初始化子视图数组>
-(void)initArrays {

    arraySmall=[[NSMutableArray alloc]initWithObjects:
                backgroundImgSmall,
                avtivityNameSmall,
                publishTimeSmall,
                activityDescriptionSmall,
                activityTimeTagSmall,
                activityTimeSmall,
                activityJoinCountSmall, nil];
    arrayLarge=[[NSMutableArray alloc]initWithObjects:
                    backgroundImgLarge,
                    avtivityNameLarge,
                    publishTimeLarge,
                    activityDescriptionLarge,
                    activityTimeTagLarge,
                    activityAddressLarge,
                    activityAddressTagLarge,
//                    joinActivityBtn,
                    activityTimeLarge,
                    activityJoinCountLarge,
                    mapViewLarge,
                    scrollView, nil];
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
    
//    NSLog(@"factor = %f",factor);
}

-(void)joinActivityBtnClick {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationJoinActivityBtnClick" object:self];
    NSLog(@"joinActivityBtnClick按钮发通知啦！");
}

-(void)cancelActivityBtnClick {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationCancelActivityBtnClick" object:self];
    NSLog(@"cancelActivityBtnClick按钮发通知啦！");
}
#pragma mark 点击进入 群组按钮
//
-(void)activityChatBtn {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationActivityChatBtn" object:self];
    NSLog(@"activityChatBtn按钮发通知啦！");
}


@end
