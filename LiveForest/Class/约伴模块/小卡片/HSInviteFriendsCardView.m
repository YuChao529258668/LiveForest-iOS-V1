//
//  HSInviteFriendsCardView.m
//  LiveForest
//
//  Created by 余超 on 15/8/4.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSInviteFriendsCardView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "HSVisitMineController.h"


#import "HSMyMyYueBanDetailListView.h"
//#import "HSYueBanListTableViewController.h"

#import "HSRecordTool.h"


@interface HSInviteFriendsCardView()
//@property(nonatomic, strong) HSYueBanListTableViewController *detailVC;
//@property(nonatomic, strong)HSMyMyYueBanDetailListView *detailView;
@property(nonatomic, strong) HSYueBanDetailViewController *yueBanDetailViewController;
@property (nonatomic, strong)NSMutableArray *smallViewArray;
@end


@implementation HSInviteFriendsCardView
@synthesize requestDataCtrl;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib {
    [super awakeFromNib];
    
//    HSMyMyYueBanDetailListView *detailView = [[HSMyMyYueBanDetailListView alloc]init];
//    [self addSubview:detailView];
    
//    [self addSubview:self.detailVC.view];
    
//    UIView
    self.smallViewArray = [[NSMutableArray alloc]initWithArray:self.subviews];
    
    
    
    [self.avatarBtn addTarget:self action:@selector(avatarBtnClick:) forControlEvents:UIControlEventTouchUpInside];

//    self.avatarBtn.imageView.layer.cornerRadius = self.avatarBtn.imageView.bounds.size.width/2;
//    self.avatarBtn.imageView.clipsToBounds = YES;
//    [self setNeedsLayout];
//    [self performSelector:@selector(circle) withObject:nil afterDelay:0.1];
//    [self circle];
    
    [self.agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.refuseBtn addTarget:self action:@selector(refuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //语音播放
    [self.voiceBtn addTarget:self action:@selector(voiceInfoBtnPress:) forControlEvents:UIControlEventTouchUpInside];

    
}
//
//- (void)circle {
////    float w = ([UIScreen mainScreen].bounds.size.width - 320)/2+self.avatarBtn.frame.size.width;
//    float w = [UIScreen mainScreen].bounds.size.width/320 * self.avatarBtn.bounds.size.width;
//    NSLog(@"%f",w);
//    self.avatarBtn.imageView.layer.cornerRadius = w/2;
//    self.avatarBtn.imageView.clipsToBounds = YES;
////    [self setNeedsLayout];
////    [self setNeedsDisplay];
//}

//- (void)createDetailView {
//    
//    NSLog(@"%@",self.inviteFriendsCard.yueban_id);
//    NSLog(@"%@",self.inviteFriendsCard);
//    self.detailView = [[HSMyMyYueBanDetailListView alloc]initWithYueBanID:self.inviteFriendsCard.yueban_id];
//    self.detailView.backBtn.hidden = YES;
//    [self addSubview:self.detailView];
//    self.detailView.alpha = 0;
//    self.detailView.transform = CGAffineTransformMakeScale(1, 1);
//}

- (void)createDetailViewController {
//    NSLog(@"%@",self.inviteFriendsCard.yueban_id);
    self.yueBanDetailViewController = [[HSYueBanDetailViewController alloc]initWithYueBanID:self.inviteFriendsCard.yueban_id];
    
    self.yueBanDetailViewController.delegate = self;
    self.yueBanDetailViewController.isDeal = NO;
    
    self.yueBanDetailViewController.backBtn.hidden = YES;
//    self.yueBanDetailViewController.view.backgroundColor = [UIColor redColor];
    [self.yueBanDetailViewController.backBtn removeFromSuperview];
    self.yueBanDetailViewController.backBtn.alpha = 0;
    self.yueBanDetailViewController.backBtn = nil;
    
//    UILabel *label = [[UILabel alloc]initWithFrame:self.yueBanDetailViewController.backBtn.frame];
//    label.backgroundColor = self.yueBanDetailViewController.view.backgroundColor;
//    [self.yueBanDetailViewController.view addSubview:label];
    
    [self addSubview:self.yueBanDetailViewController.view];
    self.yueBanDetailViewController.view.alpha = 0;
    self.yueBanDetailViewController.view.frame = [UIScreen mainScreen].bounds;
    //    self.yueBanDetailViewController.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    self.yueBanDetailViewController.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
//    self.yueBanDetailViewController.tableViewWidth.constant = [UIScreen mainScreen].bounds.size.width;
//    for (UIView *v in self.yueBanDetailViewController.view.subviews) {
//        [v removeConstraints:v.constraints];
//    }
//    [self.yueBanDetailViewController.view removeConstraints:self.yueBanDetailViewController.view.constraints];
//    for (NSLayoutConstraint *c in self.yueBanDetailViewController.view.constraints) {
    
//    }

    NSLog(@"%@",NSStringFromCGRect(self.yueBanDetailViewController.view.frame));
    NSLog(@"%@",NSStringFromCGRect(self.frame));

//    [self.smallViewArray addObject:self.yueBanDetailViewController.view];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews;
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSInviteFriendsCardView" owner:self options:nil];
        self=arrayOfViews[0];
    }
    
    
    return self;
}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
//    smallCardView.alpha=2-factor;
//    largeCardView.alpha=factor-1;
}
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];

    for (UIView *iv in self.smallViewArray) {
        iv.alpha = 2 - factor;
    }
//    self.detailView.alpha=factor-1;
    self.yueBanDetailViewController.view.alpha=factor-1;
    self.yueBanDetailViewController.backBtn.alpha = 0;
    
    if (self.inviteFriendsCard.yueban_text_info) {
        self.voiceBtn.alpha = 0;
        self.contentTextView.alpha = 2 - factor;
    } else {
        self.contentTextView.alpha = 0;
        self.voiceBtn.alpha = 2 - factor;
    }
}

//设置小卡片数据
- (void)setInviteFriendsCard:(HSInviteFriendsCard *)inviteFriendsCard {
    _inviteFriendsCard = inviteFriendsCard;
    
    NSURL *avatarUrl = [NSURL URLWithString:self.inviteFriendsCard.user_logo_img_path];
    if (!avatarUrl) {
        NSString *avatarUrlString = [self.inviteFriendsCard.user_logo_img_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        avatarUrl = [NSURL URLWithString:avatarUrlString];
    }

    [self.avatarBtn sd_setImageWithURL:avatarUrl forState:UIControlStateNormal];
    self.nameLabel.text = self.inviteFriendsCard.user_nickname;
    self.titleLabel.text = self.inviteFriendsCard.yueban_title;
    self.contentTextView.text = self.inviteFriendsCard.yueban_text_info;
    
    
    
    if (self.inviteFriendsCard.yueban_text_info) {
        self.voiceBtn.alpha = 0;
        self.contentTextView.alpha = 1;
    } else {
        self.voiceBtn.alpha = 1;
        self.contentTextView.alpha = 0;
    }
    
    
    if (_inviteFriendsCard) {
        [self createDetailViewController];
        
//        self.avatarBtn.imageView.layer.cornerRadius = self.avatarBtn.imageView.bounds.size.width/2;
//        self.avatarBtn.imageView.clipsToBounds = YES;
//        [self.avatarBtn setNeedsDisplay];
//        [self setNeedsDisplay];
    }
}

#pragma mark 按钮点击事件
- (void)avatarBtnClick:(UIButton *)btn {
    static HSVisitMineController *vmvc;
    vmvc = [[HSVisitMineController alloc]init];
    [vmvc requestPersonalInfoWithUserID:self.inviteFriendsCard.user_id];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vmvc animated:YES completion:nil];
}
- (void)agreeBtnClick:(UIButton *)btn {
    [self.ybDelegate agreeBtnClickWithYueBanDataModel:self.inviteFriendsCard];
}
- (void)refuseBtnClick:(UIButton *)btn {
    [self.ybDelegate refuseBtnClickWithYueBanDataModel:self.inviteFriendsCard];
}
- (void)voiceBtnClick:(UIButton *)btn {
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGSize size = [self.avatarBtn.imageView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
//    self.avatarBtn.imageView.layer.cornerRadius = size.width/2;
    
    self.avatarBtn.imageView.layer.cornerRadius = self.avatarBtn.imageView.frame.size.width/2;
    self.avatarBtn.imageView.clipsToBounds = YES;
//    [self.avatarBtn setNeedsDisplay];
}

//- (void)setFrame:(CGRect)frame {
//    static int tag = 0;
//    tag ++;
//    NSLog(@"tag %d",tag);
//    NSLog(@"setFrame");
//    self.avatarBtn.imageView.layer.cornerRadius = self.avatarBtn.imageView.bounds.size.width/2;
//    self.avatarBtn.imageView.clipsToBounds = YES;
//}

#pragma mark - HSYueBanDetailViewControllerDelegate协议
- (void)agreeBtnClickWithYueBanID:(NSString *)yueBanID {
    [self.ybDelegate agreeBtnClickWithYueBanDataModel:self.inviteFriendsCard];

}
- (void)refuseBtnClickWithYueBanID:(NSString *)yueBanID {
    [self.ybDelegate refuseBtnClickWithYueBanDataModel:self.inviteFriendsCard];

}

#pragma mark 约伴语音播放
- (void)voiceInfoBtnPress:(UIButton *)btn{
    
    _recordTool = [[HSRecordTool alloc]init];
    
    //amr语音路径
    self.recordTool.recordFileAMRUrl = [[NSURL alloc]initWithString:[HSDataFormatHandle encodeURL:_inviteFriendsCard.yueban_voice_info]];
    
    //播放
    [self.recordTool playAmrRecordFile];
}
@end
