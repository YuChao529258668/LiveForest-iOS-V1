//
//  HSGameChartsViewController.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameChartsViewController.h"
#import "HSGameChartsTableViewCell.h"
#import "HSRequestDataController.h"
#import "HSGameChartsModel.h"
#import "HSVisitMineController.h"

@interface HSGameChartsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *gameChartsModels;
@end

@implementation HSGameChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpTableView];
    [self getData];
    [self setUpTapToScaleLargeBtn];

    
//    [self performSelector:@selector(test) withObject:nil afterDelay:3.0];
}
//- (void)test {
//    [self.gameChartsTableView reloadData];
//}
- (void)setUpTableView {
    [self.gameChartsTableView registerNib:[UINib nibWithNibName:[HSGameChartsTableViewCell ID] bundle:nil] forCellReuseIdentifier:[HSGameChartsTableViewCell ID]];
    self.gameChartsTableView.delegate = self;
    self.gameChartsTableView.dataSource = self;
}


- (void)getData {
    
    // 用于演示
    self.gameChartsModels = [HSGameChartsModel test];
    [self.gameChartsTableView reloadData];
    return;
    
    
    [[[HSRequestDataController alloc]init] getMyScoreRankWithCallBack:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            self.gameChartsModels = [HSGameChartsModel gameChartsModelsWithDictionary:responseObject];
            [self.gameChartsTableView reloadData];
        } else {
            NSLog(@"%s,%@",__func__,error);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gameChartsModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSGameChartsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSGameChartsTableViewCell ID] forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [HSGameChartsTableViewCell gameCell];
//    }

    NSLog(@"%@",[self.gameChartsModels[indexPath.row]class]);

    cell.gameChartsModel = self.gameChartsModels[indexPath.row];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGameChartsModel *gameChartsModel = self.gameChartsModels[indexPath.row];
    NSString *userID = gameChartsModel.user_id;
    HSVisitMineController *_visitMineVC = [[HSVisitMineController alloc]init];
    
    [_visitMineVC requestPersonalInfoWithUserID:userID];
    [self presentViewController:_visitMineVC animated:YES completion:nil];
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
    
    [scaleScrollView scaleFromIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
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
