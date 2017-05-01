//
//  HSFriendListViewControllerTableViewController.m
//  LiveForest
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSFriendListViewController.h"

@interface HSFriendListViewController()

//该ViewController包含的子View
@property(strong,nonatomic) HSFriendListView* hSFriendListView;

//存放当前页面展示的用户列表
@property(strong,nonatomic) NSMutableArray* userList;

//存放用户的选择，是粉丝还是关注
@property(nonatomic) BOOL isFans;

//如果该界面是用于展示好友的关注/粉丝列表，则存放好友id
@property(nonatomic,strong) NSString* user_id_by_friend;

//存放数据操作的对象
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;


/**UIViewController*/
@property(nonatomic, strong)  HSVisitMineController* visitMineVC ;

@end

@implementation HSFriendListViewController




#pragma mark - View Lifecycle

#pragma mark 初始化控制器的View属性

/**
 **@param isFans:如果是粉丝列表，则为True，否则为False
 **/
- (instancetype)initWithParameter:(BOOL)isFans{
    
    //初始化当前类对象
    self = [super init];
    
    //赋值用户选项
    self.isFans = isFans;
    
    //执行默认的初始化方法
    return self;

}

- (instancetype)initWithParameter:(BOOL)isFans withFriend:(NSString*)user_id_by_friend{
    
    //初始化当前类对象
    self = [super init];
    
    //赋值用户选项
    self.isFans = isFans;
    
    //赋值选定的目标用户的id
    self.user_id_by_friend = user_id_by_friend;
    
    //执行默认的初始化方法
    return self;
    
}

- (void)loadView{
    
    //初始化一个HSFriendListView并且赋值给当前view属性
    self.hSFriendListView = [[HSFriendListView alloc] init];
    
    //设置当前View的父UIViewController
    self.hSFriendListView.parentViewController = self;
    
    //为了方便调用，将self.view父类指针指向具体的子类
    self.view = self.hSFriendListView;

}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //注册当前的自定义的Cell
    [self.hSFriendListView.tableView registerNib:[UINib
                                 nibWithNibName:@"HSFriendListViewCell"
                                 bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"HSFriendListViewCell"];
    
    //设定当前的UITableView的DataSource
    self.hSFriendListView.tableView.dataSource = self;
    self.hSFriendListView.tableView.delegate = self;
    
    //设置当前界面名
    if(self.isFans){
        //如果是粉丝列表
        self.hSFriendListView.label_ListName.text = @"粉丝列表";
    }
    else{
        //如果是关注列表
        self.hSFriendListView.label_ListName.text = @"关注列表";
    }
    
    //初始化当前请求对象
    self.requestDataCtrl = [[HSRequestDataController alloc] init];
    
    //初始化当前UITableView的数据
    [self initData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate：TableView的DataSource

#pragma mark 获取TableView中Section的数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

#pragma mark 获取TableView中Row的数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.userList count];
}

#pragma mark 获取tableView的cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld + %ld", indexPath.section, indexPath.row);
    
    NSDictionary* user = [self.userList objectAtIndex:indexPath.row];
    
    
    //获取可重用的cell
    HSFriendListViewCell *cell = [self.hSFriendListView.tableView dequeueReusableCellWithIdentifier:@"HSFriendListViewCell" forIndexPath:indexPath];
    
    //设置当前用户名
    cell.label_username.text = [user objectForKey:@"user_nickname"];
    
    //设置当前用户头像
    [HSDataFormatHandle getImageWithUri:[user objectForKey:@"user_logo_img_path"] isYaSuo:true imageTarget:cell.imageview_avatar defaultImage:cell.imageview_avatar.image andRequestCB:^(UIImage *image) {
    
    }]
    ;
    
    //设置当前用户的性别
    //如果是男生
    if([user objectForKey:@"user_sex"] == 0){
        cell.imageview_sex.image = [UIImage imageNamed:@"male_icon"];
    }else{
    //如果是女生
        cell.imageview_sex.image = [UIImage imageNamed:@"female_icon"];
    }
    
    
    //设置当前用户的签名
    cell.label_age.text =[HSDataFormatHandle handleStringWithDefaultValue:[user objectForKey:@"user_introduction"] defaultValue:@"啥都没说。。。"]; 
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - User Interaction 用户交互

#pragma mark Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前对应的User对象
    NSDictionary* user = [self.userList objectAtIndex:indexPath.row];
    
    //初始化好友界面
    _visitMineVC=[[HSVisitMineController alloc]init];
    if (self.isFans) {
        [_visitMineVC requestPersonalInfoWithUserID:[user objectForKey:@"user_fans_id"]];
    }else{
        [_visitMineVC requestPersonalInfoWithUserID:[user objectForKey:@"user_following_id"]];
    }
    
    //获取当前窗体
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    
    //插入View
    [appWindow insertSubview:_visitMineVC.view aboveSubview:self.view];
    
}


#pragma mark - Internal Helpers 内部数据辅助

#pragma mark 初始化当前数据
- (void)initData {
    
    NSLog(@"HSFrientListViewController-initData");
    
    //初始化空数组
    self.userList = [[NSMutableArray alloc] init];
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    if(!user_token){
        NSLog(@"user_token为空，无法获取列表！");
    }
    
    
    NSDictionary* dic = nil;
    
    //初始化请求参数
    if(!self.user_id_by_friend){
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token", nil];
    }
    else{
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",self.user_id_by_friend,@"user_id", nil];
    }
    
    
    //将请求参数封装到requestData中
    NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    
    //向后台请求数据
    [self.requestDataCtrl getFansOrFollowingList:requestData isFans:self.isFans andRequestCB:^(BOOL code, NSMutableArray *array, NSString *error) {
        
        //赋值当前的粉丝或者关注列表
        self.userList = array;
    
        //通知UITableView更新数据
        [self.hSFriendListView.tableView reloadData];
    }];
    
    
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
