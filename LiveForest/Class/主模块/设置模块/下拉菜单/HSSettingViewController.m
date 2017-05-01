//
//  HSSettingViewController.m
//  LiveForest
//
//  Created by Swift on 15/5/10.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSSettingViewController.h"
#import "HSSettingPersonalViewController.h"
#import "HSMineController.h"//5.15

//ByQinag on 4.14
#import "CollectionViewController.h"

@interface HSSettingViewController ()
@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) UITableViewCell *lastCell;
//@property (strong, nonatomic) UINavigationController *myNavigationController;

@property (strong, nonatomic) UIViewController *tmp;//反馈控制器

@property (strong, nonatomic) HSMineController *mineController;  //个人主页

//@property (strong, nonatomic) UIViewController *currentVC;

@end

@implementation HSSettingViewController

@synthesize array;
@synthesize settingTableView;
@synthesize lastCell;
//@synthesize myNavigationController;
@synthesize tmp;

float cellHeight=75;//行高
int cellNumber=5;//定义行数

#pragma mark
//初始化数组
- (void)initArray {
    array=[[NSMutableArray alloc]initWithObjects:@"个人主页",@"栏目选择",@"设置",@"扫描二维码",@"邀请好友", nil];
    
}

//初始化tableview
- (void)initSettingTableView {
    CGRect frame=[UIScreen mainScreen].bounds;
//    frame.origin.y+=[[UIApplication sharedApplication] statusBarFrame].size.height;
    settingTableView =[[ UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    settingTableView.delegate=self;
    settingTableView.dataSource=self;
    //背景图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    //获取个人信息控制器
    self.userInfoControl = [[HSUserInfoHandler alloc]init];
    
    //获取用户后人信息
    [self.userInfoControl getUserInfoAndSaveHandler:^(BOOL completion){
        if(completion){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //判断是否已经有个人信息
            if([userDefaults objectForKey:@"user_logo_blurImg"]){
                
                //设置用户头像
                imageView.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_blurImg"]];
            
                
            }
            else{
                imageView.image=[UIImage imageNamed:@"HomeBlur.png"];
            }
        }
    }];
   
    // 注意，日后修改
    imageView.image=[UIImage imageNamed:@"HomeBlur.png"];

    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    settingTableView.backgroundColor=[UIColor clearColor];
//    [settingTableView.backgroundView addSubview:imageView];
//    [settingTableView addSubview:imageView];
    settingTableView.backgroundView = imageView;
//    settingTableView 
    [self.view addSubview:settingTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    
    [self initArray];
    [self initSettingTableView];
    
    //屏幕适配
    int width=[UIScreen mainScreen].bounds.size.width;
    float factor;
    switch (width) {
        case 320:
            factor = 1;
            break;
        case 375:
            factor = 1.17;
            break;
        case 414:
            factor = 1.32;
            break;
            
        default:
            factor = 1.17;
            break;
    }
//    self.view.transform = CGAffineTransformMakeScale(factor, factor);
//    //调整位置
//    CGRect newFrame = self.view.frame;
//    newFrame.origin=CGPointZero;
//    self.view.frame=newFrame;
    
    cellHeight=75*factor;
    
//    _mineController=[[HSMineController alloc]init];
//    _mineController.view.frame=[UIScreen mainScreen].bounds;
//    _mineController.mineView.frame=[UIScreen mainScreen].bounds;
//    [_mineController.view addSubview:_mineController.mineView];
//    [_mineController.view insertSubview:_mineController.scrollView aboveSubview:_mineController.mineView];
//    [self addChildViewController:_mineController];
//
//    
//    self.currentVC = [[HSSettingPersonalViewController alloc] init];
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //无法修改cell自带的控件的frame
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    
    CGRect frame=[UIScreen mainScreen].bounds;
    frame.size.height=cellHeight;

    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=array[indexPath.row];
    label.textAlignment=NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = [UIColor whiteColor];
//    label.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:label];
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row==0) {

        CGRect imageFrame=CGRectMake(10, 0, cellHeight, cellHeight);
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageFrame];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //判断是否已经有个人信息
        if([userDefaults objectForKey:@"user_logo_img"] ){
            
            imageView.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
        }
        else{
            imageView.image=[UIImage imageNamed:@"Home.jpg"];
        }
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.transform=CGAffineTransformMakeScale(0.9, 0.9);
        //圆形头像
//        imageView.layer.cornerRadius = imageView.frame.size.width/2;
//        imageView.clipsToBounds = YES;
//        UIGraphicsBeginImageContext(imageView.frame.size);
//        [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        cell.imageView.image=scaleImage;
        
        [cell.contentView addSubview:imageView];
        
        
    }
    
    if (indexPath.row==cellNumber-1) {
        lastCell=cell; //用来计算tableView的高度
    }
    
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

//返回setting tableView的高度
- (float)getSettingViewHeight {
//    float height=0;
//    height=ce
//    return height;
//    return settingTableView.contentSize.height;
    return lastCell.frame.origin.y+cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //个人主页
    if (indexPath.row==0) {
        //大坑。。。frame是x=640。。。
//        HSMineController *mineController=[[HSMineController alloc]init];
//        mineController.view.frame=[UIScreen mainScreen].bounds;
//        mineController.mineView.frame=[UIScreen mainScreen].bounds;
//        [mineController.view addSubview:mineController.mineView];
//        [mineController.view insertSubview:mineController.scrollView aboveSubview:mineController.mineView];
//        [self addChildViewController:mineController];

        _mineController=[[HSMineController alloc]init];
        _mineController.view.frame=[UIScreen mainScreen].bounds;
        _mineController.mineView.frame=[UIScreen mainScreen].bounds;
        [_mineController.view addSubview:_mineController.mineView];
        [_mineController.view insertSubview:_mineController.scrollView aboveSubview:_mineController.mineView];
//        [self addChildViewController:_mineController];
//217
//        [self transitionFromViewController:self.currentVC toViewController:_mineController duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//
//        }  completion:^(BOOL finished) {
//            //......
//        }];
        
//        [[UIApplication sharedApplication].keyWindow addSubview:mineController.view];
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:mineController.mineView];
//        NSLog(@"%@",NSStringFromCGRect(mineController.mineView.frame));
//        [self presentViewController:mineController animated:YES completion:nil];
//        liqiang
//        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
////        [self.view removeFromSuperview];
//        CGRect frame=self.view.frame;
//        //上下平移
//        frame.origin.y = 0;
//        appWindow.rootViewController.view.frame = frame;
////
//        [appWindow insertSubview:_mineController.view aboveSubview:appWindow.rootViewController.view];
//
        [self show:_mineController.view];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_mineController animated:YES completion:nil];//现在用的
//        [self.view removeFromSuperview];
        //        [appWindow.rootViewController presentViewController:collectionView animated:YES completion:nil];

    }

    //自定义模块
    if(indexPath.row == 1){
        //发布蒲公英注释一下
//        CollectionViewController *collectionView = [[CollectionViewController alloc] init];
//        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 36, 36)];
////        back.backgroundColor=[UIColor grayColor];
//        //            [back setTitle:@"返回" forState:UIControlStateNormal];
//        //            [back setBackgroundColor:[UIColor redColor]];
//        [back setImage:[UIImage imageNamed:@"ic_arrow_back_white_48dp"] forState:UIControlStateNormal];
//        [back addTarget:self action:@selector(backCustomizeView) forControlEvents:UIControlEventTouchUpInside];
//        
//        [collectionView.view addSubview:back];
//        [appWindow.rootViewController presentViewController:collectionView animated:YES completion:nil];
////        [appWindow insertSubview:collectionView.view aboveSubview:appWindow.rootViewController.view];
        
        
        
        //7.31
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"敬请期待" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [av show];
    }
    
    //设置详情
    if (indexPath.row==2) {
//        HSSettingPersonalViewController *spvc=[[HSSettingPersonalViewController alloc]init];
//        [self presentViewController:spvc animated:YES completion:nil];
////        self.myNavigationController =[[UINavigationController alloc]init];
////        [self.myNavigationController pushViewController:spvc animated:YES];
////        [self.view addSubview:self.myNavigationController.view];
        
        
        //尝试用故事板
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        //todo
        UIViewController *vc=[sb instantiateViewControllerWithIdentifier:@"SettingPersonalViewController"];
//        [self presentViewController: vc animated:YES completion:nil];
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:vc animated:YES completion:nil];
//        [self presentViewController:vc animated:YES completion:nil];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //添加好友
    if(indexPath.row == 3){

        //扫描二维码
        _qrVC = [[QRViewController alloc]init];
        [self show:_qrVC.view];
//        UIWindow *appWindow = [[[UIApplication sharedApplication] delegate] window];
//        CGRect frame=self.view.frame;
//        //上下平移
//        frame.origin.y = 0;
//        appWindow.rootViewController.view.frame = frame;

//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_qrVC];

//        CGRect qrVCFrame=self.view.frame;
//        qrVCFrame.origin.y = kScreenHeight;
//        _qrVC.view.frame = qrVCFrame;
//        [appWindow insertSubview:_qrVC.view aboveSubview:appWindow.rootViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect viewFram = self.view.frame;
//            viewFram.origin.y = 0;
//            _qrVC.view.frame = viewFram;
//            
//            appWindow.rootViewController.view.frame = viewFram;
//
//        } completion:^(BOOL finished) {
//        }];

    }
    if(indexPath.row == 4){
        static HSQRDisplayVC *qr;
        qr = [[HSQRDisplayVC alloc] init];
        [self show:qr.view];
//        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
////        CGRect frame=self.view.frame;
////        //上下平移
////        frame.origin.y = 0;
////        appWindow.rootViewController.view.frame = frame;
//        //    [self.view removeFromSuperview];
////        [appWindow.rootViewController presentViewController:qr animated:YES completion:nil];
////        [appWindow insertSubview:qr.view aboveSubview:appWindow.rootViewController.view];
//        
//        CGRect qrVCFrame=self.view.frame;
//        qrVCFrame.origin.y = kScreenHeight;
//        qr.view.frame = qrVCFrame;
//        [appWindow insertSubview:qr.view aboveSubview:appWindow.rootViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect viewFram = self.view.frame;
//            viewFram.origin.y = 0;
//            qr.view.frame = viewFram;
//            
//            appWindow.rootViewController.view.frame = viewFram;
//            
//        } completion:^(BOOL finished) {
//        }];

    }
}

#pragma mark feedbackBack
- (void)feedbackBack{
    [tmp dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark backCustomizeView
-(void)backCustomizeView{
    
    //todo  important
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    [self.view removeFromSuperview];
    [appWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)show:(UIView *)view{
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    //            [appWindow insertSubview:offView.view aboveSubview:appWindow.rootViewController.view];
    
    CGRect frame=appWindow.frame;
    frame.origin.y=kScreenHeight;
    view.frame=frame;
    [appWindow insertSubview:view aboveSubview:appWindow.rootViewController.view];

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=appWindow.frame;
        frame.origin.y=0;
        view.frame=frame;
        appWindow.rootViewController.view.frame = frame;
    }completion:^(BOOL finished) {
    }];

}

@end
