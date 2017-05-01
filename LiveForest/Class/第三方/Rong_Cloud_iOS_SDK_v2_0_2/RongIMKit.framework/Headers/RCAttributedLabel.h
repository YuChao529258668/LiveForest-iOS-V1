//
//  RCAttributedLabel.h
//  iOS-IMKit
//
//  Created by YangZigang on 14/10/29.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  RCAttributedLabelClickedTextInfo
 */
@interface RCAttributedLabelClickedTextInfo : NSObject
/**
 *  NSTextCheckingType
 */
@property (nonatomic, assign) NSTextCheckingType textCheckingType;
/**
 *  text
 */
@property (nonatomic, strong) NSString *text;

@end
/**
 *  RCAttributedDataSource
 */
@protocol RCAttributedDataSource <NSObject>
/**
 *  attributeDictionaryForTextType
 *
 *  @param textType textType
 *
 *  @return return NSDictionary
 */
- (NSDictionary*)attributeDictionaryForTextType:(NSTextCheckingTypes)textType;
/**
 *  highlightedAttributeDictionaryForTextType
 *
 *  @param textType textType
 *
 *  @return NSDictionary
 */
- (NSDictionary*)highlightedAttributeDictionaryForTextType:(NSTextCheckingType)textType;

@end
/**
 *  RCAttributedLabel
 */
@interface RCAttributedLabel : UILabel <RCAttributedDataSource>
/** 可以通过设置attributeDataSource或者attributeDictionary、highlightedAttributeDictionary来自定义不同文本的字体颜色 */
@property (nonatomic, strong) id<RCAttributedDataSource> attributeDataSource;
/**
 *  attributeDictionary
 */
@property (nonatomic, strong) NSDictionary *attributeDictionary;
/**
 *  highlightedAttributeDictionary
 */
@property (nonatomic, strong) NSDictionary *highlightedAttributeDictionary;
/** 设置高亮显示哪些类型的文本 NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber */
@property (nonatomic, assign) NSTextCheckingTypes textCheckingTypes;
/**
 *  setTextdataDetectorEnabled
 *
 *  @param text                text
 *  @param dataDetectorEnabled dataDetectorEnabled
 */
- (void)setText:(NSString *)text dataDetectorEnabled:(BOOL)dataDetectorEnabled;
/**
 *  textInfoAtPoint
 *
 *  @param point point
 *
 *  @return RCAttributedLabelClickedTextInfo
 */
- (RCAttributedLabelClickedTextInfo*)textInfoAtPoint:(CGPoint)point;
/**
 *  setTextHighlighted
 *
 *  @param highlighted highlighted
 *  @param point       point
 */
- (void)setTextHighlighted:(BOOL)highlighted atPoint:(CGPoint)point;

@end
