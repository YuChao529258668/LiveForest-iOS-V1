//
//  HSNotificationCell.m
//  LiveForest
//
//  Created by 傲男 on 15/7/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSNotificationCell.h"

@implementation HSNotificationCell

- (void)awakeFromNib {
    // Initialization code]
    
    _avarlImage.layer.cornerRadius = _avarlImage.frame.size.width/2;
    _avarlImage.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
