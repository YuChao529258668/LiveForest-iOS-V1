//
//  HSCommentViewController.h
//  LiveForest
//
//  Created by Swift on 15/5/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HSCommentView.h"

//@class HSRequestDataController;

typedef void(^sendCommentSuccessHandler)();

@interface HSCommentViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *commentArray;
//@property (nonatomic, strong) HSCommentView *commentView;

//@property (nonatomic, strong) NSString *shareID;
//@property (nonatomic, strong) NSString *uri;

////请求后台数据公共类
//@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

//- (void)commentBtnClick:(UIButton *)btn;
//- (void)sendCommentBtnClick:(UIButton *)btn;
//- (void)blackBtnClick:(UIButton *)sender;
//- (void)backBtnClick:(id)sender;

//隐藏评论视图，scrollView开始滑动的时候调用
-(void)commentViewDisappearWithAnimation;

//自定义构造器：分享id：发送评论成功的回调block
- (instancetype)initWithShareID:(NSString *)shareID
      sendCommentSuccessHandler:(sendCommentSuccessHandler) successHandler;
//隐藏或显示评论视图
- (void)showOrHide;
@end
