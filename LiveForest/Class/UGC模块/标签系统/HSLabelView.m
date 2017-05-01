//
//  HSLabelView.m
//  LiveForest
//
//  Created by Swift on 15/6/16.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSLabelView.h"

@implementation HSLabelView
@synthesize imageView;
@synthesize okBtn;
@synthesize backBtn;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init {
    if (self=[super init]) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HSLabelView" owner:nil options:nil];
        self = array[0];
        
        float factor=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
        self.transform = CGAffineTransformMakeScale(factor, factor);
        
        imageView.userInteractionEnabled = YES;
    }
    return self;
}

@end
