//
//  HSVisitMineCell.h
//  LiveForest
//
//  Created by Swift on 15/4/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommentView.h"
@protocol HSVisitMineCellDelegate;

@interface HSVisitMineCell : UICollectionViewCell
{
    BOOL isPraise;
}

@property (nonatomic, strong) NSMutableArray *arraySmall;
@property (nonatomic, strong) NSMutableArray *arrayLarge;

//small
@property (weak, nonatomic) IBOutlet UIImageView *contentImgViewSmall;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelSmall;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelSmall;
@property (weak, nonatomic) IBOutlet UILabel *textLabelSmall;

//large
@property (weak, nonatomic) IBOutlet UIImageView *contentImgViewLarge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *textLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtnLarge;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *commentBtnLarge;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *mapLocationImg;
@property (strong, nonatomic) IBOutlet UILabel *mapLocationLabel;



//添加评论
@property (weak, nonatomic) IBOutlet UIView *addCommentView;
@property (weak, nonatomic) IBOutlet UIImageView *addCommentViewAvartar;
@property (weak, nonatomic) IBOutlet UITextView *addCommentViewTextView;
@property (weak, nonatomic) IBOutlet UIButton *addCommentViewSmileBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCommentViewAtBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCommentViewSendBtn;
@property (strong,nonatomic) UIImageView *blackImageView;//抹黑主屏幕

#pragma mark <设置cell的子视图透明度>
- (void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber ;

@property (strong, nonatomic) IBOutlet UIButton *shareThird;

#pragma 补充cell中的信息
@property (strong, nonatomic) NSString *shareID;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL praiseJudge;
@property (strong, nonatomic) NSString *imgUrl;


#pragma mark 评论模块
@property (strong, nonatomic) HSCommentView *commentView;


@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UIButton *reportBtn;
@property (strong, nonatomic) IBOutlet UILabel *reportLabel;

@property (weak, nonatomic) id<HSVisitMineCellDelegate> delegate;
@end




@protocol HSVisitMineCellDelegate <NSObject>

@required

- (void)commentBtnClickWithShareID:(NSString *)shareID;
- (void)praiseBtnClickWithShareID:(NSString *)shareID;
- (void)shareBtnClickWithShareID:(NSString *)shareID;

@end
