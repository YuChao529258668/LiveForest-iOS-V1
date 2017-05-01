//
//  HSIndexViewCell.h
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"
//图片加载
#import <CRPixellatedView.h>

//评论模块
#import "HSCommentView.h"

//图片效果byQ  on 6.20
#import "SDPhotoGroup.h"
#import "HSSuperCell.h"

@class HSIndexCellSmallView;
@class HSIndexCellLargeView;

@protocol HSIndexViewCellDelegate;

@interface HSIndexViewCell : HSSuperCell
{
//    BOOL isPraise;
//    UIImageView *testImageView;
}
@property (nonatomic, strong) NSMutableArray *arraySmall;
@property (nonatomic, strong) NSMutableArray *arrayLarge;

//small
@property (weak, nonatomic) IBOutlet UIButton *avataImgBtnSmall;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgViewSmall;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelSmall;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelSmall;
@property (weak, nonatomic) IBOutlet UILabel *textLabelSmall;
@property (strong, nonatomic) UIButton *tapToScaleLargeBtn;//覆盖在小cell，点击放大cell

//large
@property (weak, nonatomic) IBOutlet UIButton *avataImgBtnLarge;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgViewLarge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *textLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtnLarge;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *commentBtnLarge;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
//地图图标
@property (strong, nonatomic) IBOutlet UIImageView *mapLocationImg;
@property (strong, nonatomic) IBOutlet UILabel *mapLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

//图片处理
//@property (strong, nonatomic) SDPhotoGroup *photoGroupLarge;
//@property (strong, nonatomic) SDPhotoGroup *photoGroupSmall;

//评论视图 5.25
@property (strong, nonatomic) HSCommentView *commentView;

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber ;


#pragma 补充cell中的信息
@property (strong, nonatomic) NSString *shareID;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL praiseJudge;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSURL *imgHighQualityUrl;
@property (strong, nonatomic) NSMutableArray *imgHighQualityUrlArray;
#pragma mark 分享到第三方
@property (strong, nonatomic) IBOutlet UIButton *shareThird;

@property (strong, nonatomic) CRPixellatedView *largedImage;
@property (strong, nonatomic) UIImageView *blackCellEnlargeImage;
//@property (assign, nonatomic) BOOL enlargeImage;
@property (strong, nonatomic) UIImageView *imgViewTmp;

//地理位置
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

//图片九宫格
@property (strong, nonatomic) SDPhotoGroup *photoGroupLarge;
@property (strong, nonatomic) SDPhotoGroup *photoGroupSmall;

@property (strong, nonatomic) IBOutlet UIButton *reportBtn;
@property (strong, nonatomic) IBOutlet UILabel *reportLabel;

@property (weak, nonatomic) id<HSIndexViewCellDelegate> delegate;


@property (strong, nonatomic) HSIndexCellLargeView *largeView;
@property (strong, nonatomic) HSIndexCellSmallView *smallView;

@end



//协议
@protocol HSIndexViewCellDelegate <NSObject>

@required

- (void)commentBtnClickWithShareID:(NSString *)shareID;
- (void)praiseBtnClickWithShareID:(NSString *)shareID;
- (void)shareBtnClickWithShareID:(NSString *)shareID;
- (void)tapToScaleLarge:(HSIndexViewCell *)cell;

@end
