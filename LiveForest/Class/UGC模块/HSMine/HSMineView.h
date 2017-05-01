//
//  HSMineView.h
//  LiveForest
//
//  Created by 微光 on 15/4/14.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSMineView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avarlImage;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendPersons;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansPersons;
@property (weak, nonatomic) IBOutlet UILabel *gradesLabel;
@property (weak, nonatomic) IBOutlet UILabel *grades;

@property (weak, nonatomic) IBOutlet UIImageView *reflectedImage;
@property (weak, nonatomic) IBOutlet UIButton *viewRankButton;
@property (strong, nonatomic) IBOutlet UIButton *gameBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
@property (strong, nonatomic) IBOutlet UIButton *NotiBtn;
@property (strong, nonatomic) IBOutlet UILabel *nickName;


@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
