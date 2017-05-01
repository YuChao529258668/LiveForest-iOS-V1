//
//  HSAddInviteView.h
//  LiveForest
//
//  Created by wangfei on 8/4/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAddInviteView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *moveImageView;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendBtn;

@property (weak, nonatomic) IBOutlet UIButton *inviteAllBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sportImageView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UITextField *sportNameTF;
@property (weak, nonatomic) IBOutlet UITextField *yuebanDetailTF;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanVoiceBtn;

//左右滑动
@property (strong, nonatomic) IBOutlet UISlider *slider;

/**
 *  录音按钮，当文字不是按住说话就是播放按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *pressSpeakBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)show;
@end
