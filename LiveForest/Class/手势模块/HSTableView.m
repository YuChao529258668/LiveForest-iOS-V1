//
//  HSTableView.m
//  LiveForest
//
//  Created by 余超 on 15/7/22.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSTableView.h"

@implementation HSTableView

- (BOOL)gestureRecognizerShouldBegin:(nonnull UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint v=[pan velocityInView:self];
        
        if (self.contentOffset.y==0 && v.y>0) {
            return NO;//不许上下滚动，开始缩放手势
        }
    }
    return YES;
}

@end
