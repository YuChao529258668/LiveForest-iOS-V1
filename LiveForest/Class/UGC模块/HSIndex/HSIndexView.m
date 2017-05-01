//
//  HSIndexView.m
//  LiveForest
//
//  Created by 微光 on 15/4/24.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSIndexView.h"

@implementation HSIndexView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self=[super init];
    if (self) {
        NSArray *arrayOfViews;
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSIndexView" owner:self options:nil];
        self=arrayOfViews[0];
        
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}
@end
