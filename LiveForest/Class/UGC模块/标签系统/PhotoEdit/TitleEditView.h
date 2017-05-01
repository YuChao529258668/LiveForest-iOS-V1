//
//  TitleEditView.h
//  nushroom
//
//  Created by yiliu on 15/5/28.
//  Copyright (c) 2015年 nushroom. All rights reserved.
//


#define NAVH 80        //导航栏高度
#define TABBAR 49      //选项卡高度
#define WIDE [[UIScreen mainScreen] bounds].size.width       //屏幕宽
#define HIGH [[UIScreen mainScreen] bounds].size.height      //屏幕高
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]//自定义颜色


//添加标签

#import <UIKit/UIKit.h>

@interface TitleEditView : UIView

@property (nonatomic,strong) UIImage      *imageEdit;
@property (nonatomic,strong) UIImageView  *imageView;

- (void)setImageEdit:(UIImage *)imageEdit;

@property (nonatomic,strong) NSMutableDictionary *buttonDict;
@property (nonatomic,strong) NSMutableDictionary *panDict;

@end
