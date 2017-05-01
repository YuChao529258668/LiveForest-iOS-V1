//
//  HSInviteFriendsVC.h
//  LiveForest
//
//  Created by 傲男 on 15/7/8.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSInviteFriendsView.h"
#import "HSCollectionViewSmallLayout.h"
#import "HSConstantURL.h"

#import "HSMyYueBanDetailList.h"

#import "HSScaleScrollView.h"

@interface HSInviteFriendsVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,HSScaleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pushArray;
@property (nonatomic, strong) NSString *pushInfo;

@property (nonatomic, strong) HSInviteFriendsView *inviteFriendsView ;


@property (nonatomic, strong) NSMutableArray *inviteFromFriendArray;
@property (nonatomic, strong) NSMutableArray *inviteFromStrangerArray;


//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HSScaleScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizerScollView;
@property (nonatomic, strong) UICollectionView *collectionView;

/*
 历史的（停止广播的）约伴列表
*/
@property (nonatomic, strong) NSMutableArray *myYueBanHistoryList;
/*
 当前广播中的约伴
 */
@property (nonatomic, strong) HSMyYueBanDetailList *myUnStoppedYueBanDetail;
@end
