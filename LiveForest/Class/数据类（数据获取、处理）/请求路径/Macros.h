//
//  Macros.h
//  HotSNS
//
//  Created by Payne on 15-3-28.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#ifndef HotSNS_Macros_h
#define HotSNS_Macros_h

#pragma mark -
#pragma mark UIColor

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue) UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b) UIColorFromRGBA(r,g,b,1.0)

#pragma mark -
#pragma mark Center View

static inline void CenterView(UIView *v, UIView *superV)
{
    CGPoint origin = CGPointMake((superV.frame.size.width - v.frame.size.width)/2,
                                 (superV.frame.size.height - v.frame.size.height)/2);
    
    v.frame = CGRectMake(origin.x, origin.y, v.frame.size.width, v.frame.size.height);
}

static inline void CenterViewX(UIView *v, UIView *superV)
{
    CGPoint origin = CGPointMake((superV.frame.size.width - v.frame.size.width)/2,
                                 v.frame.origin.y);
    
    v.frame = CGRectMake(origin.x, origin.y, v.frame.size.width, v.frame.size.height);
}

#pragma mark -
#pragma mark 提示框

static inline void ShowHud(NSString * infoString,BOOL isSuccess)
{
    __block UIView * bgView            = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor             = [UIColor blackColor];
    bgView.alpha                       = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    __block UIView * whiteView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 50)];
    whiteView.backgroundColor          = [UIColor whiteColor];
    CenterView(whiteView, bgView);
    whiteView.layer.cornerRadius       = 10;
    whiteView.layer.masksToBounds      = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:whiteView];
    
    
    __block UIImageView * blackImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isSuccess == YES?@"common_success_icon.png" :@"common_jinggao_icon.png" ]];
    blackImgView.frame                 = CGRectMake(0,30, 30, 30);
    CenterViewX(blackImgView, whiteView);
    [whiteView addSubview:blackImgView];
    
    __block  UILabel * infoLabel       = [[UILabel alloc]initWithFrame:CGRectMake(0, 10,220, 30)];
    CenterViewX(infoLabel, whiteView);
    infoLabel.textAlignment            = NSTextAlignmentCenter;
    infoLabel.text                     = infoString;
    infoLabel.font                     = [UIFont systemFontOfSize:16];
    infoLabel.textColor                = UIColorFromHex(0x333333);
    [whiteView addSubview:infoLabel];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        bgView.alpha = 0.3;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            bgView.alpha       = 0;
            infoLabel.alpha    = 0;
            blackImgView.alpha = 0;
            whiteView.alpha    = 0;
            bgView.alpha       = 0;
            
        } completion:^(BOOL finished) {
            
            [infoLabel removeFromSuperview];
            [blackImgView removeFromSuperview];
            [whiteView removeFromSuperview];
            [bgView removeFromSuperview];
        }];
    }];
}



#endif
