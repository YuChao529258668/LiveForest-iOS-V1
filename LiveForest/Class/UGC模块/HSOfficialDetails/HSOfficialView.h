//
//  HSOfficialView.h
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommentView.h"
#import "SingletonForRootViewCtrl.h"


@interface HSOfficialView : UIView{
    BOOL isPraise;
}
@property (weak, nonatomic) IBOutlet UIButton *avataImgBtnLarge;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgViewLarge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelLarge;
@property (weak, nonatomic) IBOutlet UILabel *textLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtnLarge;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabelLarge;
@property (weak, nonatomic) IBOutlet UIButton *commentBtnLarge;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

//添加评论
@property (weak, nonatomic) IBOutlet UIView *addCommentView;
@property (weak, nonatomic) IBOutlet UIImageView *addCommentViewAvartar;
@property (weak, nonatomic) IBOutlet UITextView *addCommentViewTextView;
@property (weak, nonatomic) IBOutlet UIButton *addCommentViewSmileBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCommentViewAtBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCommentViewSendBtn;

@property (strong,nonatomic) UIImageView *blackImageView;//抹黑主屏幕

//分享 到第三方
@property (strong, nonatomic) IBOutlet UIButton *shareThird;

@property (assign, nonatomic) BOOL praiseJudge;

@property (strong, nonatomic) HSCommentView *commentView;

@property (strong, nonatomic) NSString *shareID;//当前活动的shareID

@property (strong, nonatomic) NSMutableArray *contentImgArray;

@property (strong, nonatomic) IBOutlet UIImageView *mapLocationImg;
@property (strong, nonatomic) IBOutlet UILabel *mapLocationLabel;

@property (strong, nonatomic) IBOutlet UIButton *reportBtn;
@property (strong, nonatomic) IBOutlet UILabel *commentCount;

@end
