//
//  HSShareView.m
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSCreateView.h"

@implementation HSCreateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init {
    self=[super init];
    if (self) {
        NSArray *arrayOfViews;
        if([UIScreen mainScreen].bounds.size.height==568) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSCreatActivityViewController" owner:self options:nil];
        }
        else if([UIScreen mainScreen].bounds.size.height==667) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSCreatActivityViewController@2x" owner:self options:nil];
        } else {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSCreatActivityViewController@3x" owner:self options:nil];
        }
        
        self=arrayOfViews[0];
    }
    
//    UIImageView* blackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
//    blackImageView.backgroundColor=[UIColor blackColor];
//    blackImageView.alpha=0.7;
//    [self insertSubview:blackImageView belowSubview:self.createView];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(txtFieldResign)];
    [self addGestureRecognizer:tap];
    
    //设置圆角
//    self.createView.layer.cornerRadius=10;
//    self.avarlImage.layer.cornerRadius=self.albumBtn.frame.size.width/2;
//    self.avarlImage.clipsToBounds=YES;
////    self.bottomBarImage.layer.cornerRadius=4;
//    self.createView.clipsToBounds=YES;
    return self;
}

#pragma txtFieldResign
- (void) txtFieldResign{
    if([self.activityTitle isFirstResponder]){
        [self.activityTitle resignFirstResponder];
    }
    else if([self.activityDescription isFirstResponder]){
        [self.activityDescription resignFirstResponder];
    }
    else if([self.activityKind isFirstResponder]){
        [self.activityKind resignFirstResponder];
    }
}
@end
