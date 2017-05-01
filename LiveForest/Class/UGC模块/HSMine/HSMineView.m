//
//  HSMineView.m
//  LiveForest
//
//  Created by 微光 on 15/4/14.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMineView.h"

@implementation HSMineView
@synthesize backBtn;

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
        NSArray *array;
        if([UIScreen mainScreen].bounds.size.height==568) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView@2x" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==480) {
            
            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView@4s" owner:self options:nil];
        }else {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSMineView@3x" owner:self options:nil];
        }
        self=array[0];
        
//        //屏幕适配
//        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
//        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
//        
//        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
//        //调整缩放后的位置
//        CGRect frame=self.frame;
//        frame.origin=CGPointZero;
//        self.frame=frame;
        
    }
    return self;
}
@end
