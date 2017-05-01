//
//  HSYuebanTimeSelect.m
//  LiveForest
//
//  Created by wangfei on 8/6/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSYuebanTimeSelect.h"
@interface HSYuebanTimeSelect()
/**
 *  时间选择
 */
@property (nonatomic, strong) UIDatePicker *dataPicker;
/**
 *  上面的工具栏
 */
@property (nonatomic,strong) UIView *toolView;

/**
 *  用户当前选择的时间间隔
 */
@property (nonatomic, assign) double timeDuration;
@end
@implementation HSYuebanTimeSelect


-(instancetype)initWithtimeDuration:(double)timeDuration
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.timeDuration = timeDuration;
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [self addSubview:self.dataPicker];
        [self addSubview:self.toolView];
        
    }
    return self;
}
-(UIDatePicker *)dataPicker
{
    if (_dataPicker == nil) {
        _dataPicker = [[UIDatePicker alloc]init];
        CGFloat dataPickerH = _dataPicker.bounds.size.height;
        CGFloat dataPickerY = self.bounds.size.height - dataPickerH;
        _dataPicker.frame = CGRectMake(0, dataPickerY,_dataPicker.bounds.size.width,dataPickerH);
        _dataPicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _dataPicker.datePickerMode = UIDatePickerModeCountDownTimer;
        
        _dataPicker.countDownDuration = self.timeDuration;
        
        
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
        label.text = @"约伴有效时间选择";
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
    
    NSTimeInterval pickerTimer = self.dataPicker.countDownDuration;
    
    //通知上个页面去修改label的内容
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:[NSNumber numberWithDouble:pickerTimer] forKey:@"pickerTimer"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickSaveTime" object:self userInfo:dictM];
    //关闭
    [self remove];
    
}

-(void)show
{
    //取出当前的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    [window addSubview:self];
    
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
