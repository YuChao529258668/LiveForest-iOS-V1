//
//  HSIndexCellLargeView.h
//  LiveForest
//
//  Created by 余超 on 15/11/4.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSIndexCellLargeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *contentImgViewLarge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *textLabelLarge;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtnLarge;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *commentBtnLarge;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareThird;

//地图图标
@property (weak, nonatomic) IBOutlet UILabel *mapLocationLabel;
//举报
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;


@end
