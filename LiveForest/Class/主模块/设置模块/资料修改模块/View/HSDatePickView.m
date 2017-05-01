//
//  HSDatePickView.m
//  LiveForest
//
//  Created by wangfei on 7/7/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSDatePickView.h"
@interface HSDatePickView()
@property (nonatomic, strong) UIDatePicker *dataPicker;
@property (nonatomic,strong) UIView *toolView;
@end
@implementation HSDatePickView


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [self addSubview:self.dataPicker];
        [self addSubview:self.toolView];
        //设置灰色透明
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
    }
    return self;
}
-(UIDatePicker *)dataPicker
{
    if (_dataPicker == nil) {
        _dataPicker = [[UIDatePicker alloc]init];
        CGFloat dataPickerH = _dataPicker.bounds.size.height;
        CGFloat dataPickerY = self.bounds.size.height - dataPickerH;
        _dataPicker.frame = CGRectMake(0, dataPickerY,self.bounds.size.width,dataPickerH);
        _dataPicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:@"1990-06-15"];
        //最大日期今天
        _dataPicker.maximumDate = [NSDate date];
        _dataPicker.date = date;
        
    
        _dataPicker.backgroundColor = [UIColor whiteColor];
    }
    return _dataPicker;
}
-(UIView *)toolView
{
    if (_toolView == nil) {
        CGFloat toolViewH = 44;
        CGFloat toolViewY = self.bounds.size.height - toolViewH - self.dataPicker.bounds.size.height;
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, toolViewY, self.bounds.size.width, toolViewH)];
        _toolView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        CGFloat padding = 10;
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(padding, 0, toolViewH, toolViewH)];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(doneClickClose) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:leftButton];
        CGFloat rightButtonX = _toolView.bounds.size.width - padding - toolViewH;
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(rightButtonX, 0, toolViewH, toolViewH)];
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(doneClickSave) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:rightButton];
        
        //中间信息描述
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, toolViewH)];
        
        label.center = CGPointMake(_toolView.bounds.size.width * 0.5,_toolView.bounds.size.height * 0.5);
        label.text = @"出生日期选择";
        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [_toolView addSubview:label];
    }
    return _toolView;
}
/**
 *  关闭选项框
 */
-(void)doneClickClose
{
    [self remove];
}
/**
 *  点击保存，通知Controller修改tableView中的值和后台
 */
-(void)doneClickSave
{

    NSDate *pickerDate = self.dataPicker.date;
    
    //NSDate格式转换为NSString格式
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    
    //通知tableViewController去修改cell的内容
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:dateString forKey:@"dateString"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickSaveBirthday" object:self userInfo:dictM];
    //关闭
    [self remove];
    
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
#pragma mark - 点击背景关闭
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self remove];
}
-(void)remove
{
    [self removeFromSuperview];
}
@end
