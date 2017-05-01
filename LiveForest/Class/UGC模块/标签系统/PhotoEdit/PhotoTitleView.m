//
//  PhotoTitleView.m
//  nushroom
//
//  Created by yiliu on 15/5/29.
//  Copyright (c) 2015年 nushroom. All rights reserved.
//

#import "PhotoTitleView.h"

@implementation PhotoTitleView

- (instancetype)initType:(NSString *)type{
    self = [super init];
    if(self){
        
        _phototType = type;
        NSString *imageName;
        if([type isEqual:@"标签"]){
            imageName = @"b_q";
        }else if([type isEqual:@"地点"]){
            imageName = @"d_w";
        }else{
            imageName = @"r_w";
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        UIImage *image = [UIImage imageNamed:@"9.9k_k"];
        image = [image stretchableImageWithLeftCapWidth:19.5 topCapHeight:17.5];
        backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 100, 25)];
        backImageView.userInteractionEnabled = YES;
        backImageView.image = image;
        [self addSubview:backImageView];
        
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(31, 10-3, backImageView.bounds.size.width, backImageView.bounds.size.height-2)];
        _textView.textColor = [UIColor whiteColor];
        _textView.isScrollable = NO;
        _textView.contentInset = UIEdgeInsetsMake(0, 1, 0, 1);
        _textView.minNumberOfLines = 1;
        _textView.maxNumberOfLines = 20;
        _textView.returnKeyType = UIReturnKeyGo;
        _textView.font = [UIFont systemFontOfSize:14.0f];
        _textView.delegate = self;
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(1, 0, 1, 0);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholder = @"点击输入内容";
        [self addSubview:_textView];
        
    }
    return self;
}

#pragma -mark HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = backImageView.frame;
    r.size.height -= diff;
    backImageView.frame = r;
    
    CGRect rr = self.frame;
    rr.size.height -= diff;
    self.frame = rr;
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView{
    if(growingTextView.text.length > 0 && growingTextView.text.length <= 6){
        
        float wiN = growingTextView.text.length*14+16;
        
        CGRect r = backImageView.frame;
        r.size.width = wiN;
        backImageView.frame = r;
        
    }else if(growingTextView.text.length == 0){
        
        float wiN = 100;
        CGRect r = backImageView.frame;
        r.size.width = wiN;
        backImageView.frame = r;
        
    }
}



@end
