//
//  HSRecordTool.h
//  LiveForest
//
//  Created by wangfei on 8/11/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVFoundation.h>
//#import <CoreAudio/CoreAudioTypes.h>
//#import "arm/amrFileCodec.h"
//#import "arm/include/opencore-amrnb/interf_dec.h"

//#import "VoiceConvert/VoiceConverter.h"

#import <RongIMLib/RCAMRDataConverter.h>

@class HSRecordTool;
@protocol HSRecordToolDelegate <NSObject>

@optional
- (void)recordTool:(HSRecordTool *)recordTool didstartRecoring:(int)no;

@end

@interface HSRecordTool : NSObject

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;

/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileAMRUrl;

/** 录音文件地址 */
//@property (nonatomic, strong) NSURL *recordFileDecodeAMRUrl;

/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 更新图片的代理 */
@property (nonatomic, weak) id<HSRecordToolDelegate> delegate;

/** 利用融云转换编码 */
@property (nonatomic, strong) RCAMRDataConverter *amrConvert;

/** wave语音转码为wave**/
- (void)amrConvertToWave;

/** 播放amr文件 **/
- (void)playAmrRecordFile;
@end
