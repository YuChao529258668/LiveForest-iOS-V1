//
//  HSAddressCell.h
//  LiveForest
//
//  Created by wangfei on 7/17/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSAddressInfo,HSAddressCell;

@protocol AddressCellDelegate <NSObject>
//方法以类名开头，第一个参数是自己
-(void)addressCellDidClickEditButton:(HSAddressCell *)addressCell;
- (void)addressCellDidClickDeleteButton:(HSAddressCell *)addressCell;
@end
@interface HSAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *namePhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/**
 *  模型，存储要显示的内容
 */
@property (nonatomic, strong) HSAddressInfo *addressInfo;

/**
 *  代理
 */
@property (nonatomic, weak) id<AddressCellDelegate> delegate;
/**
 *  类方法，返回cell对象
 *
 *  @param tableView
 *
 *  @return cell对象
 */
+(instancetype)initWithTableView:(UITableView *)tableView;
@end
