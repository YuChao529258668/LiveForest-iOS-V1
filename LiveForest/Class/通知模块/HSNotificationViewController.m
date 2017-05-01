//
//  HSNotificationViewController.m
//  LiveForest
//
//  Created by 傲男 on 15/7/17.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSNotificationViewController.h"

#import "HSNotificationCell.h"

@interface HSNotificationViewController ()

@end

@implementation HSNotificationViewController

@synthesize notificationView = _notificationView;

static NSString *reuseIdentifier=@"HSNotificationCell";

- (instancetype)init{
    
    self = [super init];
    if(self){
        _notificationView = [[HSNotificationView alloc] init];
        _notificationView.tableView.dataSource = self;
        _notificationView.tableView.delegate = self;
        
        
        _offVC = [[HSOfficialViewController alloc]init];
        
        //从本地缓存读取通知的东西
        _notiArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"notiInfoArray"]];
    }
    
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNotiInfo:) name:@"notificationHSNotificationDataSource" object:nil];

    return self;
}

- (void)loadView{
    self.view =  _notificationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

#pragma mark  获取到了推送的系统通知
- (void) addNotiInfo:(NSNotification *)noti{
    if(noti.object){
        //添加数组
        [_notiArray addObject:noti.object];
        [_notificationView.tableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:_notiArray forKey:@"notiInfoArray"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _notiArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSNotificationCell *cell = [_notificationView.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.row < _notiArray.count){
        [cell.notiInfo setText:[[_notiArray objectAtIndex:indexPath.row ] objectForKey:@"pushMessage"]];
        cell.cell_id = [[_notiArray objectAtIndex:indexPath.row ] objectForKey:@"id"];
        cell.parent_type = [[_notiArray objectAtIndex:indexPath.row ] objectForKey:@"parent_type"];
        cell.sub_type = [[_notiArray objectAtIndex:indexPath.row ] objectForKey:@"sub_type"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSNotificationCell *cell = (HSNotificationCell *)[_notificationView.tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.parent_type isEqualToString:@"01"]){
        if([cell.sub_type isEqualToString:@"00"]){
            UIWindow *window = [[UIApplication sharedApplication]keyWindow];
            [_offVC getShareInfoWithShareID:cell.cell_id];
            [window insertSubview:_offVC.view aboveSubview:self.view];
            
            //删除
            [_notiArray removeObjectAtIndex:indexPath.row];
            //更新
            [[NSUserDefaults standardUserDefaults] setObject:_notiArray forKey:@"notiInfoArray"];
            [_notificationView.tableView reloadData];
            
            if(_notiArray.count<1){
                [self.view removeFromSuperview];
            }
        }
    }
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
