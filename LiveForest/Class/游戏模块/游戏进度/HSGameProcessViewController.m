//
//  HSGameProcessViewController.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/9/9.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSGameProcessViewController.h"
#import "ServiceHeader.h"//引入服务头文件
#import "HSScaleScrollView.h"

@interface HSGameProcessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *lookDetailBtn;

@end

@implementation HSGameProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpView];
    [self getData];
    [self setUpTapToScaleLargeBtn];
    
}

- (void)setUpView {
    self.view.frame = [UIScreen mainScreen].bounds;
    self.lookDetailBtn.layer.cornerRadius = 15;
    self.lookDetailBtn.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setEnergyNumber:(NSString *)energyNumber{
    _energyNumber = energyNumber;
    self.energyLabel.text = energyNumber;
}

-(void)setActivityNumber:(NSString *)activityNumber{
    _activityNumber = activityNumber;
    _activityLabel.text  = activityNumber;
}

-(void)getData{
    self.requestDataCtrl = [[HSRequestDataController alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    
    if(!user_token){
        NSLog(@"user_token为空，无法获取列表！");
        return;
    }
//    user_token = @"m4QIyZxSyoXOMppBXT2XUm1j2BHlNug7cnq8hXBy2eps3D";
    NSDictionary* dic =   @{@"user_token":user_token};
    
    //将请求参数封装到requestData中
    NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    
    [self.requestDataCtrl getTaskTargetAndInteractionValue:requestData andRequestCB:^(BOOL code, id object, NSString *error) {
        NSLog(@"%@",object);
        if (code) {
            
            //获取当前的缓存中的能量值
            NSString* todaySingleRecordKey = [NSString stringWithFormat:@"singleGameRecord%@",[HSDataFormatHandle getTodayDate]];
            
            NSString *energyStr;
            
            //判断是否存在今日的记录
            if([userDefaults objectForKey:todaySingleRecordKey]){
                //如果存在则赋值
                energyStr =[NSString stringWithFormat:@"%@",todaySingleRecordKey];
            }else{
                //否则默认为0
                energyStr = @"0";
            }
            
            //获取当前的互动值
            NSString *activityStr = [NSString stringWithFormat:@"%@",[object objectForKey:@"interaction_value"]];
            
            self.energyLabel.text = energyStr;
            self.activityLabel.text = activityStr;
            
            
            int unlock_planet_num = [[object objectForKey:@"unlock_planet_num"] intValue] +1;
            NSString *imageName = [NSString stringWithFormat:@"星球 %d",unlock_planet_num];
            self.planetImageView.image = [UIImage imageNamed:imageName];
            
            self.planetLabel.text = [NSString stringWithFormat:@"最后结锁第 %d星球",unlock_planet_num];
        }
        
    }];
}

- (IBAction)lookDetailBtnClick:(id)sender {
    //Test 测试分享服务
    //    [[SocialService sharedInstance] doSocialShareWithContent:@"测试" AndHref:@"http://baidu.com" WithCallBack:^(bool code) {
    //        NSLog(@"%@",code);
    //    }];
    
    //启动Cordova服务
    [[CordovaService getSingletonInstance] startPage:@"game.html" fromViewController:self];
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
    
    [scaleScrollView scaleFromIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
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
