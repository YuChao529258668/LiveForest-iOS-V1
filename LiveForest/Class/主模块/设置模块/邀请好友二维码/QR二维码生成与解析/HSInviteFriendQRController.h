//
//  HSInviteFriendQRController.h
//  LiveForest
//
//  Created by 傲男 on 15/7/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSInviteFriendQRController : UIViewController

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

+ (UIImage *) twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;

@end
