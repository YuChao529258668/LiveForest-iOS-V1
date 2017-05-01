//
//  RCChatSessionInputBarControl.h
//  RongIMKit
//
//  Created by xugang on 15/2/12.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCChatSessionInputBarControl
#define __RCChatSessionInputBarControl
#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCTextView.h"
#define Height_ChatSessionInputBar 50.0f

/**
 *  RCChatSessionInputBarControlStyle
 */
typedef NS_ENUM(NSInteger, RCChatSessionInputBarControlStyle) {
    /**
     *  switch-input-extend
     */
    RCChatSessionInputBarControlStyle1 = 0,
    /**
     *  extend-input-switch
     */
    RCChatSessionInputBarControlStyle2 = 1,
    /**
     *  input-switch-extend
     */
    RCChatSessionInputBarControlStyle3 = 2,
    /**
     *  input-extend-switch
     */
    RCChatSessionInputBarControlStyle4 = 3,
    /**
     *  switch-input
     */
    RCChatSessionInputBarControlStyle5 = 4,
    /**
     *  input-switch
     */
    RCChatSessionInputBarControlStyle6 = 5,
    /**
     *  extend-input
     */
    RCChatSessionInputBarControlStyle7 = 6,
    /**
     *  input-extend
     */
    RCChatSessionInputBarControlStyle8 = 7,
    /**
     *  input
     */
    RCChatSessionInputBarControlStyle9 = 8,
};

/**
 *  RCChatSessionInputBarControlType
 */
typedef NS_ENUM(NSInteger, RCChatSessionInputBarControlType) {
    /**
     *  默认类型
     */
    RCChatSessionInputBarControlDefaultType = 0,
    /**
     *  默认公众账号类型
     */
    RCChatSessionInputBarControlPubType = 1
};

@protocol RCChatSessionInputBarControlDelegate;

/**
 *  RCChatSessionInputBarControl
 */
@interface RCChatSessionInputBarControl : UIView

/**
 *  delegate 回调
 */
@property(weak, nonatomic) id<RCChatSessionInputBarControlDelegate> delegate;

/**
 * clientView
 */
@property(weak, nonatomic) UIView *clientView;

/**
 *  pubSwitchButton
 */
@property(strong, nonatomic) UIButton *pubSwitchButton;

/**
 *  inputContainerView
 */
@property(strong, nonatomic) UIView *inputContainerView;

/**
 *  menuContainerView
 */
@property(strong, nonatomic) UIView *menuContainerView;

/**
 *  switchButton
 */
@property(strong, nonatomic) UIButton *switchButton;

/**
 *  recordButton
 */
@property(strong, nonatomic) UIButton *recordButton;

/**
 *  inputTextView
 */
@property(strong, nonatomic) RCTextView *inputTextView;

/**
 *  emojiButton
 */
@property(strong, nonatomic) UIButton *emojiButton;

/**
 *  additionalButton
 */
@property(strong, nonatomic) UIButton *additionalButton;

/**
 *  contextView
 */
@property(assign, nonatomic, readonly) UIView *contextView;

/**
 *  currentPositionY
 */
@property(assign, nonatomic) float currentPositionY;

/**
 *  originalPositionY
 */
@property(assign, nonatomic) float originalPositionY;

/**
 *  inputTextview_height
 */
@property(assign, nonatomic) float inputTextview_height;

/**
 *  pubMenu
 */
@property(strong, nonatomic) RCPublicServiceMenu *pubMenu;

/**
 *  初始化
 *
 *  @param frame       frame description
 *  @param contextView contextView description
 *  @param type        type description
 *  @param style       style description
 *
 *  @return 当前对象
 */
- (id)initWithFrame:(CGRect)frame
    withContextView:(UIView *)contextView
               type:(RCChatSessionInputBarControlType)type
              style:(RCChatSessionInputBarControlStyle)style;

/**
 *  设置输入栏的样式 可以在viewdidload后，可以设置样式
 *
 *  @param type  type description
 *  @param style style description
 */
- (void)setInputBarType:(RCChatSessionInputBarControlType)type style:(RCChatSessionInputBarControlStyle)style;

@end

/**
 *  delegate 回调
 */
@protocol RCChatSessionInputBarControlDelegate <NSObject>

@optional

/**
 *  键盘frame事件
 *
 *  @param keyboardFrame keyboardFrame description
 */
- (void)keyboardWillShowWithFrame:(CGRect)keyboardFrame;

/**
 *  键盘隐藏事件
 */
- (void)keyboardWillHide;

/**
 *  输入内容变化事件
 *
 *  @param frame frame description
 */
- (void)chatSessionInputBarControlContentSizeChanged:(CGRect)frame;

/**
 *  return key
 *
 *  @param inputControl inputControl description
 *  @param text         text description
 */
- (void)didTouchKeyboardReturnKey:(RCChatSessionInputBarControl *)inputControl text:(NSString *)text;

/**
 *  点击emoji button
 *
 *  @param sender sender description
 */
- (void)didTouchEmojiButton:(UIButton *)sender;

/**
 *  点击addtional button
 *
 *  @param sender sender description
 */
- (void)didTouchAddtionalButton:(UIButton *)sender;

/**
 *  点击switchbutton
 *
 *  @param switched switched description
 */
- (void)didTouchSwitchButton:(BOOL)switched;

/**
 *  点击pubSwitchButton事件
 *
 *  @param switched switched description
 */
- (void)didTouchPubSwitchButton:(BOOL)switched;

/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 *  @param event  事件
 */
- (void)didTouchRecordButon:(UIButton *)sender event:(UIControlEvents)event;
/**
 *  输入框监控方法
 *
 *  @param inputTextView inputTextView 输入框
 *  @param range         range 范围
 *  @param text          text 文本
 */
- (void)inputTextView:(UITextView *)inputTextView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text;
@end

#endif