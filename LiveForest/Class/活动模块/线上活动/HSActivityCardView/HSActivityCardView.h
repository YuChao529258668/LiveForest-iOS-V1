//
//  HSActivityCardView.h
//  LiveForest
//
//  Created by 余超 on 15/7/15.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDisplayPicActivity.h"
#import "HSPicActivityInfo.h"
#import "HSShareInfo.h"
#import "HSSuperCell.h"

@interface HSActivityCardView : HSSuperCell<UITableViewDelegate,UITableViewDataSource>
{
//    HSPicActivityInfo *picActivityInfo;
}
@property (strong, nonatomic) UIView *smallCardView;
@property (strong, nonatomic) UIView *largeCardView;

//small
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityNameSmall;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeSmall;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeTagSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityJoinCountSmall;
@property (strong, nonatomic) UIButton *coverBtn;

//large
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//#pragma mark <设置cell的子视图透明度>
//- (void)setSubviewsAlphaWithFactor:(float) factor;
//- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber;

//model
@property (strong, nonatomic) HSPicActivityInfo *picActivityInfo;
@property (strong, nonatomic) NSMutableArray *shareInfoArray;

@end
