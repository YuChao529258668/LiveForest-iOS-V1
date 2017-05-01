
//
//  HSOnGoingGameViewController.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSOnGoingGameViewController.h"
#import "ServiceHeader.h"//引入服务头文件
#import "HSScaleScrollView.h"

@interface HSOnGoingGameViewController ()

@property (weak, nonatomic) IBOutlet UIButton *continueGameBtn;

@end

@implementation HSOnGoingGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpView];
    [self getData];
    [self setUpTapToScaleLargeBtn];
    
}

- (void)setUpView {
    self.view.frame = [UIScreen mainScreen].bounds;
    self.continueGameBtn.layer.cornerRadius = 25;
    self.continueGameBtn.clipsToBounds = YES;
}

-(void)getData{
    self.requestDataCtrl = [[HSRequestDataController alloc]init];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"]){
        return;
    }

    NSString *user_token = [[NSString alloc]initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
//    user_token = @"qnZ5awrOszYd1iFb3iLF9FfewEutl5uZZ2u12o73Poo3D";
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",nil];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    NSLog(@"%@",requestData);
    

    [self.requestDataCtrl getMyCurrentMultiGameInfo:requestData andRequestCB:^(BOOL code, id object, NSString *error) {
        NSLog(@"%@",object);
        if (code) {
            if ([object objectForKey:@"multiGameInfo"]) {
                self.onGoingDetailLabel.text = @"你还有一个多人模式任务没有完成，快回来带领小L和小F一起解放星球把！！！！";
            }
        }
    }];
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

- (IBAction)continueGameButtonClicked:(id)sender {
    
    //Test 测试分享服务
    //    [[SocialService sharedInstance] doSocialShareWithContent:@"测试" AndHref:@"http://baidu.com" WithCallBack:^(bool code) {
    //        NSLog(@"%@",code);
    //    }];
    
    //启动Cordova服务
    [[CordovaService getSingletonInstance] startPage:@"game.html" fromViewController:self];
    
}

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
    
    [scaleScrollView scaleFromIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
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
