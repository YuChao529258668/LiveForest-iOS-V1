//
//  HSIndexCellSmallView.m
//  LiveForest
//
//  Created by 余超 on 15/11/4.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSIndexCellSmallView.h"

@implementation HSIndexCellSmallView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HSIndexCellSmallView" owner:nil options:nil];
        self = array[0];
    }
    return self;
}


@end
