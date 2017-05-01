//
//  HSInfoCompletingView.h
//  LiveForest
//
//  Created by 傲男 on 15/6/21.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
//使用第三方radiobutton
#import <RadioButton.h>

@interface HSInfoCompletingView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *avarlImage;
@property (strong, nonatomic) IBOutlet UITextField *nickname;
@property (strong, nonatomic) IBOutlet UITextField *birthday;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UILabel *maleLabel;
@property (strong, nonatomic) IBOutlet UILabel *femaleLabel;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *sportButton;

//radiobutton
@property (strong, nonatomic) RadioButton* male;
@property (strong, nonatomic) RadioButton* female;

//用户城市的ID
@property (nonatomic, copy) NSString *cityID;

//用户已经选择的运动ID
@property (nonatomic, strong)NSMutableArray *selectedSportID;

#pragma -mark 添加运动标签
- (void)addSportLabelView:(NSMutableArray *)selectedSportsIDs;
@end
