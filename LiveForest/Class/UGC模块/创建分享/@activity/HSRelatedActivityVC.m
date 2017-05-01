//
//  HSRelatedActivityVC.m
//  LiveForest
//
//  Created by wangfei on 7/28/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSRelatedActivityVC.h"
#import "HSRequestDataController.h"
#import "HSDisplayPicActivity.h"
#import "MBProgressHUD.h"

@interface HSRelatedActivityVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong)NSMutableArray *activityArray;

@property (nonatomic, strong)NSMutableArray *searchActivityArray;

@property (nonatomic, strong)HSRequestDataController *requestDataCtrl;

/**
 *  用户上次选中的index
 */
@property(nonatomic,strong) NSIndexPath *lastPath;

@end

@implementation HSRelatedActivityVC

- (HSRequestDataController *)requestDataCtrl
{
    if (_requestDataCtrl == nil) {
        _requestDataCtrl = [[HSRequestDataController alloc]init];
    }
    return _requestDataCtrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDisplayPicActivity];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
    self.activityTableView.dataSource = self;
    self.activityTableView.delegate = self;
    self.searchBar.delegate = self;
    self.activityTableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
}


/**
 *  关闭控制器
 */
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 提交，通知上个页面
- (IBAction)confirm:(id)sender {
    //可以提交空的
//    if(self.lastPath == nil)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择一个关联活动" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }

    if (self.lastPath != nil) {
        
        HSDisplayPicActivity *selectActivity = self.activityArray[self.lastPath.row];
        
        self.activityID = selectActivity.activity_id;
    }else{
        self.activityID = nil;
    }
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:self.activityID forKey:@"activityID"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"relatedActivityID" object:self userInfo:dictM];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
    HSDisplayPicActivity *activity = self.activityArray[indexPath.row];
    cell.textLabel.text = activity.activity_name;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    //去除选中cell的复用问题
    NSInteger row = [indexPath row];
    
    NSInteger oldRow = [_lastPath row];
    
    if (row == oldRow && _lastPath != nil) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
}

#pragma mark - tableView代理方法
/**
 *  选择某行
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //关闭键盘
    [self resignSearchBar];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 如果cell已经被标记
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        // 取消标记
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    // 如果cell未标记
    else{
        // 标记cell
        cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    }
    //实现单选功能
    NSInteger newRow = [indexPath row];
    
    NSInteger oldRow = (_lastPath != nil) ? [_lastPath row] : -1;
    
    if (newRow != oldRow) {
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        _lastPath = indexPath;
        
    }else{
        _lastPath = nil;
    }
    // 取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**
 *  滚动关闭视图
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignSearchBar];
}
#pragma mark - searchBar代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *searchArrayM = [NSMutableArray array];

    //清除选择痕迹
    self.lastPath = nil;
    
    if (searchText.length == 0) {
        self.activityArray = self.searchActivityArray;
        [self.activityTableView reloadData];
        return;
    }
    for (HSDisplayPicActivity *activity in self.searchActivityArray) {
        //输出含有该字符串的活动
        if ([activity.activity_name rangeOfString:searchText].location != NSNotFound) {
            [searchArrayM addObject:activity];
        }
    }
    self.activityArray = searchArrayM;
    [self.activityTableView reloadData];
}
/**
 *  获取系统晒图活动
 */
- (void)getDisplayPicActivity
{
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token){
        NSLog(@"user_token为空，");
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.activityTableView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    [self.requestDataCtrl getDisplayPicActivityList:requestData andRequestCB:^(BOOL code, NSArray *responseObject, NSString * error) {
        if (code) {
            if (responseObject != nil) {
                self.activityArray = [HSDisplayPicActivity displayPicActivityWithArray:responseObject];
                self.searchActivityArray = self.activityArray;
                if (self.activityID != nil) {//赋值开始的选中状态
                    [self.activityArray enumerateObjectsUsingBlock:^(HSDisplayPicActivity *activity, NSUInteger idx, BOOL *stop) {
                        if ([activity.activity_id isEqualToString:self.activityID]) {
                            self.lastPath = [NSIndexPath indexPathForRow:idx inSection:0];
                            *stop = YES;
                        }
                    }];
                }
                [self.activityTableView reloadData];
                
            }else{
                NSLog(@"晒图官方数据为空");
            }
        }else{
            NSLog(@"code不为0，%@",error);
        }
        [hud hide:YES];
    }];
}

- (void)resignSearchBar
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
