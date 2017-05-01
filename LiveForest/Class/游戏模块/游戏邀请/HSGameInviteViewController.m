//
//  HSGameInviteViewController.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameInviteViewController.h"
#import "HSRequestDataController.h"
#import "HSGameInviteTableViewCell.h"
#import "HSGameInviteModel.h"
#import "HSScaleScrollView.h"

@interface HSGameInviteViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *gameInviteModels;

@end


@implementation HSGameInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpTableView];
    [self getData];
    [self setUpTapToScaleLargeBtn];
}

- (void)setUpTableView {
    self.gameInviteTableView.delegate = self;
    self.gameInviteTableView.dataSource = self;
    [self.gameInviteTableView registerNib:[UINib nibWithNibName:[HSGameInviteTableViewCell ID] bundle:nil] forCellReuseIdentifier:[HSGameInviteTableViewCell ID]];
}

- (void)getData {
    [[[HSRequestDataController alloc]init] getMyInvitationListWithCallBack:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
//            NSLog(@"%@",responseObject);
            self.gameInviteModels = [HSGameInviteModel gameInviteModelsWitDictionary:responseObject];
            [self.gameInviteTableView reloadData];
            self.inviteCountLabel.text = [NSString stringWithFormat:@"%ld条好友邀请游戏",self.gameInviteModels.count];
        } else {
            NSLog(@"%s,%@",__func__,error);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gameInviteModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSGameInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSGameInviteTableViewCell ID] forIndexPath:indexPath];
    
    cell.gameInviteModel = self.gameInviteModels[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - Table view delegate
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //todo
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 点击放大模块
- (void)setUpTapToScaleLargeBtn {
    HSScaleScrollView *scaleScrollView = [self getScaleScrollView];
    //本来先创建子视图再创建父视图，所以要等0.5秒，父视图创建好后再创建子视图。
    if (!scaleScrollView) {
        [self performSelector:@selector(setUpTapToScaleLargeBtn) withObject:nil afterDelay:0.5];
        return;
    }
    
    //创建点击放大Cell的按钮，覆盖整个Cell
    UIButton *tapToScaleLargeBtn  = [[UIButton alloc]initWithFrame:self.view.frame];
    [tapToScaleLargeBtn addTarget:self
                           action:@selector(tapToScaleLargeBtnClick)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tapToScaleLargeBtn];
    
    
    //缩放后的回调
    [scaleScrollView.didScaleToSmallHandlerArray addObject:^(){
        tapToScaleLargeBtn.hidden = NO;//显示点击放大Cell的按钮
    }];
    [scaleScrollView.didScaleToLargeHandlerArray addObject:^(){
        tapToScaleLargeBtn.hidden = YES;//隐藏点击放大Cell的按钮
    }];
}

- (void)tapToScaleLargeBtnClick {
    HSScaleScrollView *scaleScrollView = [self getScaleScrollView];
    
    [scaleScrollView scaleFromIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
}

- (HSScaleScrollView *)getScaleScrollView {
    HSScaleScrollView *scaleScrollView;
    for (UIView *sv = self.view.superview; sv; sv = sv.superview) {
        if ([sv isKindOfClass:HSScaleScrollView.class]) {
            scaleScrollView = (HSScaleScrollView *)sv;
            break;
        }
    }
    return scaleScrollView;
}

@end
