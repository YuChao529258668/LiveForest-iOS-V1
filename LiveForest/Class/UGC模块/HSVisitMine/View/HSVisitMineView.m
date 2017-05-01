//
//  HSVisitMineView.m
//  LiveForest
//
//  Created by Swift on 15/4/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSVisitMineView.h"

@implementation HSVisitMineView


//@region 为某些属性设置Getter与Setter
@synthesize nickName = _nickName;
@synthesize parentUIVIewController = _parentUIVIewController;



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithParentController:(UIViewController*) parentUIViewController {
    self=[super init];
    if (self) {
        NSArray *array;
        if([UIScreen mainScreen].bounds.size.height==568) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSVisitMineView" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSVisitMineView@2x" owner:self options:nil];
        } else {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSVisitMineView@3x" owner:self options:nil];
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
        
        self.parentUIVIewController = parentUIViewController;
        

    }
    return self;
}



#pragma mark 处理界面手势相关事件
- (void)initGestureHandler{


}

#pragma mark - User Interaction



@end
