//
//  HSActivityLargeCardTopCell.m
//  LiveForest
//
//  Created by 余超 on 15/7/15.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSActivityLargeCardTopCell.h"

@implementation HSActivityLargeCardTopCell

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        
        //执行loadNibNamed后会马上执行awakeFromNib
        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSActivityLargeCardTopCell" owner:nil options:nil];
        self = array[0];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
