//
//  HSGroupDetailView.m
//  LiveForest
//
//  Created by 微光 on 15/5/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGroupDetailView.h"

@implementation HSGroupDetailView

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
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailView" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailView@6" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==736){
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailView@6P" owner:self options:nil];
        }
        else {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailView@4" owner:self options:nil];
        }

        self=array[0];
    }
    return self;
}
@end
