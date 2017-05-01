//
//  HSActivityView.m
//  LiveForest
//
//  Created by 微光 on 15/4/25.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSActivityView.h"

@implementation HSActivityView

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
//        if([UIScreen mainScreen].bounds.size.height==568) {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSActivityView" owner:self options:nil];
//        } else if([UIScreen mainScreen].bounds.size.height==667) {
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSActivityView@6" owner:self options:nil];
//        } else if([UIScreen mainScreen].bounds.size.height==736){
//            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSActivityView@6P" owner:self options:nil];
//        }
        self=arrayOfViews[0];
    }
    
    self.activityName.font = [UIFont fontWithName:@"Helvetica-Bold" size:26];
    self.activityName.textColor = [UIColor whiteColor];
    self.activityName.shadowColor = [UIColor colorWithWhite:0.3f alpha:0.8f];
    
    self.locationDescription.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.locationDescription.textColor = [UIColor whiteColor];
    self.locationDescription.shadowColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
    
    //屏幕适配
    float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
    float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
    
    self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
    //调整缩放后的位置
    CGRect frame=self.frame;
    frame.origin=CGPointZero;
    self.frame=frame;

    return self;
}

@end
