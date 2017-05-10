//
//  HSYueBanDetailViewController.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSYueBanDetailViewController.h"
#import "HSMyMyYueBanDetailListView.h"
#import "HSYueBanListTopTableViewCell.h"
#import "HSYueBanDetailTableViewCell.h"
#import "HSRequestDataController.h"
#import "HSVisitMineController.h"

#import "HSRecordTool.h"

@interface HSYueBanDetailViewController ()
@property(strong,nonatomic)UIActivityIndicatorView *loading;
/**
 *  播放语音
 */
@property (nonatomic, strong)HSRecordTool *recordTool;

@end


@implementation HSYueBanDetailViewController
@synthesize MyYueBanListTableView;
@synthesize isMe;
@synthesize loading;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"";
    MyYueBanListTableView.alpha = 0;
    
// Do any additional setup after loading the view from its nib.
    
//    MyYueBanListTableView = [[UITableView alloc]init];
//    MyYueBanListTableView.backgroundColor = [UIColor redColor];
    
    [MyYueBanListTableView registerNib:[UINib nibWithNibName:@"HSYueBanDetailTableViewCell" bundle:nil] forCellReuseIdentifier:[HSYueBanDetailTableViewCell ID]];
    [MyYueBanListTableView registerNib:[UINib nibWithNibName:@"HSYueBanListTopTableViewCell" bundle:nil] forCellReuseIdentifier:[HSYueBanListTopTableViewCell ID]];
    MyYueBanListTableView.delegate = self;
    MyYueBanListTableView.dataSource = self;
    
    
    self.requestDataCtrl = [[HSRequestDataController alloc]init];

//    [self getYueBanDetailWithId];

    
    self.ignoreInviteBtn.hidden = YES;
    self.wantGoBtn.hidden = YES;
    self.stopInviteBtn.hidden = YES;
    
    [self getYueBanDetailWithId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger num = 0;
    if (self.friendsArray.count >0) {
        num++;
    }
    if (self.strangersArray.count >0) {
        num++;
    }
//    num++;
    return ++num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.friendsArray.count;
    }
    if (section == 2) {
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
        if (self.yuebanDetail) {
            cell.yuebanDetail = self.yuebanDetail;  
        }
        [cell.voiceInfoBtn addTarget:self action:@selector(voiceInfoBtnPress:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
    }
    
    HSYueBanDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSYueBanDetailTableViewCell ID] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [HSYueBanDetailTableViewCell yueBaneListCell];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSYueBanUserInfoList *info  = [[HSYueBanUserInfoList alloc]init];
    if(indexPath.section == 0){
        return;
    }
    if (indexPath.section == 1) {
        info  = self.friendsArray[indexPath.row];
    }
    if (indexPath.section == 2) {
        info = self.strangersArray[indexPath.row];
    }
//    static HSVisitMineController *vmvc;
//    vmvc = [[HSVisitMineController alloc]init];
//    [vmvc requestPersonalInfoWithUserID:info.user_id];
//    [[UIApplication sharedApplication].keyWindow addSubview:vmvc.view];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        if ([self.yuebanDetail.is_mine isEqualToString:@"1"]) {
            return @"想去的好友";
        }
        return @"发起人";
    }
    if(section == 2){
        if ([self.yuebanDetail.is_mine isEqualToString:@"1"]) {
            return @"想去的其他人";
        }
        return @"想去的人";
    }
    return @"";
}


- (IBAction)stopInviteBtn:(id)sender {
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    if(!user_token){
        NSLog(@"user_token为空，无法获取列表！");
        return;
    }
    if (!self.yuebanDetail.yueban_id) {
        return;
    }
    NSDictionary* dic =   @{@"user_token":user_token,@"yueban_id":self.yuebanDetail.yueban_id};
    
    //将请求参数封装到requestData中
    NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    //向后台请求数据
    [self.requestDataCtrl doYueBanStopByUser:requestData andRequestCB:^(BOOL code, NSString *error) {
        if (code) {
        //发通知
            if(code){
                NSLog(@"停止邀请成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"stopYuebanSuccess" object:nil];

                ShowHud(@"停止邀请成功", NO);
//                [self pop:nil];
//                跳转到上个界面
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            else{
                NSLog(@"异常%@",error);
                 ShowHud(@"停止邀请失败", NO);
            }
            
            
            
        }
        
    }];
}

- (IBAction)ignoreInviteClick:(id)sender {
    [self.delegate refuseBtnClickWithYueBanID:self.yuebanDetail.yueban_id];

    
}
//yueban_user_state:String	M	约伴用户状态'1':参加，'0':拒绝
- (IBAction)wantGoClick:(id)sender {    
    [self.delegate agreeBtnClickWithYueBanID:self.yuebanDetail.yueban_id];
}
- (IBAction)backBtnClick:(id)sender {
    //释放 播放语音的东西
    [_recordTool destructionRecordingFile];
    
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"click back button");
    }];
}


-(void)getYueBanDetailWithId{
    
//    NSLog(@"HSFrientListViewController-initData");
    
    //初始化空数组
    self.yuebanUserInfo = [[HSYueBanUserInfoList alloc]init];
    
    // 用于演示
    self.yuebanDetail = [HSMyYueBanDetailList test];
    [self hangleData];
    return;
    
    
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    if(!user_token){
        NSLog(@"user_token为空，无法获取列表！");
        return;
    }
    if (!self.yuebanDetail.yueban_id) {
        return;
    }
        NSDictionary* dic =   @{@"user_token":user_token,@"yueban_id":self.yuebanDetail.yueban_id};
        
        //将请求参数封装到requestData中
        NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        //向后台请求数据
        [self.requestDataCtrl getYueBanDetail:requestData andRequestCB:^(BOOL code, id object, NSString *error) {
//            NSLog(@"%@",object);

            if(!code){
                NSLog(@"请求数据出错");
            }else{
                self.yuebanDetail = [[HSMyYueBanDetailList alloc]initWithDic:object];

                [self hangleData];
            }
        }];
}

- (void)hangleData {
    
    self.friendsArray = [[NSMutableArray alloc]initWithArray:self.yuebanDetail.friendsArray];
    self.strangersArray = [[NSMutableArray alloc]initWithArray:self.yuebanDetail.strangersArray];
    NSString *isMe1 = [NSString stringWithFormat:@"%@",self.yuebanDetail.is_mine];
    if([isMe1 isEqualToString:@"1"]){
        
        self.stopInviteBtn.hidden = NO;
    }
    
    if(!self.isDeal ){
        
        if ([isMe1 isEqualToString:@"0"]) {
            self.ignoreInviteBtn.hidden = NO;
            self.wantGoBtn.hidden = NO;
            
        }
    }
    
    MyYueBanListTableView.alpha = 1.0;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MyYueBanListTableView reloadData];
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
}

- (instancetype)initWithYueBanID:(NSString *)yueBanID {
//    if (yueBanID) {
//        NSLog(@"initWithYueBanID %@",yueBanID);
//
//    }
    if (self = [super init]) {
        self = [self init];
        self.isDeal = NO;
        _yuebanDetail = [[HSMyYueBanDetailList alloc]init];
        _yuebanDetail.yueban_id = yueBanID;
//        [self getYueBanDetailWithId];
        
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 约伴语音播放
- (void)voiceInfoBtnPress:(UIButton *)btn{
    
    _recordTool = [[HSRecordTool alloc]init];
    
    //amr语音路径
    self.recordTool.recordFileAMRUrl = [[NSURL alloc]initWithString:[HSDataFormatHandle encodeURL:_yuebanDetail.yueban_voice_info]];

    //播放
    [self.recordTool playAmrRecordFile];
}
@end
