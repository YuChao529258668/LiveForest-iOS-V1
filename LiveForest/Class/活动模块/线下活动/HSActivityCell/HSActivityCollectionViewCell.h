//
//  HSActivityCollectionViewCell.h
//  HotSNS
//
//  Created by 微光 on 15/3/31.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HSActivityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray *arraySmall;
@property (nonatomic, strong) NSMutableArray *arrayLarge;

//small
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgSmall;
@property (weak, nonatomic) IBOutlet UILabel *avtivityNameSmall;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeTagSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeSmall;
@property (weak, nonatomic) IBOutlet UILabel *activityJoinCountSmall;
//large
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgLarge;
@property (weak, nonatomic) IBOutlet UILabel *avtivityNameLarge;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLarge;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLarge;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeTagLarge;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLarge;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressTagLarge;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLarge;
@property (weak, nonatomic) IBOutlet UILabel *activityJoinCountLarge;
@property (weak, nonatomic) IBOutlet UIImageView *mapViewLarge;
@property (weak, nonatomic) IBOutlet UIButton *activityChat;  //todo，还没连接其他的xib
@property (weak, nonatomic) IBOutlet UIButton *cancelActivityBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinActivityBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


#pragma mark <设置cell的子视图透明度>
- (void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber;

@property (strong, nonatomic) NSString *activity_id;
@property (strong, nonatomic) NSString *activity_category_id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *sport_id;
@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *activity_lon;//经度
@property (strong, nonatomic) NSString *activity_lat;//纬度
@property (strong, nonatomic) NSString *isOfficial;
@property (strong, nonatomic) NSString *hasAttended;

@property (assign, nonatomic) int joinNumber;
@end
