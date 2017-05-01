//
//  HSRootCollectionViewCell.m
//  LiveForest
//
//  Created by Swift on 15/4/28.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSRootCollectionViewCell.h"

@implementation HSRootCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
    
}
@end
