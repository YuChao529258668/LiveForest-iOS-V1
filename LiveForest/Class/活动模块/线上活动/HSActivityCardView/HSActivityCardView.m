//
//  HSActivityCardView.m
//  LiveForest
//
//  Created by 余超 on 15/7/15.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSActivityCardView.h"
#import "HSActivityCardView.h"
#import "HSActivityLargeCardCell.h"
#import "HSActivityLargeCardTopCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HSOfficialViewController.h"
#import "HSCommentViewController.h"
#import "HSShareActivityViewController.h"

static NSString *reuseIdentifier = @"HSActivityLargeCardCell";

@implementation HSActivityCardView

@synthesize smallCardView;
@synthesize largeCardView;
@synthesize backgroundImgSmall;
@synthesize activityNameSmall;
@synthesize activityDescriptionSmall;
@synthesize activityJoinCountSmall;
@synthesize tableView;
//@synthesize picActivityInfo=_picActivityInfo;
@synthesize picActivityInfo;
@synthesize shareInfoArray;

//- (void)setPicActivityInfo:(HSPicActivityInfo *)picActivityInfo2 {
////    if (!shareInfoArray) {
////        shareInfoArray = [NSMutableArray array];
////    } else {
////        [shareInfoArray removeAllObjects];
////    }
//    picActivityInfo = picActivityInfo2;
//    shareInfoArray = [NSMutableArray arrayWithArray:picActivityInfo2.shareList];
//    [tableView reloadData];
//}
- (void)setPicActivityInfo:(HSPicActivityInfo *)picActivityInfo2 {
//    if (!shareInfoArray) {
//        shareInfoArray = [NSMutableArray array];
//    } else {
//        [shareInfoArray removeAllObjects];
//    }
//    _picActivityInfo = picActivityInfo2;
    picActivityInfo = picActivityInfo2;
    shareInfoArray = [NSMutableArray arrayWithArray:picActivityInfo2.shareList];
//    [tableView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (nonnull instancetype)initWithFrame:(CGRect)frame {
//    if (self=[super initWithFrame:frame]) {
//        
//        //执行loadNibNamed后会马上执行awakeFromNib
//        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSActivityCardView" owner:nil options:nil];
//        self=array[0];
//        
//        array=[[NSBundle mainBundle]loadNibNamed:@"HSActivitySmallCard" owner:nil options:nil];
//        smallCardView = array[0];
//        
//        array=[[NSBundle mainBundle]loadNibNamed:@"HSActivityLargeCard" owner:nil options:nil];
//        largeCardView = array[0];
//        
//        
//        //        self = (HSActivityCardView *)smallCardView;
//        [self.contentView addSubview:largeCardView];
//        //        self = (HSActivityCardView *)largeCardView;
//        [self.contentView addSubview:smallCardView];
//        
//        
//        //        largeCardView.alpha=0.4;
//        
//        //        //屏幕适配
//        //        float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
//        //        float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
//        //
//        //        self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
//        //        //调整缩放后的位置
//        //        CGRect frame=self.frame;
//        //        frame.origin=CGPointZero;
//        //        self.frame=frame;
//        
//    }
//    return self;
//}
- (nonnull instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        
        //执行loadNibNamed后会马上执行awakeFromNib
        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"HSActivityCardView" owner:nil options:nil];
        self=array[0];//显示一个tableview
//        self.backgroundColor =[UIColor redColor];
        smallCardView = array[1];//显示已有几人参加等
        
//        largeCardView = array[2];
        
        
        //        self = (HSActivityCardView *)smallCardView;
//        [self.contentView addSubview:largeCardView];
        //        self = (HSActivityCardView *)largeCardView;
        
        [self.contentView addSubview:smallCardView];
//        [self.contentView addSubview:largeCardView];

        [self setSubviewsAlphaWithFactor:1];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.coverBtn = [[UIButton alloc]initWithFrame:self.frame];
        [self addSubview:self.coverBtn];
        [self.coverBtn addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.coverBtn.backgroundColor = [UIColor blueColor];
        
    }
    return self;
}



//- (void)awakeFromNib {
//    [super awakeFromNib];
////    largeCardView.alpha=0.4;
////    
////    //屏幕适配
////    float factorWidth=[UIScreen mainScreen].bounds.size.width/self.frame.size.width;
////    float factorHeight=[UIScreen mainScreen].bounds.size.height/self.frame.size.height;
////    
////    self.transform = CGAffineTransformMakeScale(factorWidth, factorHeight);
////    //调整缩放后的位置
////    CGRect frame=self.frame;
////    frame.origin=CGPointZero;
////    self.frame=frame;
//
//}

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
    smallCardView.alpha=2-factor;
    largeCardView.alpha=factor-1;
    
    self.coverBtn.alpha = 2- factor;
//    smallCardView.alpha = 0;
//    largeCardView.alpha = 0;
}
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];

    [self setSubviewsAlphaWithFactor:factor];
}
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
//    return NO;
//}


#pragma mark <tableView data source>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return shareInfoArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static HSShareInfo *shareInfo;
    
    if (indexPath.row == 0) {
//        HSPicActivityInfo *picActivityInfo

//        NSLog(@"activity_name %@",picActivityInfo.activity_name);
//        NSLog(@"activity_img_path %@",picActivityInfo.activity_img_path[0]);
//        NSLog(@"url %@",[NSURL URLWithString:picActivityInfo.activity_img_path[0]] );
        NSString *urlString = picActivityInfo.activity_img_path[0];
        NSLog(@"HSActivityCardView  %s,%@",__func__,urlString);
        HSActivityLargeCardTopCell *topCell = [[HSActivityLargeCardTopCell alloc]init];

        [HSDataFormatHandle getImageWithUri:urlString isYaSuo:true imageTarget:topCell.backgroundImg defaultImage:[UIImage imageNamed:@"default.png"] andRequestCB:^(UIImage *image) {
//            code
//            topCell.backgroundColor = [UIColor blueColor];
        }];
        
        topCell.activityName.text = picActivityInfo.activity_name;
        topCell.publishTime.text = picActivityInfo.create_time;
        topCell.activityDescription.text = picActivityInfo.activity_summary;
//        NSLog(@"cardView !!!!!!");
//        NSLog(@"%@",picActivityInfo);
//        NSLog(@"activity_name %@",picActivityInfo.activity_name);
//        NSLog(@"activity_img_path %@",picActivityInfo.activity_img_path[0]);
//        NSLog(@"url %@",[NSURL URLWithString:picActivityInfo.activity_img_path[0]] );
//        NSLog(@"%ld",tableView.tag);
//        NSLog(@"cardView end!!!!!!");
//        topCell.backgroundColor = [UIColor blackColor];
        
        return topCell;
    } else {
        //不注册会跪
        //        [tableView registerClass:[HSActivityLargeCardCell class] forCellReuseIdentifier:@"HSActivityLargeCardCell"];
        [tableView registerNib: [UINib nibWithNibName:@"HSActivityLargeCardCell"
                                               bundle:[NSBundle mainBundle]]
                               forCellReuseIdentifier:@"HSActivityLargeCardCell"];
        
        shareInfo = shareInfoArray[indexPath.row - 1];
        NSString  *urlString = shareInfo.share_img_path[0];
//        NSURL *backgroundImageUrl = [NSURL URLWithString:
//                                     [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSURL *avatarImageUrl = [NSURL URLWithString:
//                                 [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        HSActivityLargeCardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
       
        [HSDataFormatHandle getImageWithUri:urlString isYaSuo:true imageTarget:cell.backgroundImageView defaultImage:[UIImage imageNamed:@"default.png"] andRequestCB:^(UIImage *image) {
            //            code
        }];
        
        urlString = shareInfo.user_logo_img_path;

        [HSDataFormatHandle getImageWithUri:urlString isYaSuo:true imageTarget:cell.avatarImageView defaultImage:[UIImage imageNamed:@"default.png"] andRequestCB:^(UIImage *image) {
            //            code
        }];

        cell.nameLabel.text = shareInfo.user_nickname;
        cell.timeLabel.text = shareInfo.share_creat_time;
        cell.descriptionLabel.text = shareInfo.share_description;
        cell.loveCountLabel.text = shareInfo.share_like_num;
        cell.commentCountLabel.text = shareInfo.comment_count;
//        NSLog(@"%@",shareInfo.user_nickname);

        return cell;
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 270;
    }
    return 332;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    HSShareInfo *shareInfo = shareInfoArray[indexPath.row-1];
    NSString *shareID = shareInfo.share_id;
    [self showIndexCellWithShareID:shareID];
}

- (void)showIndexCellWithShareID:(NSString *)shareID {
    static HSOfficialViewController *officialViewController;
    officialViewController = [[HSOfficialViewController alloc]init];
    [officialViewController getShareInfoWithShareID:shareID];
    [officialViewController show];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:officialViewController animated:YES completion:nil]; // 会导致根控制器消失。。。

//    static HSCommentViewController *commentViewController;
//    commentViewController = [[HSCommentViewController alloc]init];
//    HSOfficialView *officialView = (HSOfficialView *)officialViewController.view;
//
//    //评论按钮
//    [officialView.commentBtnLarge addTarget:commentViewController action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //发送评论按钮
//    [officialView.commentView.sendBtn addTarget:commentViewController action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //黑色背景按钮
//    [officialView.commentView.blackBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //返回按钮
//    [officialView.commentView.backBtn addTarget:commentViewController action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)topBtnClickToScale:(UIButton *)sender {
//    UIView *topSuperView;
//    for (UIView *iv = sender; iv.superview; iv = iv.superview) {
//        if ([iv isKindOfClass:[]]) {
//            
//        }
//    }
    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[@""]
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"" object:nil userInfo:dic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topBtnClickToScale" object:self];
    
    //获取cell
    UICollectionViewCell *cell;
    UICollectionView *cv;
    for (UIView *view = self.superview; view; view = view.superview) {
        if ([view isKindOfClass:[UICollectionViewCell class]]) {
            cell = (UICollectionViewCell *)view;
            continue;
        }
        if ([view isKindOfClass:[UICollectionView class]]) {
            cv = (UICollectionView *)view;
            break;
        }
    }
    NSIndexPath *indexPath = [cv indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    //获取cell和collectionView，然后计算indexPath
//    UICollectionViewCell *cell;
//    UICollectionView *cv;
//    for (UIView *view = self.superview; view; view = view.superview) {
//        if ([view isKindOfClass:[UICollectionViewCell class]]) {
//            cell = (UICollectionViewCell *)view;
////            NSLog(@"%@",view);
//            continue;
//        }
//        if ([view isKindOfClass:[UICollectionView class]]) {
//            cv = (UICollectionView *)view;
////            NSLog(@"%@",view);
//            break;
//        }
//    }
//    NSIndexPath *indexPath = [cv indexPathForCell:cell];
////    NSLog(@"%ld",indexPath.item);
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"topBtnClickToScale" object:indexPath];
//    
//
//}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}
    
//参加活动按钮点击
- (IBAction)joinActivityBtnClick:(UIButton *)sender {
    HSShareActivityViewController *vc;
    vc = [HSShareActivityViewController new];
//    vc.view.backgroundColor = [UIColor blueColor];
//    NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)dismissController:(HSShareActivityViewController *)vc {
    
}
- (void)coverBtnClick:(UIButton *)sender {
    //获取cell和collectionView，然后计算indexPath
    UICollectionViewCell *cell;
    UICollectionView *cv;
    for (UIView *view = sender.superview; view; view = view.superview) {
        if ([view isKindOfClass:[UICollectionViewCell class]]) {
            cell = (UICollectionViewCell *)view;
            //            NSLog(@"%@",view);
            continue;
        }
        if ([view isKindOfClass:[UICollectionView class]]) {
            cv = (UICollectionView *)view;
            //            NSLog(@"%@",view);
            break;
        }
    }
    NSIndexPath *indexPath = [cv indexPathForCell:cell];
    NSLog(@"%ld",indexPath.item);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topBtnClickToScale" object:indexPath];

}
@end
