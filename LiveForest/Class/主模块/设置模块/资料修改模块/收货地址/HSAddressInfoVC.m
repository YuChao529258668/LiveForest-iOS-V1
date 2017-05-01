//
//  HSAddressInfoVC.m
//  LiveForest
//
//  Created by wangfei on 7/16/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSAddressInfoVC.h"
#import "Macros.h"
#import "HSPickView.h"
#import "HSAddressInfo.h"
#import "HSAddressMViewController.h"
#import "HSRequestDataController.h"
#import "HSDataFormatHandle.h"
#import "MBProgressHUD.h"

@interface HSAddressInfoVC () <UITextFieldDelegate>

@property (nonatomic, strong)UILabel *nameLablel;
@property (nonatomic, strong)UILabel *phoneLablel;
@property (nonatomic, strong)UILabel *areaLablel;
@property (nonatomic, strong)UILabel *detailLablel;

@property (nonatomic, strong)UITextField  *nameTextField;
@property (nonatomic, strong)UITextField  *phoneTextField;
@property (nonatomic, strong)UITextField  *areaTextField;
@property (nonatomic, strong)UITextField  *detailTextField;

/**
 *  用户选择区域ID，保存去后台
 */
@property (nonatomic, copy) NSString *areaID;

@property (nonatomic, strong)HSRequestDataController *requestDataCtrl;
@end

static CGFloat padding = 10;
static CGFloat height = 30;

@implementation HSAddressInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    NSString *buttonTitle = @"完成";
    if ([self.title isEqualToString:@"新增收货地址"]) {
        buttonTitle = @"添加";
    }
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:buttonTitle style:UIBarButtonItemStylePlain target:self action:@selector(saveAddressInfo)];
    [self.view addSubview:self.nameLablel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.phoneLablel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.areaLablel];
    [self.view addSubview:self.areaTextField];
    [self.view addSubview:self.detailLablel];
    [self.view addSubview:self.detailTextField];
    //编辑信息不为空，进入编辑模式,赋值
    if (self.editAddressInfo) {
        self.nameTextField.text = self.editAddressInfo.user_name;
        self.phoneTextField.text = self.editAddressInfo.user_phone;
        self.areaTextField.text = self.editAddressInfo.area_info;
        self.detailTextField.text = self.editAddressInfo.detail_address;
    }
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.areaTextField.delegate = self;
    self.detailTextField.delegate =self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAreaInfo:) name:@"didClickSaveCity" object:nil];
    self.view.backgroundColor = UIColorFromRGB(250, 250, 245);
}
/**
 *  后台请求加载类
 */
- (HSRequestDataController *)requestDataCtrl
{
    if (_requestDataCtrl == nil) {
        _requestDataCtrl = [[HSRequestDataController alloc] init];
    }
    return _requestDataCtrl;
}
- (UILabel *)nameLablel
{
    if (_nameLablel == nil) {
        CGFloat nameLabelY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + padding;
        CGFloat nameLabelW = (self.view.bounds.size.width - 2 * padding) * 0.25;
        _nameLablel = [[UILabel alloc]initWithFrame:CGRectMake(padding, nameLabelY, nameLabelW, height)];
        _nameLablel.font = [UIFont systemFontOfSize:14.0];
        _nameLablel.textAlignment = NSTextAlignmentLeft;
        _nameLablel.text = @"收货人姓名";
        _nameLablel.textColor = [UIColor grayColor];
    }
    return _nameLablel;
}
- (UITextField *)nameTextField
{
    if (_nameTextField == nil) {
        CGFloat nameTextFieldX = CGRectGetMaxX(self.nameLablel.frame);
        CGFloat nameTextFieldY = self.nameLablel.frame.origin.y;
        CGFloat nameTextFieldW = (self.view.bounds.size.width - 2 * padding) * 0.75;
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nameTextFieldX, nameTextFieldY, nameTextFieldW, height)];
        _nameTextField.font = [UIFont systemFontOfSize:15.0];
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.backgroundColor = UIColorFromRGB(250, 250, 245);
    }
    return _nameTextField;
}
- (UILabel *)phoneLablel
{
    if (_phoneLablel == nil) {
        CGFloat phoneLablelY = CGRectGetMaxY(self.nameLablel.frame) + padding;
        CGFloat phoneLablelW = self.nameLablel.bounds.size.width;
        _phoneLablel = [[UILabel alloc]initWithFrame:CGRectMake(padding, phoneLablelY, phoneLablelW, height)];
        _phoneLablel.font = [UIFont systemFontOfSize:14.0];
        _phoneLablel.textAlignment = NSTextAlignmentLeft;
        _phoneLablel.text = @"手机号码";
        _phoneLablel.textColor = [UIColor grayColor];
    }
    return _phoneLablel;
}
- (UITextField *)phoneTextField
{
    if (_phoneTextField == nil) {
        CGFloat phoneTextFieldX = CGRectGetMaxX(self.phoneLablel.frame);
        CGFloat phoneTextFieldY = self.phoneLablel.frame.origin.y;
        CGFloat phoneTextFieldW = self.nameTextField.bounds.size.width;
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(phoneTextFieldX, phoneTextFieldY, phoneTextFieldW, height)];
        _phoneTextField.font = [UIFont systemFontOfSize:15.0];
        _phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.backgroundColor = UIColorFromRGB(250, 250, 245);
    }
    return _phoneTextField;
}
- (UILabel *)areaLablel
{
    if (_areaLablel == nil) {
        CGFloat areaLablelY = CGRectGetMaxY(self.phoneLablel.frame) + padding;
        CGFloat areaLablelW = self.nameLablel.bounds.size.width;
        _areaLablel = [[UILabel alloc]initWithFrame:CGRectMake(padding, areaLablelY, areaLablelW, height)];
        _areaLablel.font = [UIFont systemFontOfSize:14.0];
        _areaLablel.textAlignment = NSTextAlignmentLeft;
        _areaLablel.text = @"所在区域";
        _areaLablel.textColor = [UIColor grayColor];
    }
    return _areaLablel;
}
- (UITextField *)areaTextField
{
    if (_areaTextField == nil) {
        CGFloat areaTextFieldX = self.nameTextField.frame.origin.x;
        CGFloat areaTextFieldY = self.areaLablel.frame.origin.y;
        CGFloat areaTextFieldW = self.nameTextField.bounds.size.width;
        _areaTextField = [[UITextField alloc]initWithFrame:CGRectMake(areaTextFieldX, areaTextFieldY, areaTextFieldW, height)];
        _areaTextField.tag = 1000;
        _areaTextField.font = [UIFont systemFontOfSize:15.0];
        _areaTextField.borderStyle = UITextBorderStyleRoundedRect;
        _areaTextField.backgroundColor = UIColorFromRGB(250, 250, 245);
    }
    return _areaTextField;
}
- (UILabel *)detailLablel
{
    if (_detailLablel == nil) {
        CGFloat detailLablelY = CGRectGetMaxY(self.areaLablel.frame) + padding;
        CGFloat detailLablelW = self.nameLablel.bounds.size.width;
        _detailLablel = [[UILabel alloc]initWithFrame:CGRectMake(padding, detailLablelY, detailLablelW, height)];
        _detailLablel.font = [UIFont systemFontOfSize:14.0];
        _detailLablel.textAlignment = NSTextAlignmentLeft;
        _detailLablel.text = @"详细地址";
        _detailLablel.textColor = [UIColor grayColor];
    }
    return _detailLablel;
}
- (UITextField *)detailTextField
{
    if (_detailTextField == nil) {
        CGFloat detailTextFieldX = self.nameTextField.frame.origin.x;
        CGFloat detailTextFieldY = self.detailLablel.frame.origin.y;
        CGFloat detailTextFieldW = self.nameTextField.bounds.size.width;
        _detailTextField = [[UITextField alloc]initWithFrame:CGRectMake(detailTextFieldX, detailTextFieldY, detailTextFieldW, height)];
        _detailTextField.font = [UIFont systemFontOfSize:15.0];
        _detailTextField.borderStyle = UITextBorderStyleRoundedRect;
        _detailTextField.returnKeyType = UIReturnKeyDone;
        _detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _detailTextField.enablesReturnKeyAutomatically = YES;
        _detailTextField.backgroundColor = UIColorFromRGB(250, 250, 245);
    }
    return _detailTextField;
}

#pragma -mark textFiled代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1000) {
        [self resignTextFiled];
        HSPickView *areaPickView = [[HSPickView alloc]initWithFrame:self.view.frame Level:AreaLevelDistrict];
        [areaPickView show];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignTextFiled];
    return YES;
}
#pragma -mark 保存用户收货地址信息
- (void)saveAddressInfo
{
    [self resignTextFiled];
    HSAddressInfo *addressInfo = [[HSAddressInfo alloc]init];
    addressInfo.user_name = self.nameTextField.text;
    addressInfo.user_phone = self.phoneTextField.text;
    addressInfo.area_info = self.areaTextField.text;
    addressInfo.area_id = self.areaID;
    addressInfo.detail_address = self.detailTextField.text;
    if (self.nameTextField.text.length == 0) {
        ShowHud(@"请输入收货人姓名", NO);
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        ShowHud(@"请输入联系号码", NO);
        return;
    }
    if (self.areaTextField.text.length == 0) {
        ShowHud(@"请选择地区", NO);
        return;
    }
    if (self.detailTextField.text.length == 0) {
        ShowHud(@"请输入详细地址", NO);
        return;
    }
    //获取当前的对象的一份拷贝，防止后台更新数据错误，再次更新提交数据重复
    NSMutableArray *copyAddressM = [self.tempAddressArrayM mutableCopy];
    //后台
    if (self.editAddressInfo == nil) {
        //新增数据
        [copyAddressM addObject:addressInfo];
        [self updateUserAddress:copyAddressM showLabelTitle:@"新增成功"];

    }else{
        //修改原有数据
        if (self.areaID == nil) {
            addressInfo.area_id = self.editAddressInfo.area_id;
        }
        [copyAddressM replaceObjectAtIndex:self.editAddressInfo.buttonTag withObject:addressInfo];
        [self updateUserAddress:copyAddressM showLabelTitle:@"编辑成功"];
    }
}

#pragma mark - 通知显示选择区域
- (void)showAreaInfo:(NSNotification *)noti
{
    NSString *areaInfo = noti.userInfo[@"areaInfo"];
    self.areaTextField.text = areaInfo;
    self.areaID = noti.userInfo[@"areaID"];
}
#pragma mark - 更新后台用户收货地址，因为用户收货地址数据不多可以每次都全部更新
- (void)updateUserAddress:(NSMutableArray *)addressM showLabelTitle:(NSString *)title
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if (!user_token) {
        NSLog(@"user_token为空");
        return;
    }
    //将模型数组转化为字典数组，方便json解析
    NSMutableArray *dicArray = [NSMutableArray array];
    for (HSAddressInfo *addressModel in addressM) {
        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
        [dicM setObject:addressModel.user_name forKey:@"user_name"];
        [dicM setObject:addressModel.user_phone forKey:@"user_phone"];
        [dicM setObject:addressModel.area_id forKey:@"area_id"];
        [dicM setObject:addressModel.detail_address forKey:@"detail_address"];
        [dicArray addObject:dicM];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user_token,@"user_token",dicArray,@"user_address",nil];

    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.requestDataCtrl updatePersonAddress:requestData andRequestCB:^(BOOL code, id responseObject, NSString * error) {
        if (code) {
            //通知上个页面
            [hud hide:YES];
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            [dicM setObject:addressM forKey:@"updateAddress"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAddress" object:self userInfo:dicM];
            //关闭
            ShowHud(title, NO);
            [self back];

        }
        else{
            [hud hide:YES];
            ShowHud(@"网络请求错误", NO);
            NSLog(@"，%@",error);
        }
    }];
}

/**
 *  关闭键盘
 */
- (void)resignTextFiled
{
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
    if ([self.phoneTextField isFirstResponder]) {
        [self.phoneTextField resignFirstResponder];
    }
    if ([self.detailTextField isFirstResponder]) {
        [self.detailTextField resignFirstResponder];
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
