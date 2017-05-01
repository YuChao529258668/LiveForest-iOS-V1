//
//  HSGroupCollectionViewCell.m
//  HotSNS
//
//  Created by 微光 on 15/4/7.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import "HSGroupCollectionViewCell.h"

@implementation HSGroupCollectionViewCell
@synthesize backBtn;
@synthesize imageViewSmall;

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        NSArray *array;
        if([UIScreen mainScreen].bounds.size.height==568) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupCollectionViewCell" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==667) {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupCollectionViewCell@2x" owner:self options:nil];
        } else if([UIScreen mainScreen].bounds.size.height==736){
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupCollectionViewCell@3x" owner:self options:nil];
        }
        else {
            array = [[NSBundle mainBundle] loadNibNamed:@"HSGroupCollectionViewCell@4s" owner:self options:nil];
        }
        self=array[0];
    }
    self.backBtn.alpha=0;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
//    [pan addTarget:self action:@selector(notiTableViewGesture)];
//    [self.tableView addGestureRecognizer:pan];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
    //factor初始值为0.5
//    self.imageViewSmall.alpha=2-factor;
//    self.tableView.alpha=1-factor;
////    self.backBtn.alpha=1-factor;
//    if (factor == 1) {
//        self.tableView.allowsSelection=NO;
//        self.tableView.scrollEnabled=NO;
//        self.tableView.userInteractionEnabled=NO;
////        backBtn.alpha=1;
//       
//    } else {
//        backBtn.alpha=0;
        self.tableView.allowsSelection=YES;
        self.tableView.scrollEnabled=YES;
        self.tableView.userInteractionEnabled=YES;

//    }
}
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
//    float factor=[factorNumber floatValue];
    //factor值为1-2.22222
//    self.imageViewSmall.alpha=2-factor;
//    self.tableView.alpha=factor-1;
//    self.backBtn.alpha=factor-1;
}

#pragma mark <tableview手势控制>
//- (void)notiTableViewGesture{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationHSGroupCellGesture" object:self];
//    NSLog(@"群组cell发通知啦！");
//}

@end
