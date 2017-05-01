//
//  HSAddressViewController.m
//  LiveForest
//
//  Created by wangfei on 7/10/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSAddressMViewController.h"
#import "HSAddressInfoVC.h"
#import "HSAddressCell.h"
#import "HSAddressInfo.h"
#import "HSRequestDataController.h"
#import "MBProgressHUD.h"

@interface HSAddressMViewController ()<AddressCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)HSRequestDataController *requestDataCtrl;

@end

@implementation HSAddressMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //后台加载用户收货地址数据
    [self getUserAddress];
    //导航栏设置
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addAddressInfo)];
    //修改新增文字大小
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
//    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    //tableView的样式设置
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 120;
    //不能选择，不处于编辑状态下
    self.tableView.allowsSelection = NO;
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAddress:) name:@"updateAddress" object:nil];

}
- (NSMutableArray *)addressArrayM
{
    if (_addressArrayM == nil) {
        _addressArrayM = [NSMutableArray array];
    }
    return _addressArrayM;
}
- (HSRequestDataController *)requestDataCtrl
{
    if (_requestDataCtrl == nil) {
        _requestDataCtrl = [[HSRequestDataController alloc] init];
    }
    return _requestDataCtrl;
}
#pragma mark - 通知接收后的动作
/**
 * 刷新页面
 */
-(void)updateAddress:(NSNotification *)noti
{
    self.addressArrayM  = noti.userInfo[@"updateAddress"];
    //刷新显示
    [self.tableView reloadData];
}

#pragma mark - tableView数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSAddressCell * cell = [HSAddressCell initWithTableView:tableView];
    //设置cell的代理,当按钮点击时通知本控制器做事
    cell.delegate = self;
    //设置cell显示内容和按钮的tag
    HSAddressInfo *addressInfo = self.addressArrayM[indexPath.row];
    addressInfo.buttonTag = indexPath.row;
    
    [cell setAddressInfo:addressInfo];
    return cell;
}

#pragma -mark 增加地址
-(void)addAddressInfo
{
    //新增收货地址
    HSAddressInfoVC *addressInfo = [[HSAddressInfoVC alloc]init];
    addressInfo.title = @"新增收货地址";
    addressInfo.tempAddressArrayM = self.addressArrayM;
    [self.navigationController pushViewController:addressInfo animated:YES];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark addressCell的代理实现方法
/**
 * 编辑修改地址
 *
 */
- (void)addressCellDidClickEditButton:(HSAddressCell *)addressCell
{
    //取出buttonTag
    HSAddressInfo *editAddressInfo = self.addressArrayM[addressCell.editButton.tag];
    HSAddressInfoVC *editAddressInfoVC = [[HSAddressInfoVC alloc] init];
    editAddressInfoVC.title = @"编辑收货地址";
    editAddressInfoVC.editAddressInfo = editAddressInfo;
    editAddressInfoVC.tempAddressArrayM = self.addressArrayM;
    
    [self.navigationController pushViewController:editAddressInfoVC animated:YES];
    
}
/**
 *  删除地址
 *
 */
- (void)addressCellDidClickDeleteButton:(HSAddressCell *)addressCell
{
    //提示框
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除此收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //将删除索引赋值给alertView的tag
    alertView.tag = addressCell.deleteButton.tag;
    [alertView show];
    return;
}

#pragma mark - AlertView代理事件
/**
 *  确定时删除活动，通知后台
 *  @param alertView   alertView
 *  @param buttonIndex buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //获取当前的对象的一份拷贝，防止后台更新数据错误，再次更新提交数据重复
        NSMutableArray *copyAddressM = [self.addressArrayM mutableCopy];
        //取出buttonTag
        [copyAddressM removeObjectAtIndex:alertView.tag];
        //提交后台
        [[[HSAddressInfoVC alloc]init]updateUserAddress:copyAddressM showLabelTitle:@"删除成功"];
    }
}

#pragma mark - 获取后台用户收货地址
- (void)getUserAddress
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if (!user_token) {
        NSLog(@"user_token为空");
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中";
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.requestDataCtrl getPersonAddress:requestData andRequestCB:^(BOOL code, NSArray *userAddress, NSString * error) {
        [hud hide:YES];
        if (code) {
            if (userAddress != nil) {
                self.addressArrayM = [HSAddressInfo addressArray:userAddress];
                [self.tableView reloadData];
            }else{
                NSLog(@"没有用户收货地址数据");
            }
            
        }
        else{
            NSLog(@"请求错误，%@",error);
        }
    }];
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
