//
//  HSShareView.h
//  LiveForest
//
//  Created by 微光 on 15/4/27.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSShareView : UIView
@property (strong, nonatomic) IBOutlet UIView *shareView;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;//返回按钮
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;//发送分享

@property (strong, nonatomic) IBOutlet UIImageView *avarlImage;//头像
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (strong, nonatomic) IBOutlet UITextView *shareTextView;//分享内容tv
@property (strong, nonatomic) IBOutlet UIImageView *firstImageVIew;//第一个图片


@property (weak, nonatomic) IBOutlet UIButton *mapBtn;//位置按钮
@property (weak, nonatomic) IBOutlet UIButton *atBtn;//at好友
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;//活动按钮
@property (weak, nonatomic) IBOutlet UIButton *sportBtn;//运动按钮



@property (weak, nonatomic) IBOutlet UIImageView *bottomBarImage;//？
@property (strong, nonatomic) UIImageView* blackImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (weak, nonatomic) IBOutlet UIImageView *imageView0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView7;
@property (weak, nonatomic) IBOutlet UIImageView *imageView8;

@property (strong, nonatomic) IBOutlet UILabel *uilabel;

@end
