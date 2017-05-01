//
//  HSCellController.m
//  LiveForest
//
//  Created by Swift on 15/5/22.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSCellController.h"
#import "HSSuperCell.h"

//网络
#import <JSONKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>//七牛图片下载

@interface HSCellController()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HSCellController
@synthesize manager;

#pragma mark 分享
- (void)shareBtnClick:(UIButton *)btn {
    HSSuperCell *cell=(HSSuperCell *)btn.superview.superview;
    cell.backgroundColor=[UIColor yellowColor];
}

#pragma mark 点赞
- (void)praiseBtnClick:(UIButton *)btn {
    HSSuperCell *cell=(HSSuperCell *)btn.superview.superview;
    cell.backgroundColor=[UIColor yellowColor];
}

#pragma mark 评论弹窗
- (void)commentBtnClick:(UIButton *)btn {
    HSSuperCell *cell=(HSSuperCell *)btn.superview.superview;
    cell.backgroundColor=[UIColor yellowColor];
}

#pragma mark 发送评论
- (void)sendCommentBtnClick:(UIButton *)btn {
    HSSuperCell *cell=(HSSuperCell *)btn.superview.superview;
    cell.backgroundColor=[UIColor yellowColor];
}

#pragma mark 图片放大
- (void)imageBtnClick:(UIButton *)btn {
    HSSuperCell *cell=(HSSuperCell *)btn.superview.superview;
    cell.backgroundColor=[UIColor yellowColor];
}

#pragma mark


/*
#pragma mark 点赞判断
- (void)setShareLikeState:(NSString *)shareID {
    
    
    //    praiseJudge = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             shareID,@"share_id",
                             nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        
        
        //        NSLog(@"requestData:%@",requestData);
        
        NSString *uri = @"http://121.41.104.156:10086/Social/Share/getUserShareLikeState";
        [self.manager POST:uri
                parameters:requestData
                   success:^(AFHTTPRequestOperation *operation, id responseObject){
                       NSLog(@"praise:%i",[[responseObject objectForKey:@"code"] intValue]);
                       if ([[responseObject objectForKey:@"code"] intValue]==0) {
                           
                           //                           NSLog(@"%@",responseObject);
                           cell.praiseJudge = false;
                           NSLog(@"还没点过赞");
                           [cell.praiseBtnLarge setImage:[UIImage imageNamed:@"ic_thumb_up_black_48dp.png"] forState:UIControlStateNormal];
                           //                           ShowHud(@"成功",NO);
                           //                           return false;
                       }
                       else if([[responseObject objectForKey:@"code"] intValue]==1){
                           [cell.praiseBtnLarge setImage:[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"] forState:UIControlStateNormal];
                           cell.praiseJudge = true;
                           NSLog(@"点过赞了");
                           //                           NSLog(@"点过赞了");
                           
                       }
                       else{
                           //                           ShowHud(@"失败",NO);
                           NSLog(@"异常");
                       }
                       //                       return 0;
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //fail
                       NSLog(@"请求失败，%@",error);
                   }];
        
    }
    
}
#pragma mark 点赞 成功效果
-(void)praiseBtnClick:(NSNotification *)notification {
    HSIndexViewCell *cell= [[HSIndexViewCell alloc]init];
    
    if(notification.object){
        cell=(HSIndexViewCell *)notification.object;
        NSLog(@"cell.shareID:%@",cell.shareID);
    }
    
    cell.praiseBtnLarge.userInteractionEnabled = NO;
    
    NSLog(@"%@",cell.shareID);
    //http://121.41.104.156:10086/Social/Share/doShareLike?requestData={“user_token”:“0irh2FUS2FdYrgJknj2F2Ldsh9pUDDYOTlS3FxIVdRsBXY3D”,“share_id”:“12”}
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             cell.shareID,@"share_id",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        //        [self httpInit];
        
        
        NSString *uri = @"http://121.41.104.156:10086/Social/Share/doShareLike";
        [self.manager POST:uri
                parameters:requestData
                   success:^(AFHTTPRequestOperation *operation, id responseObject){
                       NSLog(@"%i",[[responseObject objectForKey:@"code"] intValue]);
                       
                       if ([[responseObject objectForKey:@"code"] intValue]==0) {
                           
                           //处理点赞后的效果
                           [self praiseBtnEffect:cell];
                           
                           cell.praiseBtnLarge.userInteractionEnabled = YES;
                       }
                       else{
                           cell.praiseBtnLarge.userInteractionEnabled = YES;
                           ShowHud(@"系统异常", NO);
                           NSLog(@"异常");
                       }
                       
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //fail
                       cell.praiseBtnLarge.userInteractionEnabled = YES;
                       NSLog(@"请求失败，%@",error);
                       ShowHud(@"网络错误", NO);
                   }];
        
    }
    
}

-(void)praiseBtnEffect:(HSIndexViewCell*)cell{
    
    UIImage *image;
    int praiseNum = cell.praiseLabelLarge.text.intValue;
    //    NSLog(@"praiseNum:%i",praiseNum);
    if(!cell.praiseJudge){
        praiseNum++;
        image=[UIImage imageNamed:@"ic_thumb_up_blue_48dp.png"];
        cell.praiseJudge = YES;
    }
    else{
        praiseNum--;
        image=[UIImage imageNamed:@"ic_thumb_up_black_48dp.png"];
        cell.praiseJudge = NO;
    }
    
    NSString *type = [[NSString alloc]initWithFormat:@"%i",praiseNum];
    [cell.praiseLabelLarge setText:type];
    [cell.praiseBtnLarge setImage:(UIImage *)image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.15 animations:^{
        cell.praiseBtnLarge.transform=CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            cell.praiseBtnLarge.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }];
}*/


/*
#pragma mark 发送评论
- (void)sendCommentWithShareID:(NSString *)shareID Comment:(NSString *)comment CommentURI:(NSString *)uri {
    
    NSLog(@"shareID:%@",shareID);
    commentView.sendBtn.userInteractionEnabled = NO;
    //    NSLog(@"self.collectionView.visibleCells.firstObject:%@",self.collectionView.visibleCells.firstObject);
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             shareID,@"share_id",
                             comment,@"share_comment_content" ,nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        [self httpInit];
        
        NSLog(@"requestData:%@",requestData);
        
        //            NSString *uri = @"http://121.41.104.156:10086/Social/Share/doShareComment";
        [self.manager POST:uri
                parameters:requestData
                   success:^(AFHTTPRequestOperation *operation, id responseObject){
                       if ([[responseObject objectForKey:@"code"] intValue]==0) {
                           //                           NSLog(@"%@",responseObject);
                           ShowHud(@"评论成功",NO);
                           [commentView.commentTextView setText:@"说点什么"];
                           commentView.sendBtn.userInteractionEnabled = YES;
                       }
                       else{
                           ShowHud(@"评论失败",NO);
                           NSLog(@"异常");
                           commentView.sendBtn.userInteractionEnabled = YES;
                       }
                       
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //fail
                       commentView.sendBtn.userInteractionEnabled = YES;
                       NSLog(@"请求失败，%@",error);
                   }];
        
        commentView.sendBtn.userInteractionEnabled = YES;
        
    }
}



#pragma praiseBtnLarge:


#pragma 分享按钮
- (void) doComment:(NSNotification *)noti {
    HSIndexViewCell *cell= [[HSIndexViewCell alloc]init];
    
    if(noti){
        cell=(HSIndexViewCell *)noti.object;
        NSLog(@"cell.shareID:%@",cell.shareID);
        cell.addCommentViewSendBtn.userInteractionEnabled = NO;
        //    NSLog(@"self.collectionView.visibleCells.firstObject:%@",self.collectionView.visibleCells.firstObject);
        //获取用户token
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if(![userDefaults objectForKey:@"user_token"]){
            NSLog(@"user_token为空，");
        }
        else{
            NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                                 cell.shareID,@"share_id",
                                 cell.addCommentViewTextView.text,@"share_comment_content",nil];
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
            //        [self httpInit];
            
            NSLog(@"requestData:%@",requestData);
            
            NSString *uri = @"http://121.41.104.156:10086/Social/Share/doShareComment";
            [self.manager POST:uri
                    parameters:requestData
                       success:^(AFHTTPRequestOperation *operation, id responseObject){
                           if ([[responseObject objectForKey:@"code"] intValue]==0) {
                               //                           NSLog(@"%@",responseObject);
                               ShowHud(@"评论成功",NO);
                               [cell.addCommentViewTextView setText:@"说点什么"];
                               cell.addCommentViewSendBtn.userInteractionEnabled = YES;
                           }
                           else{
                               ShowHud(@"评论失败",NO);
                               NSLog(@"异常");
                               cell.addCommentViewSendBtn.userInteractionEnabled = YES;
                           }
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           //fail
                           cell.addCommentViewSendBtn.userInteractionEnabled = YES;
                           NSLog(@"请求失败，%@",error);
                       }];
            
        }
    }
    else{
        NSLog(@"评论异常");
    }
}


#pragma mark share third
- (void) shareThird:(NSNotification *)noti{
    HSIndexViewCell *cell = [[HSIndexViewCell alloc]init];
    if(noti){
        cell = (HSIndexViewCell *)noti.object;
        NSLog(@"shareid:%@",cell.shareID);
        
        //        显示压缩后的图片
        NSCharacterSet *whitespace = [NSCharacterSet  URLQueryAllowedCharacterSet];//编码，将空格编码
        NSString* strAfterDecodeByUTF8AndURI = [cell.imgUrl stringByAddingPercentEncodingWithAllowedCharacters:whitespace];
        [self shareWithcontent:cell.textLabelLarge.text withTitle:@"LiveForest分享" withImage:strAfterDecodeByUTF8AndURI];
    }
    
}

#pragma mark enlargeImage
- (void)enlargeImage:(NSNotification *)noti{
    
    HSIndexViewCell *cell = [[HSIndexViewCell alloc]init];
    cell = (HSIndexViewCell*)noti.object;
    
    [cell.contentView addSubview:cell.blackCellEnlargeImage];
    [cell.contentView addSubview:cell.largedImage];
    
    //todo
    cell.largedImage.image = nil;
    cell.blackCellEnlargeImage.alpha = 0.6;
    
    
    cell.largedImage.image = [self loadImageWithUrl:cell.imgHighQualityUrl];
    
    
    cell.largedImage.reverse = YES;
    [cell.largedImage animate];
    //    cell.largedImage an
}

#pragma mark reduceImage
- (void)reduceImage:(NSNotification *)noti{
    HSIndexViewCell *cell = [[HSIndexViewCell alloc]init];
    cell = (HSIndexViewCell*)noti.object;
    
    
    //    [cell.largedImage animate];
    [UIView animateWithDuration:0.5 animations:^{
        //        cell.largedImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        //        cell.largedImage.reverse = YES;
        //        [cell.largedImage animate];
    } completion:^(BOOL finished){
        //        cell.largedImage.alpha = 0;
        //         cell.contentView.alpha = 1;
        [cell.blackCellEnlargeImage removeFromSuperview];
        [cell.largedImage removeFromSuperview];
    }];
    
}
 */

#pragma mark AFNetworking初始化
-(void)httpInit{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    self.manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html",@"text/plain",@"text/json", nil];
    self.manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", nil];
}

- (void)dealloc {
    NSLog(@"hscommentVC dealloc");
}
@end
