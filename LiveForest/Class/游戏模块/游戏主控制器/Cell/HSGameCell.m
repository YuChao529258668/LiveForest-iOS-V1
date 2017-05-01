//
//  HSGameCell.m
//  LiveForest
//
//  Created by 余超 on 15/9/10.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSGameCell.h"

@implementation HSGameCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"HSGameCell.h awakeFromNib");
}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
//    for (UIView *view in arraySmall) {
//        view.alpha=2-factor;
//    }
//    for (UIView *view in arrayLarge) {
//        view.alpha=factor-1;
//    }
}

- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
//    float factor=[factorNumber floatValue];
//    for (UIView *view in arraySmall) {
//        view.alpha=2-factor;
//    }
//    for (UIView *view in arrayLarge) {
//        view.alpha=factor-1;
//    }
}
@end
