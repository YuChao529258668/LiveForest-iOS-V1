//
//  HSGroupDetailCollectionViewCell.m
//  LiveForest
//
//  Created by 微光 on 15/5/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGroupDetailCollectionViewCell.h"

@implementation HSGroupDetailCollectionViewCell
//@synthesize contentImage;

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        NSArray *array;
        if([UIScreen mainScreen].bounds.size.height==568) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailCollectionViewCell" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailCollectionViewCell@6" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==736){
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailCollectionViewCell@6P" owner:self options:nil];
        }
        else {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupDetailCollectionViewCell@4" owner:self options:nil];
        }
        
        self=array[0];
    }
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
    //    [pan addTarget:self action:@selector(notiTableViewGesture)];
    //    [self.tableView addGestureRecognizer:pan];
//    self.contentImage = [[UIImageView alloc]init];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
    //factor初始值为0.5
//    self.contentImage.alpha=2-factor;
//    self.groupNameLabel.alpha = 2- factor;
//    self.beginChat.alpha = factor - 1;
//    self.tableView.alpha=1-factor;
    //    self.backBtn.alpha=1-factor;
    //    if (factor==1) {
    //        backBtn.alpha=1;
    //        self.tableView.allowsSelection=YES;
    //        self.tableView.scrollEnabled=YES;
    //        self.tableView.userInteractionEnabled=YES;
    //    } else {
    //        backBtn.alpha=0;
    //        self.tableView.allowsSelection=NO;
    //        self.tableView.scrollEnabled=NO;
    //        self.tableView.userInteractionEnabled=NO;
    //
    //    }
}
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];
    //factor值为1-2.22222
//    self.contentImage.alpha=2-factor;
//    self.groupNameLabel.alpha = 2- factor;
//    self.beginChat.alpha = factor - 1;
//    self.tableView.alpha=factor-1;
    //    self.backBtn.alpha=factor
}

@end
