//
//  HSGameChartsTableViewCell.h
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSGameChartsModel;

@interface HSGameChartsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(nonatomic,copy)NSString *gamerId;

@property(strong,nonatomic)HSGameChartsModel *gameChartsModel;

//+(id)gameCell;

+(id)ID;

- (IBAction)avatarButtonClicked:(id)sender;

@end
