//
//  HSAtFriendViewController.m
//  LiveForest
//
//  Created by 余超 on 15/7/28.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSAtFriendViewController.h"
#import "HSRequestDataController.h"
#import "HSFriendListViewCell.h"
#import "HSFriendInfo.h"
#import "HSDataFormatHandle.h"

@interface HSAtFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong)NSMutableArray *friendsArray;

@property (nonatomic, strong)NSMutableArray *searchFriendsArray;

/**
 *  当前用户选中的用户模型数组
 */
@property (nonatomic, strong)NSMutableArray *lastSelectedFriends;

@property (nonatomic, strong)HSRequestDataController *requestDataCtrl;

@end

@implementation HSAtFriendViewController

- (HSRequestDataController *)requestDataCtrl
{
    if (_requestDataCtrl == nil) {
        _requestDataCtrl = [[HSRequestDataController alloc]init];
    }
    return _requestDataCtrl;
}
- (NSMutableArray *)lastSelectedFriends
{
    if (_lastSelectedFriends == nil) {
        _lastSelectedFriends = [[NSMutableArray alloc]init];
    }
    return _lastSelectedFriends;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFriendsList];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
    //注册
    [self.friendTableView registerNib:[UINib nibWithNibName:@"HSFriendListViewCell"
                                                     bundle:[NSBundle mainBundle]]forCellReuseIdentifier:@"HSFriendListViewCell"];

    
    self.friendTableView.dataSource = self;
    self.friendTableView.delegate = self;
    
    self.friendTableView.rowHeight = 76;
    self.searchBar.delegate = self;
    self.friendTableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 提交
- (IBAction)confirm:(id)sender {
    //提交好友id数组区前台
    NSMutableArray *atFriendsID = [NSMutableArray array];
    for (HSFriendInfo *friendInfo in self.lastSelectedFriends) {
        [atFriendsID addObject:friendInfo.friend_id];
    }
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:atFriendsID forKey:@"atFriendIDs"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"atFriendsID" object:self userInfo:dictM];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSFriendListViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HSFriendListViewCell" forIndexPath:indexPath];
     cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:245/255.0 alpha:1.0];
    HSFriendInfo *friendInfo = self.friendsArray[indexPath.row];
    
    //格式化图片路径
    NSString *avatarUrl = [[NSString alloc]initWithString:friendInfo.user_logo_img_path];
    
    //压缩图片路径
//    NSString *zipAvatarlUrl = [[NSString alloc] initWithFormat:@"%@%s",avatarUrl ,QiNiuImageYaSuo];
//    
//    //编码图片路径
//    NSURL * urlAvarl = [NSURL URLWithString:[zipAvatarlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //异步
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        
//        [cell.imageview_avatar sd_setImageWithURL:urlAvarl
//                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                  if(!image){
//                                      NSLog(@"请求头像失败");
//                                  }
//                              }];
        
        [HSDataFormatHandle getImageWithUri:avatarUrl isYaSuo:true imageTarget:cell.imageview_avatar defaultImage:[UIImage imageNamed:@"default"] andRequestCB:^(UIImage *image) {
        }];
    });
    
    cell.label_username.text = friendInfo.user_nickname;
    //设置当前用户的性别
    //如果是男生
    if([friendInfo.user_sex isEqualToString:@"0"]){
        cell.imageview_sex.image = [UIImage imageNamed:@"male_icon"];
    }else{
        //如果是女生
        cell.imageview_sex.image = [UIImage imageNamed:@"female_icon"];
    }
    
    //设置当前用户的签名
    cell.label_age.text =[HSDataFormatHandle handleStringWithDefaultValue:friendInfo.user_introduction defaultValue:@"啥都没说。。。"];

    //处理check标志
    NSArray *selectedFriends = [self.lastSelectedFriends valueForKey:@"friend_id"];
    if ([selectedFriends containsObject:friendInfo.friend_id]) {
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
//    [self resignSearchBar];
    NSLog(@"indexPath.row,%ld",indexPath.row);
    HSFriendInfo *friendInfo = self.friendsArray[indexPath.row];
    //是否选中
    friendInfo.ischecked = !friendInfo.ischecked;
    if (friendInfo.ischecked) {
        [self.lastSelectedFriends addObject:friendInfo];
    }else{
        [self.lastSelectedFriends removeObject:friendInfo];
    }
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

- (void)resignSearchBar
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}
#pragma mark - searchBar代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *searchArrayM = [NSMutableArray array];
    
    //清除选择痕迹
    NSLog(@"searchText:%@",searchText);
    if (searchText.length == 0) {
        self.friendsArray = self.searchFriendsArray;
        [self.friendTableView reloadData];
        return;
    }
    for (HSFriendInfo *friendInfo in self.searchFriendsArray) {
        //输出含有该字符串的活动
        if ([friendInfo.user_nickname rangeOfString:searchText].location != NSNotFound) {
            [searchArrayM addObject:friendInfo];
        }
    }
    self.friendsArray = searchArrayM;
    [self.friendTableView reloadData];
}

#pragma mark - 获取后台好友列表
- (void)getFriendsList
{
    NSString *user_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    if (user_token == nil) {
        NSLog(@"user_token 为空");
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token", nil];
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData", nil];
    [self.requestDataCtrl getFriendsList:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            self.friendsArray = [HSFriendInfo friendArrayWithArray:responseObject];
            self.searchFriendsArray = self.friendsArray;
            //初始化选中的数组
            if (self.selectedFriendsID != nil && self.selectedFriendsID.count != 0) {
                int __block count = 0;//计数
                [self.friendsArray enumerateObjectsUsingBlock:^(HSFriendInfo *obj, NSUInteger idx, BOOL *stop) {
                    for (NSString *friendID in self.selectedFriendsID) {
                        if ([friendID isEqualToString:obj.friend_id]) {//相等加入
                            [self.lastSelectedFriends addObject:obj];
                            obj.ischecked = YES;
                            count ++;//找到计数器+1
                            //跳出这层循环
                            break;
                        }
                    }
                    //当找到的个数等于传入的数组长度，结束
                    if (count == self.selectedFriendsID.count) {
                        *stop = YES;
                    }
                }];
               
            }
           
            [self.friendTableView reloadData];
        }else{
            NSLog(@"请求数据出错，%@",error);
        }
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
