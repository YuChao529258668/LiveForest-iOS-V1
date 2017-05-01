//
//  CollectionViewCell.m
//  testCollectionView
//
//  Created by payne on 15/5/5.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

@synthesize backGroundImage = _backGroundImage;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    NSLog(@"cell frame:%@",NSStringFromCGRect(frame));
    
    if (self) {
        //todo:记录 模块的标签
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:self.label];
        
        //cell的背景图片
        //        self.backgroundView
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_backGroundImage];
    }
    
   

    return self;
}

@end
