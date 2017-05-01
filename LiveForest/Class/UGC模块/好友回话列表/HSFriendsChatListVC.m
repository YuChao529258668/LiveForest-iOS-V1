//
//  HSFriendsChatListVC.m
//  LiveForest
//
//  Created by 傲男 on 15/7/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSFriendsChatListVC.h"

@interface HSFriendsChatListVC ()

@end

@implementation HSFriendsChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    self.title = @"navigationcontroller";//设置navigationbar上显示的标题
    [self.navigationController.navigationBar setBarTintColor:[UIColor purpleColor]];//设置navigationbar的颜色
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:Nil];//设置navigationbar左边按钮
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:Nil];//设置navigationbar右边按钮
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置navigationbar上左右按钮字体颜色
//self.na
    
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
//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
//    conversationVC.title =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
@end
