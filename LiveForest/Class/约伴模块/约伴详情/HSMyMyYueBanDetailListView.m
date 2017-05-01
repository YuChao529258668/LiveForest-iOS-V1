//
//  HSMyMyYueBanDetailListView.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSMyMyYueBanDetailListView.h"
#import "HSYueBanListTopTableViewCell.h"
//#import "HSYueBanListTableViewController.h"
#import "HSYueBanDetailTableViewCell.h"
#import "HSRequestDataController.h"


@implementation HSMyMyYueBanDetailListView
@synthesize MyYueBanListTableView;
@synthesize isMe;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (self) {
        isMe = NO;
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews;
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSMyMyYueBanDetailListView" owner:self options:nil];
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 加载nib
        self = arrayOfViews[0];
        
        [MyYueBanListTableView registerNib:[UINib nibWithNibName:@"HSYueBanDetailTableViewCell" bundle:nil] forCellReuseIdentifier:[HSYueBanDetailTableViewCell ID]];
        [MyYueBanListTableView registerNib:[UINib nibWithNibName:@"HSYueBanListTopTableViewCell" bundle:nil] forCellReuseIdentifier:[HSYueBanListTopTableViewCell ID]];
        MyYueBanListTableView.delegate = self;
        MyYueBanListTableView.dataSource = self;
        
        
        if(isMe){
            self.ignoreInviteBtn.hidden = YES;
            self.wantGoBtn.hidden = YES;
        }else{
            self.stopInviteBtn.hidden = YES;
        }
        
        self.requestDataCtrl = [[HSRequestDataController alloc]init];
    }
    
//    [self getYueBanDetailWithId];
    return  self;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        //        return isMe?yueBanListFromFriends.count:1;
        return self.friendsArray.count;
    }
    if (section == 2) {
        //        return isMe?yueBanListFromStrangers.count:yueBanListFromStrangers;
        return self.strangersArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HSYueBanListTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSYueBanListTopTableViewCell ID] forIndexPath:indexPath];
        if (cell == nil) {
            cell = [HSYueBanListTopTableViewCell yueBanDetailCell];
        }
//        cell.yuebanDetail = self.yuebanDetail;
        if (cell == nil) {
            cell = [HSYueBanDetailTableViewCell yueBaneListCell];
            //        cell.yueBaneListCell = self.yuebanDetail;
        }
        return cell;
    }
    
    HSYueBanDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSYueBanDetailTableViewCell ID] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [HSYueBanDetailTableViewCell yueBaneListCell];
//        cell.yueBaneListCell = self.yuebanDetail;
    }
    
        if (indexPath.section == 1) {
            cell.userInfo  = self.friendsArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            cell.userInfo = self.strangersArray[indexPath.row];
        }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:[HSYueBanListTopTableViewCell ID] configuration:^(HSYueBanListTopTableViewCell *cell) {
            
            if (cell == nil) {
                cell = [HSYueBanListTopTableViewCell yueBanDetailCell];
            }
            if (self.yuebanDetail) {
                cell.yuebanDetail = self.yuebanDetail;
            }
            
            
        }];

    }
    
    return 72;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return isMe?@"想去的好友":@"发起人";
    }
    if(section == 2){
        return isMe?@"想去的其他人":@"想去的人";
    }
    return @"";
}


- (IBAction)stopInviteBtn:(id)sender {
}

- (IBAction)ignoreInviteClick:(id)sender {
}

- (IBAction)wantGoClick:(id)sender {
}
- (IBAction)backBtnClick:(id)sender {
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [UIView animateWithDuration:0.5    animations:^{
        CGRect frame=appWindow.frame;
        frame.origin.y=kScreenHeight;
        self.frame=frame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}
-(void)getYueBanDetailWithId{
    
    NSLog(@"HSFrientListViewController-initData");
    
    //初始化空数组
    self.yuebanUserInfo = [[HSYueBanUserInfoList alloc]init];
    self.yuebanDetail = [[HSMyYueBanDetailList alloc]init];
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    if(!user_token){
        NSLog(@"user_token为空，无法获取列表！");
        return;
    }

//    self.yuebanId = @"20";
    

    if (!self.yuebanDetail.yueban_id) {
        return;
    }
    NSDictionary* dic =   @{@"user_token":user_token,@"yueban_id":self.yuebanDetail.yueban_id};
   
    
        //将请求参数封装到requestData中
        NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        //    NSLog(@"%@",requestData);
        //向后台请求数据
        [self.requestDataCtrl getYueBanDetail:requestData andRequestCB:^(BOOL code, id object, NSString *error) {
            //        NSLog(@"%d",code);
            //
            //        NSLog(@"%@",object);
            self.yuebanDetail = [[HSMyYueBanDetailList alloc]initWithDic:object];
            
            //        NSLog(@"%@",self.yuebanDetail);
            self.friendsArray = [[NSMutableArray alloc]initWithArray:self.yuebanDetail.friendsArray];
            self.strangersArray = [[NSMutableArray alloc]initWithArray:self.yuebanDetail.strangersArray];
            //        NSLog(@"%@",self.strangersArray);
            //        NSLog(@"%@",self.friendsArray);
            //
            //        NSLog(@"%@",error);
            
            [MyYueBanListTableView reloadData];
        }];
    

}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (instancetype)initWithYueBanID:(NSString *)yueBanID {
//    if (self = [super init]) {
//
//        self = [self init];
//        _yuebanDetail.yueban_id = yueBanID;
//        [self getYueBanDetailWithId];
//
////        NSLog(@"initWithYueBanID %@",yueBanID);

//    }
    
    self = [self init];
    _yuebanDetail.yueban_id = yueBanID;
    [self getYueBanDetailWithId];

    return self;
}



@end
