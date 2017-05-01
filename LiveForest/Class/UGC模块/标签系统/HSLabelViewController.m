//
//  HSLabelViewController.m
//  LiveForest
//
//  Created by Swift on 15/6/15.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSLabelViewController.h"
#import "PhotoTitleView.h"
#import "MyPanGestureRecognizer.h"
#import "MyTapGestureRecognizer.h"
#import "HSLabelView.h"
#import "AppDelegate.h"

@interface HSLabelViewController ()
{
    NSInteger numPan;

}
@property (nonatomic,strong) NSMutableDictionary *buttonDict;
@property (nonatomic,strong) NSMutableDictionary *panDict;

@property (nonatomic,strong) NSMutableArray *labelArray;
@property (nonatomic,strong) NSMutableArray *cancelBtnArray;

@property (strong, nonatomic) HSLabelView *labelView;
@property (nonatomic) BOOL isCompleteBtnClick;
@end

@implementation HSLabelViewController
@synthesize imageView;
@synthesize labelView;
@synthesize image;
@synthesize labelArray;
@synthesize cancelBtnArray;
@synthesize isCompleteBtnClick;

- (instancetype)init {
    self=[super init];
    
    labelArray = [[NSMutableArray alloc]init];
    cancelBtnArray = [[NSMutableArray alloc]init];
    
    [self initHSLabelView];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    labelView.imageView.image=image;
    
//    self.view.backgroundColor=[UIColor redColor];
//    labelView.imageView.backgroundColor=[UIColor blueColor];
    UIImageView *iv=[[UIImageView alloc]initWithImage:image];
    CGRect ivFrame=iv.frame;
    CGRect imageViewFrame=labelView.imageView.frame;
    float factor=0;
    if (ivFrame.size.height>ivFrame.size.width) {
        factor=imageViewFrame.size.height/ivFrame.size.height;
    } else {
        factor=imageViewFrame.size.width/ivFrame.size.width;
    }
    CGPoint oldCenterPonit=labelView.imageView.center;
    CGRect newFrame=labelView.imageView.frame;
    newFrame.size.width=factor * ivFrame.size.width;
    newFrame.size.height=factor * ivFrame.size.height;
    labelView.imageView.frame=newFrame;
    labelView.imageView.center=oldCenterPonit;

}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBarHidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)initHSLabelView {
    labelView = [[HSLabelView alloc]init];
//    [self.view addSubview:labelView];//会报异常，self.view为nil？？？
    self.view=labelView;
    
    [labelView.labelBtn addTarget:self action:@selector(labelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [labelView.peopleBtn addTarget:self action:@selector(peopleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [labelView.addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [labelView.okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [labelView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];

//    labelView.imageView.image=image;
    imageView = labelView.imageView;
    
    UITapGestureRecognizer *tapToCloseKB=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKB)];
    [labelView addGestureRecognizer:tapToCloseKB];

}
- (void)closeKB {
    for (PhotoTitleView *view in labelArray) {
        [view.textView resignFirstResponder];
    }
}
- (void)okBtnClick {
    for (UIButton *btn in cancelBtnArray) {
        btn.hidden=YES;
    }
    
    UIImage *imageWithLabels=[self getScreenShotCut];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.imageWithLabels=imageWithLabels;

    UIImageWriteToSavedPhotosAlbum(imageWithLabels, nil, nil, nil);
    
    TuSDKPFEditMultipleController *tc=(TuSDKPFEditMultipleController *)self.navigationItem.rightBarButtonItem.target;
    [tc onImageCompleteAtion];

}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)getScreenShotCut {
    //高清屏幕截图
//    UIGraphicsBeginImageContext(imageView.frame.size);
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0.0);

    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotCut=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShotCut;
}
#pragma mark 添加标签
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

//添加普通标签
- (void)labelBtnClick {
    [self addTitleView:@"标签"];
}

//添加地点标签
- (void)addressBtnClick {
    [self addTitleView:@"地点"];
}

//添加人物标签
- (void)peopleBtnClick {
    [self addTitleView:@"人物"];
}

//添加标签
- (void)addTitleView:(NSString *)type{
    PhotoTitleView *photo = [[PhotoTitleView alloc] initType:type];
    photo.backgroundColor = [UIColor clearColor];
//    photo.backgroundColor = [UIColor redColor];

    photo.tag = numPan;
    photo.frame = CGRectMake(100, 100, 130, 35);
    photo.center=CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
//    photo.frame = CGRectMake(imageView.frame.size.width/2, imageView.frame.size.height/2, 200, 35);

    [imageView addSubview:photo];
    
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
    
    butClane.tag=numPan;
    numPan++;
    
    [labelArray addObject:photo];
    [cancelBtnArray addObject:butClane];
    
}

//删除标签
- (void)butClane:(UIButton *)but{
    PhotoTitleView *photo = [_panDict objectForKey:[NSString stringWithFormat:@"%tu",but.tag]];
    NSLog(@"%ld",but.tag);
    [photo removeFromSuperview];
    [_panDict removeObjectForKey:[NSString stringWithFormat:@"%tu",but.tag]];
    [_buttonDict removeObjectForKey:[NSString stringWithFormat:@"%tu",but.tag]];
    
    [labelArray removeObject:photo];
    [cancelBtnArray removeObject:but];
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
    
    
    
    //防止移除边界
    CGRect labelFrame=photo.frame;
    CGRect imageViewFrame=imageView.frame;
    
    if (labelFrame.origin.y<0) {
        labelFrame.origin.y=0;
        photo.frame=labelFrame;
    }
    if (labelFrame.origin.y+labelFrame.size.height>imageViewFrame.size.height) {
        labelFrame.origin.y=imageViewFrame.size.height-labelFrame.size.height;
        photo.frame=labelFrame;
    }
    
    if (labelFrame.origin.x<0) {
        labelFrame.origin.x=0;
        photo.frame=labelFrame;
    }
    if (labelFrame.origin.x+labelFrame.size.width>imageViewFrame.size.width) {
        labelFrame.origin.x=imageViewFrame.size.width-labelFrame.size.width;
        photo.frame=labelFrame;
    }

    
//    NSLog(@"%f",labelFrame.origin.y);
//    NSLog(@"%f",imageViewFrame.size.height);

}

#pragma mark 屏幕截图
- (void)addTargetToCompleteBtn {
}
@end
