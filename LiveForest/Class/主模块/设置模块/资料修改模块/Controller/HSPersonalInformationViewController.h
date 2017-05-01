//
//  HSPersonalInformationViewController.h
//  LiveForest
//
//  Created by 余超 on 15/6/29.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSUserInfoHandler.h"

#import <TuSDK/TuSDK.h>

#import "HSRequestDataController.h"

#import "Macros.h"

@interface HSPersonalInformationViewController : UITableViewController <TuSDKPFCameraDelegate,TuSDKFilterManagerDelegate,UIActionSheetDelegate>
{
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    // 多功能图片编辑组件
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
}


@property (strong, nonatomic) IBOutlet UIImageView *avarlImage;

@property (strong, nonatomic) IBOutlet UILabel *nickName;

@property (strong, nonatomic) IBOutlet UILabel *sex;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (nonatomic, strong) HSUserInfoHandler *userInfoControl;

@property (nonatomic,strong) NSString *imageURL; //用户选取头像的路径
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

@end
