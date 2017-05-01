//
//  QRViewController.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSConstLayout.h"

#import "HSQRDisplayVC.h"

#import "HSRequestDataController.h"

#import "Macros.h"

typedef void(^QRUrlBlock)(NSString *url);
@interface QRViewController : UIViewController<UIGestureRecognizerDelegate>{
    bool stopScan;  //控制扫描结束
}

@property (strong, nonatomic) IBOutlet UIButton *qrBlockButton;

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;
@property (strong, nonatomic) IBOutlet UIImageView *qrLineImg;
@property (strong, nonatomic) IBOutlet UILabel *showMyQR;
@property (strong, nonatomic) HSQRDisplayVC *qrDisplayVC;
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

@end
