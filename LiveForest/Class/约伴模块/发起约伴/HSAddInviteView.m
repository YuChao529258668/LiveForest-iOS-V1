//
//  HSAddInviteView.m
//  LiveForest
//
//  Created by wangfei on 8/4/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSAddInviteView.h"
#import "HSDropDownMenu.h"
#import "HSYuebanTimeSelect.h"
#import "Macros.h"
#import "HSRequestDataController.h"
#import "HSSportModel.h"
#import "HSRecordTool.h"
#import "MBProgressHUD.h"
#import "HSUpLoadToQiNiu.h"
#import <ShareSDK/ShareSDK.h>


@interface HSAddInviteView()<UITextFieldDelegate,HSRecordToolDelegate>{
    bool isVoiceBtn;
    bool voiceTimeOver;
    NSTimer *voiceTimer;
}

@property (nonatomic, strong)UIButton *backBtn;

@property (nonatomic, copy) NSString *sportID;
/**
 *  录音工具
 */
@property (nonatomic, strong)HSRecordTool *recordTool;
/**
 *  话筒显示图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *micImageView;

/**
 *  "1":邀请所有用户，现在就是随机20个用户，以后按照城市和运动类型筛选,"0":邀请我的好友，互粉的人
 */
@property (nonatomic, copy) NSString *yueban_recommend_type;

/**
 *  提交后台持续时间，ms。默认3600000ms
 */
@property (nonatomic,assign) long timeInterval;
/**
 *  七牛返回的语音路径
 */
@property (nonatomic, copy) NSString *qiuNiuRecordFileURL;
/**
 * 存储供用户选择的的运动标签
 */
@property (nonatomic, strong)NSArray *sportArray;
/**
 *  提交后台
 */
@property (nonatomic, strong)HSRequestDataController *requestDataCtrl;
@end
@implementation HSAddInviteView
/**
 *  录音时间
 */
static double recordCurrentTime;
-(instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"HSAddInviteView" owner:nil options:nil]firstObject];
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        //用button可以实现点击监听
        _backBtn = [[UIButton alloc]initWithFrame:self.frame];
        [_backBtn setBackgroundColor:[UIColor blackColor]];
        _backBtn.alpha = 0.1;
        [self insertSubview:self.backBtn belowSubview:self.backGroundImageView];
        //点击消失动画
        [_backBtn addTarget:self action:@selector(tapToDismiss) forControlEvents:UIControlEventTouchUpInside];

        //默认时间1小时,ms
        self.timeInterval = 3600 * 1000;
        
        self.requestDataCtrl = [[HSRequestDataController alloc]init];
        
        self.sportNameTF.delegate = self;
        self.yuebanDetailTF.delegate = self;
        //使他们下面的按钮事件失效
        [self.backGroundImageView setUserInteractionEnabled:YES];
        
        
        //按钮箭头变换通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDismiss) name:@"menuDidDismiss" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidShow) name:@"menuDidShow" object:nil];
        
        //选中运动通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedSport:) name:@"didSelectedSport" object:nil];
        
        //选中有效时间通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTimer:) name:@"didClickSaveTime" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                                  object:self.yuebanDetailTF];
        

        //添加滑动检测事件
        [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpOutside];
        
        //初始化 语音按钮是否被点击了
        isVoiceBtn = true;
        //初始化 录音时间是否超时
        voiceTimeOver = false;

    }
    return self;
}

- (void)layoutSubviews{
    //设置滑块图标图片
    [self.slider setThumbImage:[UIImage imageNamed:@"toggle"] forState:UIControlStateNormal];
    self.slider.minimumTrackTintColor = [UIColor clearColor];
    self.slider.maximumTrackTintColor = [UIColor clearColor];
}

#pragma mark slider事件检测
- (void)valueChanged:(UISlider *)sender {
    if (sender.value>0.5) {
        sender.value = 1;
    } else {
        sender.value = 0;
    }
}

- (IBAction)clickInviteFriends:(id)sender {
    
    //向左沿直线运动
    [UIView animateWithDuration:0.35 animations:^{
        self.slider.value = 0;
    } completion:nil];
}
- (IBAction)clickInviteAll:(id)sender {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.slider.value = 1;
    } completion:nil];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (HSRecordTool *)recordTool
{
    if (_recordTool == nil) {
        _recordTool = [HSRecordTool sharedRecordTool];
        _recordTool.delegate = self;
    }
    return _recordTool;
}
-(NSArray *)sportArray
{
    if (_sportArray == nil) {
        _sportArray = [HSSportModel sportModels];
    }
    return _sportArray;
}

/**
 *  点击消失
 */
- (void)tapToDismiss
{
    //如果用户有输入内容
//    if(self.sportNameTF.text.length != 0 || self.yuebanDetailTF.text.length != 0 || self.recordTool.recordFileAMRUrl){
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要离开此页面?\n离开此页面已输入内容将会丢失。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.tafg = 10;
//        [alertView show];
//    }else{
//        [self removeFromSuperview];
//    }
    //先清空所有语音相关东西 todo changed by qiang
    [self.recordTool destructionRecordingFile];
    
    [self removeFromSuperview];

}
#pragma mark - 下拉显示运动类型
- (IBAction)clickDropDownMenu:(id)sender {
    [self resignTextField];
    HSDropDownMenu *sportDropDownMenu = [HSDropDownMenu menuFrom:self.sportImageView sportID:self.sportID];
    [sportDropDownMenu showFrom:self.sportImageView];
}
#pragma mark - 显示时间间隔选择框
- (IBAction)clickTimeBut:(id)sender {
    [self resignTextField];
    HSYuebanTimeSelect *timePicker = [[HSYuebanTimeSelect alloc]initWithtimeDuration:self.timeInterval * 0.001];
    [timePicker show];
}
#pragma mark - 点击语音按钮
- (IBAction)clickVoiceBtn:(UIButton *)sender {
    
    //点击语音按钮，首先需要做 一下判断
    
    //如果当前输入了字，那么提示用户  删除内容
    
    //如果是输入的语音，点击文字，提示用户删除语音
    
    //当发送完毕后，默认删除系统内  所有语音
    
    [self resignTextField];
//    NSLog(@"sender.selected:%@",sender.selected);
    
    if (isVoiceBtn == true) {//语音输入
        
        //首先检查用户文字是否存在
        if(self.yuebanDetailTF.text.length == 0){
            
            isVoiceBtn = !isVoiceBtn;
            
            self.voiceLabel.text = @"发送文字";
            self.yuebanDetailTF.hidden = YES;
            self.pressSpeakBtn.hidden = NO;
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"切换到语音，会删除文字描述，确定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 12;
            [alertView show];
        }
        
        
    }else{
        
        //首先检查用户语音是否存在，如果存在，提示他需要删除
        if(self.recordTool.recordFileAMRUrl){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"切换到文字，会删除语音，确定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 11;
            [alertView show];
        }
        else{
            
            isVoiceBtn = !isVoiceBtn;
            
            self.voiceLabel.text = @"发送语音";
            self.pressSpeakBtn.hidden = YES;
            self.yuebanDetailTF.hidden = NO;
        }

    }
}

#pragma mark - 点击发送按钮
- (IBAction)sendYueban:(id)sender {
    
    if (self.sportNameTF.text.length == 0) {
        ShowHud(@"请输入运动项目", NO);
        return;
    }
    else if (self.yuebanDetailTF.text.length == 0 && !self.recordTool.recordFileAMRUrl) {//语音二者不能都为空
        ShowHud(@"请输入约伴详情或者录入语音", NO);
        return ;
    }
    //赋值约伴邀请类型
    if (self.slider.value == 1) {
        self.yueban_recommend_type = @"1";
    }else{
        self.yueban_recommend_type = @"0";
    }
    if (self.sportID == nil || self.sportID.length == 0) {//用户没有选择id
        //在我们定义的数组中，检查id，检查不到就赋值其他20
        BOOL isFind = NO;
        for (HSSportModel *sportModel in self.sportArray) {
            if ([sportModel.sportName isEqualToString:self.sportNameTF.text]) {
                self.sportID = sportModel.sportID;
                isFind = YES;
                break;
            }
        }
        //没找到
        if (!isFind) {
            self.sportID = @"20";//赋值其他到后台
        }
    }

    //菊花加载
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"发布中";
    
    //发送后台
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token){
        NSLog(@"user_token为空");
        return;
    }
    NSString *estimated_time = [NSString stringWithFormat:@"%ld",self.timeInterval];
    
    //看语音文件是否存在,存在先存7牛，获取到url再上传
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"xxx.caf"];
    if (self.recordTool.recordFileAMRUrl) {
        //发送7牛
        NSString *localFileURl = [self.recordTool.recordFileAMRUrl path];
        [HSUpLoadToQiNiu upLoadDataByQiNiu:localFileURl andCallBack:^(BOOL code, NSString* qiuNiuURL, NSString *error) {
            if (code) {
                int second = (int)(recordCurrentTime + 0.5);
                NSString *yueban_voice_second =[NSString stringWithFormat:@"%d",second];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                                     self.sportID,@"yueban_sport_id",
                                     qiuNiuURL,@"yueban_voice_info",
                                     yueban_voice_second,@"yueban_voice_second",
                                     @"2093",@"yueban_user_city",
                                     self.yueban_recommend_type,@"yueban_recommend_type",
                                     estimated_time,@"estimated_time",
                                     self.sportNameTF.text,@"user_sport",nil];
                [self doYuebanCreate:dic andHud:hud];

            }else{
                NSLog(@"语音文件上传七牛失败，%@",error);
                [hud hide:YES];
                ShowHud(@"语音文件上传失败,请重试", NO);
            }
        }];
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             self.sportID,@"yueban_sport_id",
                             self.yuebanDetailTF.text,@"yueban_text_info",
                             @"2093",@"yueban_user_city",
                             self.yueban_recommend_type,@"yueban_recommend_type",
                             estimated_time,@"estimated_time",
                             self.sportNameTF.text,@"user_sport",nil];
        [self doYuebanCreate:dic andHud:hud];
    }
}
/**
 *  发送约伴信息去后台
 *
 *  @param dic 封装的约伴信息
 */
- (void)doYuebanCreate:(NSDictionary *)dic andHud:(MBProgressHUD*)hud
{
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
    
    [self.requestDataCtrl doYueBanCreateByUser:requestData andRequestCB:^(BOOL code, id responseObject, NSString *error) {
        if (code) {
            hud.hidden = YES;
            ShowHud(@"发布约伴成功",NO);
            [[NSUserDefaults standardUserDefaults]setObject:self.yueban_recommend_type forKey:@"yueban_recommend_type"];
            
            //销毁录音信息
            if(self.recordTool.recordFileAMRUrl){
                [self.recordTool destructionRecordingFile];
                
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"createYuebanSuccess" object:nil];
            [self removeFromSuperview];
            
            
            //发布约伴成功后，弹出分享菜单
            [self shareWithYueBanID:[responseObject valueForKey:@"yueban_id"]];
            
        }else{
            hud.hidden = YES;
            NSLog(@"发布约伴失败，%@",error);
            ShowHud(@"发布约伴失败，请重试", NO);
        }
        [hud hide:YES];
    }];
}

#pragma mark - 语音模块
/**
 *  按下，开始录音
 *
 *  @param sender
 */
- (IBAction)recordBtnDidTouchDown:(UIButton *)sender {
    //开始录音
    if([sender.currentTitle isEqualToString:@"松开  结束"]){
        
        
            [self.recordTool startRecording];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.micImageView.hidden = NO;
                
            }];
        
        voiceTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timeOver:) userInfo:sender repeats:NO];
        //不重复，只调用一次。timer运行一次就会自动停止运行
        //最多30s
       
    }
}
#pragma mark - 发起语音--点击事件
//松开的时候，需要做的事情
- (IBAction)clickPressSpeaker:(UIButton *)sender {
    
    if(voiceTimeOver){
        voiceTimeOver = false;
        return;
    }
    //计时结束
    [voiceTimer invalidate];
    
    NSLog(@"---%@",sender.currentTitle);
    if([sender.currentTitle isEqualToString:@"松开  结束"]){
        
        
        recordCurrentTime = self.recordTool.recorder.currentTime;
        
        if (recordCurrentTime < 1) {
            self.micImageView.image = [UIImage imageNamed:@"mic_0"];
            [self alertWithMessage:@"说话时间太短"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
                [self.recordTool stopRecording];
                [self.recordTool destructionRecordingFile];
            });
        } else {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self.recordTool stopRecording];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.micImageView.image = [UIImage imageNamed:@"mic_0"];
                });
            });
            // 已成功录音
            NSLog(@"已成功录音");
            //更新按钮显示
            [self updateVoiceBtn:YES];
        }
        self.micImageView.hidden = YES;
    }else{//播放按钮
        [self.recordTool playRecordingFile];
    }
    
}
/**
 *  更新说话按钮显示内容
 *
 *  @param isHasVoice 是否已经有语音内容
 */
- (void)updateVoiceBtn:(BOOL)isHasVoice
{
    if (isHasVoice) {//有语音按钮显示语音的秒数
        int second = (int)(recordCurrentTime + 0.5);
        NSLog(@"%d",second);
        NSString *voiceString =[NSString stringWithFormat:@"%d″",second];
        [self.pressSpeakBtn setTitle:voiceString forState:UIControlStateNormal];
        [self.pressSpeakBtn setTitle:nil forState:UIControlStateHighlighted];
        [self.pressSpeakBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
        //显示删除按钮
        self.cleanVoiceBtn.hidden = NO;
    }else{
        [self.pressSpeakBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
        [self.pressSpeakBtn setTitle:@"松开  结束" forState:UIControlStateHighlighted];
        [self.pressSpeakBtn setBackgroundImage:[UIImage imageNamed:@"btn_pressed"] forState:UIControlStateHighlighted];
        self.cleanVoiceBtn.hidden = YES;
    }
    
}
- (IBAction)cleanVoice:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除此录音文件吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - AlertView代理事件
/**
 *  确定时删除文件
 *  @param alertView   alertView
 *  @param buttonIndex buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            //清除文件
            [self.recordTool destructionRecordingFile];
            [self removeFromSuperview];
        }
    }else if(alertView.tag == 11){
        if(buttonIndex == 1){
            
            isVoiceBtn = !isVoiceBtn;
            
            //清除文件
            [self.recordTool destructionRecordingFile];
            [self updateVoiceBtn:NO];
            
            self.voiceLabel.text = @"发送语音";
            self.pressSpeakBtn.hidden = YES;
            self.yuebanDetailTF.hidden = NO;
        }else{
            //不做处理
        }
    }else if(alertView.tag == 12){
        if(buttonIndex == 1){
            
            isVoiceBtn = !isVoiceBtn;

            self.voiceLabel.text = @"发送文字";
            self.yuebanDetailTF.hidden = YES;
            self.pressSpeakBtn.hidden = NO;
            
            //清楚文字描述
            self.yuebanDetailTF.text =@"";
        }
    }
    else{
        if (buttonIndex == 1) {
            //清除文件
            [self.recordTool destructionRecordingFile];
            //通知七牛删除
            //控制按钮显示格式
            [self updateVoiceBtn:NO];
        }
    }
}
#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录音无效" message:message delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}
#pragma mark -通知实现方法
/**
 *  通知实现方法，消失时调用，向下
 *
 *  @param noti <#noti description#>
 */
-(void)menuDidDismiss
{
    //图片向下,不选中
    self.dropDownBtn.selected = NO;
}
/**
 *  显示时调用，向上
 *
 *  @param noti <#noti description#>
 */
-(void)menuDidShow
{
    //图片向上,选中
    self.dropDownBtn.selected = YES;
}
/**
 *  选中按钮，修改textField的值
 *
 *  @param noti <#noti description#>
 */
- (void)selectedSport:(NSNotification *)noti
{
    NSString *sportName = noti.userInfo[@"sportName"];
    self.sportID = noti.userInfo[@"selectedId"];
    if([sportName isEqualToString:@"其他"]){
        self.sportNameTF.text = @"";
//        self.sportNameTF.placeholder = @"运动项目";
        [self.sportNameTF becomeFirstResponder];
    }else{
        self.sportNameTF.text = sportName;
    }
}

- (void)selectedTimer:(NSNotification *)noti
{
    NSNumber *pickerTimer = noti.userInfo[@"pickerTimer"];
    self.timeInterval = [pickerTimer longValue] * 1000;
    
    //显示
    self.timeBtn.selected = YES;
    double tempPicker = [pickerTimer doubleValue];
    NSInteger hour = tempPicker/3600;
    NSInteger minitue = (tempPicker - 3600 * hour)/60;
    NSString *timeText = nil;
    if (hour == 0) {
        timeText = [NSString stringWithFormat:@"%ld分钟内有效",minitue];
    }else if(minitue == 0){
        timeText = [NSString stringWithFormat:@"%ld小时内有效",hour];
    }else{
        timeText = [NSString stringWithFormat:@"%ld小时%ld分钟内有效",hour,minitue];
    }

    self.timeLabel.text = timeText;
    
}

#pragma mark - textFiled代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignTextField];
    return YES;
}

/**
 *  通知实现控制约伴详情输入长度--20
 *  @param noti
 */
- (void)textFiledEditChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti.object;
    NSString *toBeString = textField.text;

    NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"最多输入20个字" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"最多输入20个字" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}
#pragma mark - 注销输入框
- (void)resignTextField
{
    if ([self.sportNameTF isFirstResponder]) {
        [self.sportNameTF resignFirstResponder];
    }else if([self.yuebanDetailTF isFirstResponder]){
        [self.yuebanDetailTF resignFirstResponder];
    }
}
-(void)dealloc
{
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 点击图片背景关闭输入键盘
- (IBAction)tapToCloseKeyboard:(UITapGestureRecognizer *)sender {
    [self resignTextField];
}

#pragma mark - 显示图片代理
- (void)recordTool:(HSRecordTool *)recordTool didstartRecoring:(int)no
{
    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
    self.micImageView.image = [UIImage imageNamed:imageName];
}

#pragma mark 录音超时
- (void) timeOver:(NSTimer *)timer{
    //记录录音超时了
    voiceTimeOver = true;
    ShowHud(@"录音最多30s哦，您超时了。", NO);
//    [self clickPressSpeaker:(UIButton *)timer.userInfo];

//    录音超过1s结束的操作
    recordCurrentTime = 30;
    [self updateVoiceBtn:YES];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.recordTool stopRecording];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.micImageView.image = [UIImage imageNamed:@"mic_0"];
//        });
    });
    // 已成功录音
    NSLog(@"已成功录音");
    //更新按钮显示

        self.micImageView.hidden = YES;
    
    
    [voiceTimer invalidate];
    voiceTimer = nil;
}

#pragma mark 分享菜单
- (void)shareWithYueBanID:(NSString *)yueban_id {
    
    //构造分享内容
    NSString *contentStr = self.yuebanDetailTF.text;
    if (contentStr.length == 0) {
        contentStr = @"该用户发送的语音内容，请打开app查看";
    }
    NSString *urlStr = @"http://m.live-forest.com/static/view/yueban/yueban_brief.html?type=yueban-yueban_brief&id=";
    urlStr = [urlStr stringByAppendingString:yueban_id];
    
    NSString *imageUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_logo_url"];
    UIImage *image = [UIImage imageNamed:@"Icon"];

//    NSLog(@"%@ %@",urlStr,imageUrlStr);
    
//    不会跳转到分享的应用界面，可能是image的问题
//    id<ISSContent> publishContent = [ShareSDK content:contentStr
//                                       defaultContent:@"liveforest 分享"
//                                                image:[ShareSDK imageWithUrl:imageUrlStr]
//                                                title:@"召集令"
//                                                  url:urlStr
//                                          description:@"liveforest 描述"
//                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSContent> publishContent = [ShareSDK content:contentStr
                                       defaultContent:@"liveforest 分享"
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"召集令"
                                                  url:urlStr
                                          description:@"liveforest 描述"
                                            mediaType:SSPublishContentMediaTypeNews];

    //定义shareList
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSMS,nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];

}

@end
