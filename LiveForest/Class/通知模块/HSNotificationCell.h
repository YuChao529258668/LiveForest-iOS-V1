//
//  HSNotificationCell.h
//  LiveForest
//
//  Created by 傲男 on 15/7/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avarlImage;
@property (strong, nonatomic) IBOutlet UILabel *notiInfo;
@property (strong, nonatomic) NSString *parent_type;
@property (strong, nonatomic) NSString *sub_type;
@property (strong, nonatomic) NSString *cell_id;

@end
