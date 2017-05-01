//
//  HSAddressCell.m
//  LiveForest
//
//  Created by wangfei on 7/17/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSAddressCell.h"
#import "HSAddressInfo.h"

@implementation HSAddressCell

+(instancetype)initWithTableView:(UITableView *)tableView
{
    HSAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    if (cell == nil) {
        //从xib中加载
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HSAddressCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setAddressInfo:(HSAddressInfo *)addressInfo
{
    _addressInfo = addressInfo;
    NSString *namephoneInfo = [NSString stringWithFormat:@"%@  %@",addressInfo.user_name,addressInfo.user_phone];
    self.namePhoneLabel.text = namephoneInfo;
    NSString *addressText = [NSString stringWithFormat:@"%@%@",addressInfo.area_info,addressInfo.detail_address];
    self.addressLabel.text = addressText;
    //设置按钮tag
    self.deleteButton.tag = addressInfo.buttonTag;
    self.editButton.tag = addressInfo.buttonTag;
}

- (IBAction)deleteAddress:(UIButton *)deleteButton
{
    //通知代理删除
    if ([self.delegate respondsToSelector:@selector(addressCellDidClickDeleteButton:)]) {
        [self.delegate addressCellDidClickDeleteButton:self];
    }
}
- (IBAction)editAddress:(UIButton *)editButton
{
    //通知带代理编辑
    if ([self.delegate respondsToSelector:@selector(addressCellDidClickEditButton:)]) {
        [self.delegate addressCellDidClickEditButton:self];
    }
}


@end
