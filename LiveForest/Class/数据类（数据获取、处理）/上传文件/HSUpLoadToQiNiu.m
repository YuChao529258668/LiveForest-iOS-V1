//
//  HSUpLoadToQiNiu.m
//  LiveForest
//
//  Created by 傲男 on 15/8/7.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSUpLoadToQiNiu.h"

@implementation HSUpLoadToQiNiu

static HSRequestDataController *requestDataCtrl;


#pragma mark 七牛存储文件
+ (void)upLoadDataByQiNiu:(NSString *)filePath andCallBack:(void(^)(BOOL, NSString * ,NSString *))CallBack{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSString *fileName= filePath; //必须
    NSDictionary *dic = @{@"fileName": fileName, @"prefix": @"imageTestByHot"};
    NSString *data = [dic JSONString];
    NSDictionary *requestData = @{@"requestData"  : data};
    
    //      后台交互
    requestDataCtrl = [[HSRequestDataController alloc]init];
    [requestDataCtrl getQiniuUpTokenWithParam:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
        if(code){
            NSString *saveKey = [responseObject objectForKey:@"saveKey"];
            NSString *upToken = [responseObject objectForKey:@"upToken"];
            
            [upManager putFile:filePath key:saveKey token:upToken
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if(resp){
                              NSString *imgUrl = [[NSString alloc]initWithFormat:@"%s%@",QiNiuImageUrl,key];
                              return CallBack(true, imgUrl,@"");
                          }
                          else{
                              return CallBack(false, @"",@"上传失败");
                          }
                      } option:nil
             ];
        }
    }];
}
@end
