//
//  HSGroupCollectionViewCell.h
//  HotSNS
//
//  Created by 微光 on 15/4/7.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGroupCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSmall; //todo (其它三套需要改动)

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber;
@end
