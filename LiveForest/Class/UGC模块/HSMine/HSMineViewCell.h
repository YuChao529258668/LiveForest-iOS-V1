//
//  HSMineViewCell.h
//  
//
//  Created by 余超 on 15/4/4.
//
//

#import <UIKit/UIKit.h>
#import "HSConstLayout.h"

//图片加载
#import <CRPixellatedView.h>

#import "HSCommentView.h"

@interface HSMineViewCell : UICollectionViewCell
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
@property (strong, nonatomic) IBOutlet UIImageView *mapLocationBtn;
@property (strong, nonatomic) IBOutlet UILabel *mapLocationLabel;

//添加评论
//@property (weak, nonatomic) IBOutlet UIView *addCommentView;
//@property (weak, nonatomic) IBOutlet UIImageView *addCommentViewAvartar;
@property (strong, nonatomic) UITextView *addCommentViewTextView;
//@property (weak, nonatomic) IBOutlet UIButton *addCommentViewSmileBtn;
//@property (weak, nonatomic) IBOutlet UIButton *addCommentViewAtBtn;
@property (strong, nonatomic) UIButton *addCommentViewSendBtn;
//@property (strong,nonatomic) UIImageView *blackImageView;//抹黑主屏幕

//评论视图5.13
@property (strong,nonatomic) HSCommentView *commentView;

#pragma mark <添加评论视图的消失动画>
-(void)addCommentViewDisappearWithAnimation;

#pragma 补充cell中的信息
@property (strong, nonatomic) NSString *shareID;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL praiseJudge;
@property (strong, nonatomic) NSString *imgUrl;

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber;

@property (strong, nonatomic) IBOutlet UIButton *shareThird;

@property (strong, nonatomic) CRPixellatedView *largedImage;
@property (strong, nonatomic) UIImageView *blackCellEnlargeImage;
//@property (assign, nonatomic) BOOL enlargeImage;

//删除按钮ByQiang on 6.23
@property (strong, nonatomic) IBOutlet UIButton *deleteShareBtn;
@property (strong, nonatomic) IBOutlet UILabel *commentCount;


@end
