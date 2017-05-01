//
//  HSMyInviteHistoryViewController.m
//  LiveForest
//
//  Created by 余超 on 15/8/6.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSMyInviteHistoryViewController.h"
#import "HSYueBanDetailViewController.h"

static NSString *reuseIdentifier = @"HSMyInviteHistoryCell";


@interface HSMyInviteHistoryViewController ()

@end

@implementation HSMyInviteHistoryViewController

- (HSRequestDataController *)requestCtrl{
    if(_requestCtrl == nil){
        _requestCtrl = [[HSRequestDataController alloc]init];
    }
    return _requestCtrl;
}

- (instancetype)init {
    if (self = [super init]) {
        _myYueBanHistoryView = [[HSMyInviteHistoryView alloc]init];
        
        //点击返回按钮
        [_myYueBanHistoryView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //请求数据
//        [self getHistoryArray:YES];
        [self getMyYueBanHistoryArray];
        self.view = _myYueBanHistoryView;
        
        [_myYueBanHistoryView.myInviteTableView registerNib:[UINib nibWithNibName:@"HSMyInviteHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
        
        _myYueBanHistoryView.myInviteTableView.dataSource = self;
        _myYueBanHistoryView.myInviteTableView.delegate = self;
        
    }
    return self;
}


- (void)loadView{
    self.view = _myYueBanHistoryView;
    
//    [self getMyYueBanHistoryArray];
}

- (void)backBtnClick:(UIButton *)btn {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 请求约伴历史记录，并将数组赋值给 view的tableview数据，然后reloaddata
//-(void)getHistoryArray:(BOOL)yuebanState{
//    
//    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
//    if (user_token == nil) {
//        NSLog(@"user_token为空");
//        return;
//    }
//    NSString *yuebanSta = yuebanState?@"1":@"0";
//    yuebanSta = @"1";
//    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",yuebanSta,@"yueban_state",nil];
//    dict = @{@"user_token":user_token,@"yueban_state":yuebanSta};
//    NSLog(@"%@",user_token);
//    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData" ,nil];
//    [self.requestCtrl getMyYueBanDetailList:requestData andRequestCB:^(BOOL code, id yuebanList, NSString *error) {
//        if(code){
//            NSLog(@"%@",yuebanList);
//            self.myYueBanHistory = [[NSMutableArray alloc]init];
//            if(yuebanList && [yuebanList count]>0){
//                for (NSDictionary *dict in yuebanList) {
//                    HSMyYueBanDetailList *myYueBanList = [[HSMyYueBanDetailList alloc]initWithDic:dict];
//                    [self.myYueBanHistory addObject:myYueBanList];
//                }
//                
//                //                [self.myYueBanHistory addObject:yuebanList];
//                //todo
//                //                可以更新tableview了
//                [_myYueBanHistoryView.myInviteTableView reloadData];
//            }else{
//                NSLog(@"获取的约伴列表为空");
//            }
//        }else{
//            NSLog(@"获取约伴列表失败");
//        }
//    }];
//}

- (void)getMyYueBanHistoryArray{
    NSString *user_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_token"];
    if (user_token == nil) {
        NSLog(@"user_token为空");
        return;
    }
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc]initWithObjectsAndKeys:[dict JSONString],@"requestData" ,nil];
    [self.requestCtrl getMyYueBanRecordList:requestData andRequestCB:^(BOOL code, id yuebanList, NSString *error) {
        if(code){
            NSLog(@"%@",yuebanList);
            self.myYueBanHistory = [[NSMutableArray alloc]init];
            if(yuebanList && [yuebanList count]>0){
                for (NSDictionary *dict in yuebanList) {
                    HSMyYueBanDetailList *myYueBanList = [[HSMyYueBanDetailList alloc]initWithDic:dict];
                    myYueBanList.isDeal = YES;
                    [self.myYueBanHistory addObject:myYueBanList];
                }
                [_myYueBanHistoryView.myInviteTableView reloadData];
            }else{
                NSLog(@"获取的约伴列表为空");
            }
        }else{
            NSLog(@"获取约伴列表失败");
        }
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(HSMyInviteHistoryCell *cell) {
        
        //根据描述的长度，动态计算高度。
        
        //        [self configCell:cell atIndexPath:indexPath];
        cell.descriptionLabel.text = @"下午6点南大篮球场，战个痛快！";
        //        cell.descriptionLabel.text = [[self.myYueBanHistory objectAtIndex:indexPath.row] objectForKey:@""];
        
        
    }];
    //    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return 5;
        return self.myYueBanHistory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSMyInviteHistoryCell *cell = [_myYueBanHistoryView.myInviteTableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.descriptionLabel.text = @"下午6点南大篮球场，战个痛快！";
    
    // Configure the cell...
    //    [self configCell:cell andIndexPath:indexPath];
    //在这里已经设置cell的相关内容了
    cell.myYueBanList = self.myYueBanHistory[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSMyInviteHistoryCell *cell = (HSMyInviteHistoryCell *)[_myYueBanHistoryView.myInviteTableView cellForRowAtIndexPath:indexPath];
    //跳转到 详情
    HSMyYueBanDetailList *myYueBanDetailList =self.myYueBanHistory[indexPath.row]
    ;
    NSString *yueban_id =   myYueBanDetailList .yueban_id;
    HSYueBanDetailViewController * yuebanDetailViewController = [[HSYueBanDetailViewController alloc]initWithYueBanID:yueban_id];
    yuebanDetailViewController.isDeal = YES;
    [self presentViewController:yuebanDetailViewController animated:YES completion:nil];
   
}

#pragma mark 配置cell信息
- (void)configCell:(HSMyInviteHistoryCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    HSMyYueBanDetailList *yueBanDetail = (HSMyYueBanDetailList*)[_myYueBanHistory objectAtIndex:indexPath.row];
    cell.yueban_id = yueBanDetail.yueban_id;
    //todo
}
- (void)setMyYueBanHistory:(NSMutableArray *)myYueBanHistory{
    _myYueBanHistory = myYueBanHistory;
}
@end
