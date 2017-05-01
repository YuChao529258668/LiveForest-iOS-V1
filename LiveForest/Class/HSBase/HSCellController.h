//
//  HSCellController.h
//  LiveForest
//
//  Created by Swift on 15/5/22.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCellController : UIViewController


//点赞
//分享
//评论弹窗

//发送评论在评论控制器
- (void)sendCommentWithShareID:(NSString *)shareID Comment:(NSString *)comment CommentURI:(NSString *)uri;
@end
