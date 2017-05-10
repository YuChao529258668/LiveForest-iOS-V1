//
//  YueBanDetailTableViewCell.m
//  LiveForest
//
//  Created by 钱梦颖 on 15/8/5.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSYueBanDetailTableViewCell.h"
#import "HSYueBanUserInfoList.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HSDataFormatHandle.h"
#import <RongIMKit/RongIMKit.h>
#import "HSYueBanDetailViewController.h"

@interface HSYueBanDetailTableViewCell ()
@property (nonatomic, strong) RCConversationViewController *conversationVC;
@end

@implementation HSYueBanDetailTableViewCell

@synthesize avatarImage;
@synthesize userNameLabel;
@synthesize sexImage;
@synthesize ageLabel;
@synthesize userID;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    avatarImage.layer.cornerRadius = avatarImage.frame.size.height/2;
    avatarImage.clipsToBounds = YES;
}


-(void)setUserInfo:(HSYueBanUserInfoList *)userInfo{
    NSURL *avatarUrl = [NSURL URLWithString:userInfo.user_logo_img_path];
    
    if (!avatarUrl) {
        NSString *avatarUrlString = [userInfo.user_logo_img_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        avatarUrl = [NSURL URLWithString:avatarUrlString];
    }
    
    NSLog(@"url ============  %@",avatarUrl);
    [avatarImage sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"mineAvarl.png"]];
    userNameLabel.text = userInfo.user_nickname;
    //    0,男;1,女;-1,未知
    if([userInfo.user_sex isEqualToString:@"1"]){
        sexImage.image = [UIImage imageNamed:@"female_icon"];
        
    }else{
        sexImage.image = [UIImage imageNamed:@"male_icon"];
    }

    ageLabel.text = [HSDataFormatHandle getAgeFromBirthday:[NSString stringWithFormat:@"%@",userInfo.user_age]];
    ageLabel.text = userInfo.user_age;

    userID = userInfo.user_id;
}




+(id)yueBaneListCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"HSYueBanDetailTableViewCell" owner:nil options:nil][0];
}
- (IBAction)ChatBtn:(id)sender {
    // 连接融云服务器。
    
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    self.conversationVC = conversationVC;
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    UIButton *btn = sender;
    NSLog(@"%@",btn.superview);
    NSLog(@"%@",btn.superview.superview);
    
    HSYueBanDetailTableViewCell *cell = btn.superview.superview;
    
    conversationVC.targetId = cell.userID; // 接收者的 targetId，这里为举例。
  
    conversationVC.targetName = cell.userInfo.user_nickname; // 接受者的 username，这里为举例。
    conversationVC.title = @"私人聊天室"; // 会话的 title。
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:conversationVC];
    
    // 设置背景颜色为黑色。
    [conversationVC.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    conversationVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonSystemItemAction target:self action:@selector(backConversion)];//设置navigationbar左边按钮
    
    id next = [self nextResponder] ;
    
    while (next != nil) {
        next = [next nextResponder];
        if ([next isKindOfClass:[HSYueBanDetailViewController class]]) {
            
            [((HSYueBanDetailViewController *)next) presentViewController:nav animated:YES completion:nil ];
            return;
        }
    }
    
//    [self presentViewController:nav animated:YES completion:nil];
    
    //    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //    [window insertSubview: nav.view aboveSubview:self.view];
}

- (void)backConversion {
    [self.conversationVC dismissViewControllerAnimated:YES completion:nil];
}

+(id)ID{
    return @"HSFriendListViewCell";
}
@end
