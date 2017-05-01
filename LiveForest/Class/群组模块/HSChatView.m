//
//  HSChatView.m
//  LiveForest
//
//  Created by 微光 on 15/4/25.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSChatView.h"

@implementation HSChatView

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
            array = [[NSBundle mainBundle] loadNibNamed:@"HSChatView" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSChatView@6" owner:self options:nil];
        } else {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSChatView@6P" owner:self options:nil];
        }
        self=array[0];
    }
    return self;
}
@end
