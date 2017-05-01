//
//  PhotoTitleView.h
//  nushroom
//
//  Created by yiliu on 15/5/29.
//  Copyright (c) 2015年 nushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface PhotoTitleView : UIView<HPGrowingTextViewDelegate>{
    UIImageView *backImageView;
}

- (instancetype)initType:(NSString *)type;

@property (nonatomic,strong) HPGrowingTextView *textView;
@property (nonatomic,strong) NSString *phototType;

@end
