//
//  HSRegisterView.m
//  LiveForest
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSRegisterView.h"

@interface HSRegisterView()

@end

@implementation HSRegisterView

@synthesize parentViewController;

#pragma mark - LifeCycle

- (instancetype)init{

    //从关联的Xib文件中加载本视图
    NSArray* nibView =  [[NSBundle mainBundle]
                         loadNibNamed:@"HSRegisterView" owner:self options:nil];
    
    self = nibView[0];
    
    return self;
}

/**
 *@function 根据指定的类型创造界面
 **/
- (instancetype)initWithType:(NSString*)type{
    
    
    //加载当前Xib界面
    self = [self init];

    
    //如果是进入手机号注册界面
    if([type isEqualToString:@"register"]){
    
        
    
    }else if([type isEqualToString:@"bind"]){
    //如果是进入手机号绑定界面
        
        //修改页面显示值
        self.label_pageTitle.text = @"手机绑定";
        
        //修改当前按钮的默认显示值
        [self.button_doSubmit setTitle:@"绑定" forState:UIControlStateNormal];
    }
    
    
    return self;


}


#pragma mark - View LifeCycle

- (IBAction)onClick_buttonBack:(id)sender {
    
    //点击返回之后，退出当前UIViewController
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
}
@end
