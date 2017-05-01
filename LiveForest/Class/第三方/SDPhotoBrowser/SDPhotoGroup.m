//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"
#import "HSConstantURL.h"

#define SDPhotoGroupImageMargin 3

//yc 为了修复一张图片的bug导入 7.31
#import <SDWebImage/UIImageView+WebCache.h>

@interface SDPhotoGroup () <SDPhotoBrowserDelegate>

@end

@implementation SDPhotoGroup


- (id)initWithArrayOfUrl:(NSArray *)arrayWithUrl frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *temp = [NSMutableArray array];
        [arrayWithUrl enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = src;
            [temp addObject:item];
        }];
        [self setPhotoItemArray:[temp copy]];
    }
    return self;
}

//修复bug，只有一张图片的时候太小。yc，7.31
- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(SDPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        
        //修复bug，只有一张图片的时候太小。yc，7.31
        //如果只有一张照片
        //修改btn.imageView.frame和缩放都无效，只好重新创建一个和按钮等大的imageView放上去了。
        long imageCount = self.photoItemArray.count;
        if (imageCount==1) {
//            UIImage *image=btn.imageView.image;
//            UIImageView *imageView=[[UIImageView alloc]initWithFrame:btn.bounds];
//            imageView.image=image;
//            imageView.contentMode=UIViewContentModeScaleAspectFill;
//            imageView.clipsToBounds=YES;
//            //                [btn addSubview:imageView];
//            [btn insertSubview:imageView aboveSubview:btn];
//            //                imageView.center=btn.center;
//            //                [self insertSubview:imageView aboveSubview:btn];
            
            
            NSURL *url = [NSURL URLWithString:obj.thumbnail_pic];
            if (!url) {
                url = [NSURL URLWithString: [obj.thumbnail_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.contentMode=UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds=YES;
            imageView.tag = idx;
//            imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    NSLog(@"%s, 图片下载失败，%@",__func__,error);
                    NSLog(@"失败URLString %@",obj.thumbnail_pic);
                    NSLog(@"失败URL %@",[NSURL URLWithString:obj.thumbnail_pic]);
                    NSLog(@"%@",[NSURL URLWithString: [obj.thumbnail_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]);
                    NSLog(@"失败url,%@",url);
                }
            }];
            
//            static UIButton *btn;
//            btn = [[UIButton alloc] init];
//            [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                imageView.image = image ;
//                
////                UIImageView *iv = [[UIImageView alloc]initWithImage:image];
////                imageView.frame = iv.frame;
//            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleImageViewTap:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            
            [self addSubview:imageView];
            
            
        } else {
            UIButton *btn = [[UIButton alloc] init];
            
            NSURL *url = [NSURL URLWithString:obj.thumbnail_pic];
            if (!url) {
                url = [NSURL URLWithString: [obj.thumbnail_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [btn sd_setImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    NSLog(@"%s, 图片下载失败，%@",__func__,error);
                }
            }];
            
            btn.tag = idx;
            btn.imageView.contentMode=UIViewContentModeScaleAspectFill;
            //        btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }];
}
//- (void)setPhotoItemArray:(NSArray *)photoItemArray
//{
//    _photoItemArray = photoItemArray;
//    [photoItemArray enumerateObjectsUsingBlock:^(SDPhotoItem *obj, NSUInteger idx, BOOL *stop) {
//        UIButton *btn = [[UIButton alloc] init];
//        //        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal];
//        
//        //修复bug，只有一张图片的时候太小。yc，7.17
//        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            //如果只有一张照片
//            //修改btn.imageView.frame和缩放都无效，只好重新创建一个和按钮等大的imageView放上去了。
//            long imageCount = self.photoItemArray.count;
//            if (imageCount==1) {
//                UIImage *image=btn.imageView.image;
//                UIImageView *imageView=[[UIImageView alloc]initWithFrame:btn.bounds];
//                imageView.image=image;
//                imageView.contentMode=UIViewContentModeScaleAspectFill;
//                imageView.clipsToBounds=YES;
//                //                [btn addSubview:imageView];
//                [btn insertSubview:imageView aboveSubview:btn];
//                //                imageView.center=btn.center;
//                //                [self insertSubview:imageView aboveSubview:btn];
//                
//            }
//        }];
//        
//        btn.tag = idx;
//        btn.imageView.contentMode=UIViewContentModeScaleAspectFill;
//        //        btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
//        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//        
//        
//    }];
//}

//修复bug，只有一张图片的时候太小。yc，7.31
- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = 1; //每一行的图片张数
    
    if (imageCount > 1 && imageCount <= 4) {
        perRowImageCount = 2;
    } else if (imageCount > 4 && imageCount <= 9) {
        perRowImageCount = 3;
    }
    
    CGFloat w = (self.frame.size.width - SDPhotoGroupImageMargin * (perRowImageCount - 1))/perRowImageCount;
    CGFloat h = (self.frame.size.height - SDPhotoGroupImageMargin * (perRowImageCount - 1))/perRowImageCount;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + SDPhotoGroupImageMargin);
        CGFloat y = rowIndex * (h + SDPhotoGroupImageMargin);
        view.frame = CGRectMake(x, y, w, h);
        
    }];
    
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    long imageCount = self.photoItemArray.count;
//    int perRowImageCount = 1; //每一行的图片张数
//    
//    if (imageCount > 1 && imageCount <= 4) {
//        perRowImageCount = 2;
//    } else if (imageCount > 4 && imageCount <= 9) {
//        perRowImageCount = 3;
//    }
//    
//    CGFloat w = (self.frame.size.width - SDPhotoGroupImageMargin * (perRowImageCount - 1))/perRowImageCount;
//    CGFloat h = (self.frame.size.height - SDPhotoGroupImageMargin * (perRowImageCount - 1))/perRowImageCount;
//    
//    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
//        
//        long rowIndex = idx / perRowImageCount;
//        int columnIndex = idx % perRowImageCount;
//        CGFloat x = columnIndex * (w + SDPhotoGroupImageMargin);
//        CGFloat y = rowIndex * (h + SDPhotoGroupImageMargin);
//        btn.frame = CGRectMake(x, y, w, h);
//        
//    }];
//    
//}

- (void)buttonClick:(UIButton *)button
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = (int)button.tag;
    browser.delegate = self;
    [browser show];
    
}

//修复bug，只有一张图片的时候太小。yc，7.31
- (void)singleImageViewTap:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = (int)view.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //修复bug，只有一张图片的时候太小。yc，7.31
    long imageCount = self.photoItemArray.count;
    if (imageCount==1) {
        UIImageView *iv = (UIImageView *)self.subviews[index];
        return iv.image;
    }
    
    
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@QiNiuImageYaSuo withString:@""];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

@end
