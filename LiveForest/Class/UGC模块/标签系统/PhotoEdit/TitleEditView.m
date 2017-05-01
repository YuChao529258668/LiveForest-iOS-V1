//
//  TitleEditView.m
//  nushroom
//
//  Created by yiliu on 15/5/28.
//  Copyright (c) 2015年 nushroom. All rights reserved.
//

#import "TitleEditView.h"
#import "PhotoTitleView.h"
#import "MyPanGestureRecognizer.h"
#import "MyTapGestureRecognizer.h"

@interface TitleEditView (){
    
    NSInteger numPan;
    UIView *tabbarView;
    
}
@end

@implementation TitleEditView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        [self addImageView];
        [self addLabel];
        [self addTabbarView];
        
        
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 450, 100, 50)];
        backBtn.backgroundColor=[UIColor blueColor];
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];

        
    }
    return self;
}
- (void)backBtnClick {
//    UIImageView *iv=[[UIImageView alloc]initWithImage:self.imageEdit];
    
    
    //屏幕截图
    //    UIGraphicsBeginImageContext(self.imageView.frame.size);
//    UIGraphicsBeginImageContext(iv.frame.size);
    
    //绘制图片
    //    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    [iv.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    //平移
//    CGContextRef r=UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(r, self.tagTF.frame.origin.x-self.imageView.frame.origin.x, self.tagTF.frame.origin.y-self.imageView.frame.origin.y);
    
    //绘制标签
//    [tagTF.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //获取截图
//    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContext(_imageView.frame.size);
    [_imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageEdit=screenShotCut;
    _imageView.image=screenShotCut;



}
- (NSMutableDictionary *)panDict{
    if(!_panDict){
        _panDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _panDict;
}

- (NSMutableDictionary *)buttonDict{
    if(!_buttonDict){
        _buttonDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _buttonDict;
}

//添加图片视图
- (void)addImageView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVH, WIDE, HIGH-NAVH-200)];

//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 , 50, 300, 300)];

    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    static UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_imageView addGestureRecognizer:tap];
//    [self addGestureRecognizer:tap];
    [self addSubview:_imageView];
    
//    UIButton *b=[[UIButton alloc]initWithFrame:self.frame];
//    [b addTarget:self action:@selector(tapGesture:) forControlEvents:UIControlEventTouchUpInside];
//    b.backgroundColor=[UIColor blueColor];
//    [self addSubview:b];
    
    NSLog(@"%@",NSStringFromCGRect(self.frame));

}

//添加提示
- (void)addLabel{
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, HIGH-NAVH-48, WIDE, 48)];
    labTitle.text = @"点击图片，添加标签\n点击标签右边的图标可删除标签";
    labTitle.numberOfLines = 2;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:13];
    labTitle.backgroundColor = RGBACOLOR(250, 250, 250, 0.98);
    [self addSubview:labTitle];
}

//添加按钮
- (void)addTabbarView{
    tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, HIGH-NAVH-48, WIDE, 70)];
    tabbarView.backgroundColor = [UIColor clearColor];
    tabbarView.userInteractionEnabled = NO;
    [self addSubview:tabbarView];
    
    UIButton *butTitle = [[UIButton alloc] initWithFrame:CGRectMake((WIDE-150)/4, 0, 50, 50)];
    [butTitle addTarget:self action:@selector(butTitle) forControlEvents:UIControlEventTouchUpInside];
    butTitle.layer.cornerRadius = 25;
    butTitle.layer.masksToBounds = YES;
    [butTitle setBackgroundImage:[UIImage imageNamed:@"b_q"] forState:UIControlStateNormal];
    [tabbarView addSubview:butTitle];
    
    UIButton *butAddress = [[UIButton alloc] initWithFrame:CGRectMake((WIDE-150)/4*2+50, 0, 50, 50)];
    [butAddress addTarget:self action:@selector(butAddress) forControlEvents:UIControlEventTouchUpInside];
    butAddress.layer.cornerRadius = 25;
    butAddress.layer.masksToBounds = YES;
    [butAddress setBackgroundImage:[UIImage imageNamed:@"d_w"] forState:UIControlStateNormal];
    [tabbarView addSubview:butAddress];
    
    UIButton *butFigure = [[UIButton alloc] initWithFrame:CGRectMake((WIDE-150)/4*3+100, 0, 50, 50)];
    [butFigure addTarget:self action:@selector(butFigure) forControlEvents:UIControlEventTouchUpInside];
    butFigure.layer.cornerRadius = 25;
    butFigure.layer.masksToBounds = YES;
    [butFigure setBackgroundImage:[UIImage imageNamed:@"r_w"] forState:UIControlStateNormal];
    [tabbarView addSubview:butFigure];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake((WIDE-150)/4, 50, 50, 20)];
    labTitle.backgroundColor = RGBACOLOR(250, 250, 250, 0.98);
    labTitle.font = [UIFont systemFontOfSize:15];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.text = @"标签";
    [tabbarView addSubview:labTitle];
    
    UILabel *labAddress = [[UILabel alloc] initWithFrame:CGRectMake((WIDE-150)/4*2+50, 50, 50, 20)];
    labAddress.backgroundColor = RGBACOLOR(250, 250, 250, 0.98);
    labAddress.font = [UIFont systemFontOfSize:15];
    labAddress.textAlignment = NSTextAlignmentCenter;
    labAddress.text = @"地点";
    [tabbarView addSubview:labAddress];
    
    UILabel *labFigure = [[UILabel alloc] initWithFrame:CGRectMake((WIDE-150)/4*3+100, 50, 50, 20)];
    labFigure.backgroundColor = RGBACOLOR(250, 250, 250, 0.98);
    labFigure.font = [UIFont systemFontOfSize:15];
    labFigure.textAlignment = NSTextAlignmentCenter;
    labFigure.text = @"人物";
    [tabbarView addSubview:labFigure];
    
    [self sendSubviewToBack:tabbarView];
}

- (void)setImageEdit:(UIImage *)imageEdit{
//    
//    float bil;
//    float wid;
//    float hig;
//    
//    if(imageEdit.size.width > imageEdit.size.height){
//        
//        bil = WIDE/imageEdit.size.width;
//        wid = WIDE;
//        hig = imageEdit.size.height*bil;
//        
//    }else if(imageEdit.size.width < imageEdit.size.height){
//        
//        bil = WIDE/imageEdit.size.width;
//        if(bil*imageEdit.size.height > self.frame.size.height-120){
//            bil = (self.frame.size.height-120)/imageEdit.size.height;
//            wid = imageEdit.size.width*bil;
//            hig = self.frame.size.height-120;
//        }else{
//            wid = WIDE;
//            hig = bil*(self.frame.size.height-120);
//        }
//        
//    }else{
//        wid = WIDE;
//        hig = WIDE;
//    }
//    
//    _imageEdit = imageEdit;
//    _imageView.image = imageEdit;
//    _imageView.frame = CGRectMake(0, 0, wid, hig);
//    _imageView.center = CGPointMake(WIDE/2, (self.frame.size.height-120)/2);
    
    _imageEdit = imageEdit;
    _imageView.image=_imageEdit;

}

//单击手势
- (void)tapGesture:(UITapGestureRecognizer *)tap{
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.5];
    //动画的内容
    if(tabbarView.frame.origin.y == (HIGH-NAVH-48)){
        tabbarView.userInteractionEnabled = YES;
        tabbarView.frame = CGRectMake(0, HIGH-NAVH-118, WIDE, 70);
    }else{
        tabbarView.userInteractionEnabled = NO;
        tabbarView.frame = CGRectMake(0, HIGH-NAVH-48, WIDE, 70);
    }
    //动画结束
    [UIView commitAnimations];
}

//添加标签
- (void)butTitle{
    [self addTitleView:@"标签"];
}

//添加地点
- (void)butAddress{
    [self addTitleView:@"地点"];
}

//添加人物
- (void)butFigure{
    [self addTitleView:@"人物"];
}

#pragma mark 添加标签
- (void)addTitleView:(NSString *)type{
    PhotoTitleView *photo = [[PhotoTitleView alloc] initType:type];
    photo.backgroundColor = [UIColor clearColor];
    photo.tag = numPan;
    photo.frame = CGRectMake(100, 100, 130, 35);
    [_imageView addSubview:photo];
    
    UIButton *butClane = [[UIButton alloc] initWithFrame:CGRectMake(113, 0, 20, 20)];
    [butClane addTarget:self action:@selector(butClane:) forControlEvents:UIControlEventTouchUpInside];
    [butClane setBackgroundImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
    butClane.hidden = YES;
    [photo addSubview:butClane];
    
    MyPanGestureRecognizer *pan = [[MyPanGestureRecognizer alloc] initWithTarget:self action:@selector(mypanGesture:)];
    pan.tag = numPan;
    [photo addGestureRecognizer:pan];
    
    MyTapGestureRecognizer *tap = [[MyTapGestureRecognizer alloc] initWithTarget:self action:@selector(mytapGesture:)];
    tap.tag = numPan;
    [photo addGestureRecognizer:tap];
    
    [self.panDict setObject:photo forKey:[NSString stringWithFormat:@"%tu",numPan]];
    [self.buttonDict setObject:butClane forKey:[NSString stringWithFormat:@"%tu",numPan]];
    
    numPan++;
}

//删除标签
- (void)butClane:(UIButton *)but{
    PhotoTitleView *photo = [_panDict objectForKey:[NSString stringWithFormat:@"%tu",but.tag]];
    [photo removeFromSuperview];
    [_panDict removeObjectForKey:[NSString stringWithFormat:@"%tu",but.tag]];
    [_buttonDict removeObjectForKey:[NSString stringWithFormat:@"%tu",but.tag]];
}

#pragma -mark 点击手势
- (void)mytapGesture:(MyTapGestureRecognizer *)tap{
    UIButton *butClane = [_buttonDict objectForKey:[NSString stringWithFormat:@"%tu",tap.tag]];
    if(butClane.hidden){
        butClane.hidden = NO;
    }else{
        butClane.hidden = YES;
    }
}

#pragma -mark 拖动手势
- (void)mypanGesture:(MyPanGestureRecognizer *)pan{
    
    PhotoTitleView *photo = [_panDict objectForKey:[NSString stringWithFormat:@"%tu",pan.tag]];
    CGPoint point = [pan translationInView:photo];
    photo.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:photo];
    
}

@end
