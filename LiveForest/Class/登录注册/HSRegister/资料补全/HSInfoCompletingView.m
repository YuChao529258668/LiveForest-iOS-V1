//
//  HSInfoCompletingView.m
//  LiveForest
//
//  Created by 傲男 on 15/6/21.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSInfoCompletingView.h"
#import "HSDatePickView.h"
#import "HSPickView.h"
#import "HSLabelSelectView.h"
#import "HSSportLabelCell.h"

@interface HSInfoCompletingView()<UITextFieldDelegate>

@end
@implementation HSInfoCompletingView

-(instancetype)init {
    self=[super init];
    if (self) {
        NSArray *arrayOfViews;
        
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HSInfoCompletingView" owner:self options:nil];
        
        self=arrayOfViews[0];
        //代理
        self.birthday.delegate = self;
        self.city.delegate = self;
        self.nickname.delegate = self;
        
        //监听通知 生日
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSaveBirthday:) name:@"didClickSaveBirthday" object:nil];
        //监听通知 城市
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSaveCity:) name:@"didClickSaveCity" object:nil];
        //监听通知 运动标签
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSportslabel:) name:@"showSportLabel" object:nil];
        //屏幕适配
        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;

        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
        //调整缩放后的位置
        CGRect frame=self.frame;
        frame.origin=CGPointZero;
        self.frame=frame;
        
        [self.sportButton addTarget:self action:@selector(editSportLabel) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    //键盘
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(txtFieldResign)];
    [self addGestureRecognizer:tap];
    
    //头像
    self.avarlImage.layer.cornerRadius=self.avarlImage.frame.size.width/2;
    self.avarlImage.clipsToBounds=YES;
    self.avarlImage.userInteractionEnabled = YES;
    self.avarlImage.contentMode = UIViewContentModeScaleAspectFill;
    //性别选择
    self.male = [[RadioButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.maleLabel.frame)+4, self.maleLabel.frame.origin.y, CGRectGetWidth(self.maleLabel.frame), CGRectGetHeight(self.maleLabel.frame))];
    [self.male setImage:[UIImage imageNamed:@"uncheckedRadioButton"] forState:UIControlStateNormal];
    [self.male setImage:[UIImage imageNamed:@"checkedRadioButton"] forState:UIControlStateSelected];
    [self addSubview:self.male];
    
    self.female = [[RadioButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.femaleLabel.frame)+4, self.femaleLabel.frame.origin.y, CGRectGetWidth(self.femaleLabel.frame), CGRectGetHeight(self.femaleLabel.frame))];
    [self.female setImage:[UIImage imageNamed:@"checkedRadioButton"] forState:UIControlStateSelected];
    [self.female setImage:[UIImage imageNamed:@"uncheckedRadioButton"] forState:UIControlStateNormal];
    [self addSubview:self.female];
    
    self.male.groupButtons = @[self.male,self.female];
    self.female.selected = YES;
    
    return self;
}

- (void) txtFieldResign{
    if([self.nickname isFirstResponder]){
        [self.nickname resignFirstResponder];
    }
    if([self.birthday isFirstResponder]){
        [self.birthday resignFirstResponder];
    }
    if([self.city isFirstResponder]){
        [self.city resignFirstResponder];
    }
}
#pragma mark -textField代理方法实现
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //1000--生日 1001
    if (textField.tag == 1000)
    {
        //打开生日复选框
        [self txtFieldResign];
        HSDatePickView *datePickView = [[HSDatePickView alloc]init];
        [datePickView show];
        
        return NO;
    }
    else if(textField.tag == 1001)
    {
        //打开地址
        [self txtFieldResign];
        HSPickView *cityPickView = [[HSPickView alloc]initWithFrame:self.frame Level:AreaLevelCity];
        [cityPickView show];
        return NO;
    }
    else
    {
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self txtFieldResign];
    return YES;
}

#pragma -mark 通知修改view的生日
-(void)clickSaveBirthday:(NSNotification *)noti
{
    self.birthday.text = noti.userInfo[@"dateString"];
}
#pragma -mark 修改城市
-(void)clickSaveCity:(NSNotification *)noti
{
    self.city.text = noti.userInfo[@"areaInfo"];
    self.cityID = noti.userInfo[@"areaID"];
}

#pragma -mark 打开运动标签选择页面
- (void)editSportLabel
{
    HSLabelSelectView *selectView = [[HSLabelSelectView alloc]initWithSelectedID:self.selectedSportID isSingleSelection:NO];
    [selectView show];
}
#pragma mark 通知显示页面运动标签
- (void)showSportslabel:(NSNotification *)noti
{
    //取出用户修改运动标签内容
    self.selectedSportID = noti.userInfo[@"selectedIDs"];
    //显示
    [self addSportLabelView:self.selectedSportID];
    
}
#pragma -mark 添加运动标签
- (void)addSportLabelView:(NSMutableArray *)selectedSportsIDs
{
    CGFloat x = self.sportButton.frame.origin.x + 5;
    CGFloat y = CGRectGetMaxY(self.sportButton.frame) + 5;
    CGFloat width = self.bounds.size.width - x;
    //移除已有的标签
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[HSSportLabelCell class]]) {
            [subView removeFromSuperview];
        }
    }
    //修改
    HSSportLabelCell *labelView = [[HSSportLabelCell alloc]initWithFrame:CGRectMake(x, y, width, 20) sportsID:selectedSportsIDs];
    [self addSubview:labelView];
}
/**
 *  移除通知
 */
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didClickSaveBirthday" object:nil];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didClickSaveCity" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showSportLabel" object:nil];
}

@end
