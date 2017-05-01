//
//  HSCommentViewController.m
//  LiveForest
//
//  Created by Swift on 15/5/12.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "HSCommentViewController.h"
#import "HSCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"


//#import "HSIndexViewCell.h"
//#import "HSMineViewCell.h"
//#import "HSVisitMineCell.h"
//#import "HSOfficialView.h"
//#import "HSOfficialViewController.h"


#import "Macros.h"
#import <JSONKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>//七牛图片下载

//wf 评论模型
#import "HSCommentModel.h"
//请求后台公共类
#import "HSRequestDataController.h"
#import "HSDataFormatHandle.h"
#import "MBProgressHUD.h"

#import "HSCommentView.h"


@interface HSCommentViewController ()<UITextViewDelegate>

//@property (nonatomic, strong) UIView *viewWillAddCommentView;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
//@property (nonatomic, strong) NSString *shareID;
//@property (nonatomic, strong) id notificationPoster;

/**
 *  回复评论时选择的那条评论
 */
@property (nonatomic,strong) HSCommentModel *selectComment;

//请求后台数据公共类
@property (nonatomic, strong) HSRequestDataController *requestDataCtrl;

@property (nonatomic, strong) HSCommentView *commentView;
@property (nonatomic, strong) NSString *shareID;
@property (copy, nonatomic) sendCommentSuccessHandler successHandler;

@end

@implementation HSCommentViewController
//@synthesize tableView;
//@synthesize commentArray;
//@synthesize viewWillAddCommentView;
//@synthesize commentView;
//@synthesize shareID;
//@synthesize isCommentViewOnScreen;
//@synthesize notificationPoster;

//static NSString *reuseIdentifier=@"CommentCell";
static NSString *reuseIdentifier=@"CommentCell";



//-(instancetype)init {
//    if (self=[super init]) {
//        //初始化后台请求公共类
//        _requestDataCtrl = [[HSRequestDataController alloc]init];
//        //监听键盘，还有滚动缩放等
//        [self addObservers];
//    }
//    return self;
//}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //监听键盘，还有滚动缩放等
//    [self addObservers];
//    
//    //cell的注册
//    [self.tableView registerNib:[UINib nibWithNibName:@"HSCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
//
//}
/**
 *  懒加载当为nil时，自动调用
 *
 *  @return <#return value description#>
 */
-(NSMutableArray *)commentArray
{
    if (_commentArray == nil) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

#pragma mark - 初始化
//- (instancetype)init {
//    
//    return self;
//}
- (instancetype)initWithShareID:(NSString *)shareID
      sendCommentSuccessHandler:(sendCommentSuccessHandler)successHandler {
    if (self = [super init]) {
        
        _shareID = shareID;
        _successHandler = successHandler;
        
        _commentView = [[HSCommentView alloc]init];
        _commentView.commentTextView.text = @"";
        _commentView.uilabel.text = @"我也说一句";
        _commentView.commentTextView.delegate = self;
        self.view = _commentView;
        
        //初始化后台请求公共类
        self.requestDataCtrl = [[HSRequestDataController alloc]init];
        
        //屏幕适配
        float f = [UIScreen mainScreen].bounds.size.width / self.view.bounds.size.width;
        self.view.transform = CGAffineTransformMakeScale(f, f);
        self.view.center = [UIApplication sharedApplication].keyWindow.center;
        
        //监听键盘，还有滚动缩放等
        [self addObservers];
        
        //cell的注册
        [self.commentView.tableView registerNib:[UINib nibWithNibName:@"HSCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
        self.commentView.tableView.dataSource = self;
        self.commentView.tableView.delegate = self;
        
        //发送评论按钮
        [self.commentView.sendBtn addTarget:self action:@selector(sendCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //黑色背景按钮
        [self.commentView.blackBtn addTarget:self action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //返回按钮
        [self.commentView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

#pragma mark tableview高度和cell的配置
//配置cell
- (void)configCell:(HSCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    //取出模型数据
    HSCommentModel *commentModel = self.commentArray[indexPath.row];
    //昵称
    cell.nameLabel.text= commentModel.user_nickname;
    //评论内容，若是回复要加上“回复 ***：”
    //是否是回复 0:不是 1:是
    BOOL isReply = [commentModel.isReply boolValue];
    if (isReply) {//回复
        NSString *replyComment = [NSString stringWithFormat:@"回复 %@：%@",commentModel.replyUserNickname,commentModel.share_comment_content];
        
        cell.commentLabel.text = replyComment;
    }else{
        cell.commentLabel.text=commentModel.share_comment_content;
    }
    
    //头像
    NSString *imagePath = commentModel.user_logo_img_path;

    if (imagePath == nil || imagePath.length == 0 || [imagePath isEqualToString:@"-10086"]) {
        NSLog(@"用户未设置头像");
    }else if([imagePath isEqualToString: @"locateImage"]){
        //获取本地缓存图片
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        cell.avatar.image = [UIImage imageWithData:[userDefaults objectForKey:@"user_logo_img"]];
    }else{
        NSString *avatarUrl = [[NSString alloc]initWithString:imagePath];
//        NSString *zipAvatarlUrl = [[NSString alloc] initWithFormat:@"%@%s",avatarUrl ,QiNiuImageYaSuo];
//        NSURL * urlAvarl = [NSURL URLWithString:[zipAvatarlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //异步
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
//        [cell.avatar sd_setImageWithURL:urlAvarl
//                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                      if(image){
//                                          cell.avatar.image = image;
//                                      }
//                                      else{
//                                          NSLog(@"网络获取图像失败：%@",error);
//                                      }
//                                  }];
            [HSDataFormatHandle getImageWithUri:avatarUrl isYaSuo:true imageTarget:cell.avatar defaultImage:[UIImage imageNamed:@"default"] andRequestCB:^(UIImage *image) {
            }];
            
        });

    }
    
    //时间,获取时已经转换成了string格式
    NSString *stringDate = commentModel.share_comment_create_time;
    NSString *fromNow = [HSDataFormatHandle dateFormaterString:stringDate];
    cell.timeLabel.text = fromNow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第三方的函数
        return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(HSCommentCell *cell) {
            [self configCell:cell atIndexPath:indexPath];
        }];
}


#pragma -mark tableView 代理方法--选中弹出回复窗口
/**
 *  选择按钮弹出回复窗口(删除todo)
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.commentView.commentTextView.text = @"";
    self.selectComment = self.commentArray[indexPath.row];
    NSLog(@"用户昵称：%@",self.selectComment.user_nickname);
    NSLog(@"评论id:%@",self.selectComment.comment_id);
    //打开键盘，输入框提示变化，
    [self.commentView.commentTextView becomeFirstResponder];
    self.commentView.uilabel.text = [NSString stringWithFormat:@"回复%@：",self.selectComment.user_nickname];
    //去除高亮
    [self.commentView.tableView deselectRowAtIndexPath:[self.commentView.tableView indexPathForSelectedRow] animated:YES];
}

/**
 * 滚动时关闭键盘
 *
 *  @param scrollView scrollView
 */
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    [self.commentView.commentTextView resignFirstResponder];
    
//    if (commentView.uilabel.text != nil) {
//        <#statements#>
//    }
//    commentView.uilabel.text = @"我也说一句";
    //清空选择回复的评论
//    self.selectComment = nil;
}
#pragma mark
//#pragma mark <评论按钮>
//- (void)commentBtnClick:(UIButton *)btn {
//    //此函数只被调用一次，评论按钮会被评论视图挡住
//    //根据按钮的title来判断是谁的评论视图
//    NSString *className=[btn titleForState:UIControlStateDisabled];
//    NSLog(@"className = %@",className);
//    
//    if ([className isEqualToString:@"HSIndexViewCell"]) {
//        HSIndexViewCell *cell=(HSIndexViewCell *)btn.superview.superview;
//        self.commentView=cell.commentView;
//        if (![self.shareID isEqualToString:cell.shareID]) {//当打开的shareID不同时，才去后台加载
//            self.selectComment = nil;
//            self.commentView.commentTextView.text = @"";
//            self.commentView.uilabel.text = @"我也说一句";
//            self.shareID = cell.shareID;
//            //清空原来数据
//            self.commentArray = nil;
//            //去后台评论数据，获取后刷新
//            [self getShareCommet];
//        }
//    } else if ([className isEqualToString:@"HSMineViewCell"]) {
//        HSMineViewCell *cell=(HSMineViewCell *)btn.superview.superview;
//        self.commentView=cell.commentView;
//        if (![self.shareID isEqualToString:cell.shareID]) {
//            self.selectComment = nil;
//            self.commentView.commentTextView.text = @"";
//            self.commentView.uilabel.text = @"我也说一句";
//            self.shareID=cell.shareID;
//            //清空原来数据
//            self.commentArray = nil;
//            //去后台评论数据，获取后刷新
//            [self getShareCommet];
//        }
//    } else if ([className isEqualToString:@"HSVisitMineCell"]) {
//        HSVisitMineCell *cell=(HSVisitMineCell *)btn.superview.superview;
//        self.commentView=cell.commentView;
//        if (![self.shareID isEqualToString:cell.shareID]) {
//            self.selectComment = nil;
//            self.commentView.commentTextView.text = @"";
//            self.commentView.uilabel.text = @"我也说一句";
//            self.shareID=cell.shareID;
//            //清空原来数据
//            self.commentArray = nil;
//            //去后台评论数据，获取后刷新
//            [self getShareCommet];
//        }
//        
//    } else if ([className isEqualToString:@"HSOfficialView"]) {
//        HSOfficialView *ov=(HSOfficialView *)btn.superview;
//        self.commentView=ov.commentView;
//        if (![self.shareID isEqualToString:ov.shareID]) {
//            self.selectComment = nil;
//            self.commentView.commentTextView.text = @"";
//            self.commentView.uilabel.text = @"我也说一句";
//            self.shareID=ov.shareID;
//            //清空原来数据
//            self.commentArray = nil;
//            //去后台评论数据，获取后刷新
//            [self getShareCommet];
//        }
//    }
//    //7.30
//    else {
//        
//    }
//
//    //设置代理
//    self.commentView.tableView.dataSource=self;
//    self.commentView.tableView.delegate=self;
//    
//    self.commentView.commentTextView.delegate = self;
//
//    [self commentViewShowWithAnimation];
//}
//
//#pragma mark <评论视图的显示动画>
////-(void)commentViewShowWithAnimation {
////    //    self.commentView.alpha=1;
////    
////    //7.12
////    //    [[UIApplication sharedApplication].keyWindow addSubview:self.commentView];
////    
////    self.commentView.alpha=0.1;
////    NSLog(@"%f",commentView.fitFactor);
////    
////    commentView.containView.transform=CGAffineTransformMakeScale(0.1, 0.1);
////    
////    [UIView animateWithDuration:0.15 animations:^{
////        commentView.containView.transform=CGAffineTransformMakeScale(self.commentView.fitFactor * 1.4, self.commentView.fitFactor * 1.4);
////        self.commentView.alpha=0.3;
////        
////    } completion:^(BOOL finished) {
////        [UIView animateWithDuration:0.15 animations:^{
////            commentView.containView.transform=CGAffineTransformMakeScale(0.85, 0.85);
////            
////            self.commentView.alpha=1;
////        }];
////    }];
////}
////7.12

#pragma mark <发送评论>
- (void)sendCommentWithComment:(NSString *)comment
{
    
    self.commentView.sendBtn.userInteractionEnabled = NO;
    //    NSLog(@"self.collectionView.visibleCells.firstObject:%@",self.collectionView.visibleCells.firstObject);
    
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"user_token"]){
        NSLog(@"user_token为空，");
    }
    else{
        NSString *user_token = [[NSString alloc]initWithString:[userDefaults objectForKey:@"user_token"]];//如果不存在usertoken,则不能赋值
        NSString *commmentID = @"0";
        //判断是回复还是评论
        if(self.selectComment != nil)
        {
            commmentID = self.selectComment.comment_id;
        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             self.shareID,@"share_id",
                             comment,@"share_comment_content",
                             commmentID,@"comment_id",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        NSLog(@"%@",requestData);
        
        [self.requestDataCtrl doShareComment:requestData andRequestCB:^(BOOL code,id responseObject, NSString *error){
            if(code){
                
                
                //回调block，比如更新评论数
                if (self.successHandler) {
                    self.successHandler();
                }

                self.commentView.sendBtn.userInteractionEnabled = YES;
                //更新tableview
                [self updateTableViewWithComment:self.commentView.commentTextView.text];
                
                //显示提示
                self.commentView.commentTextView.text = @"";
                self.commentView.uilabel.text = @"我也说一句";
                if(self.selectComment != nil)
                {
                    ShowHud(@"回复成功",NO);
                }
                else
                {
                    ShowHud(@"评论成功",NO);
                   
                    
                }

            }
            else{
                if(self.selectComment != nil)
                {
                    ShowHud(@"回复失败",NO);
                }
                else
                {
                    ShowHud(@"评论失败",NO);
                }
                NSLog(@"异常:%@",error);
            }
             //清空选择的评论
            self.selectComment = nil;
            self.commentView.sendBtn.userInteractionEnabled = YES;
            
            
        }];

        
    }
}
-(void)updateTableViewWithComment:(NSString *)comment
{
    //前端页面在最后面加上评论，回复在回复的那一行下面加上
    HSCommentModel *sendComment = [[HSCommentModel alloc]init];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] * 1000];
    sendComment.share_comment_create_time = timeSp;
    sendComment.share_comment_content = comment;
    //头像(本地提取)
    sendComment.user_logo_img_path = @"locateImage";
    //昵称
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    sendComment.user_nickname = [userDefaults objectForKey:@"user_nickname"];
    if (self.selectComment != nil) {
        sendComment.isReply = @"1";
        sendComment.replyUserNickname = self.selectComment.user_nickname;
    }
    //添加数据,
    //bug commentArray为nil，不添加数据，造成下一步错误,懒加载当为nil时，初始化
    [self.commentArray addObject:sendComment];
    //刷新页面
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.commentArray.count - 1 inSection:0];
    [self.commentView.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //3》移动tableView位置
    [self.commentView.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //关闭键盘
    [self.commentView.commentTextView resignFirstResponder];
}
#pragma mark -获取评论
-(void)getShareCommet
{
    //获取用户token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [userDefaults objectForKey:@"user_token"];
    if(!user_token || self.shareID == nil){
        NSLog(@"user_token为空，或者shareID 为空");
    }else{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user_token,@"user_token",
                             self.shareID,@"share_id",nil];
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:[dic JSONString],@"requestData", nil];
        
        NSLog(@"requestData:%@",requestData);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.commentView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中";
        [self.requestDataCtrl getShareComment:requestData andRequestCB:^(BOOL code, NSArray* shareComment, NSString *error) {
            if (code)
            {
                //取消加载框
                [hud hide:YES];
                if (shareComment != nil) {
                    self.commentArray = [HSCommentModel commentModelsWithArray:shareComment];
                    
                }else{
                    NSLog(@"返回数据格式错误或为空");
                    self.commentArray = nil;
                }
                
            }
            else
            {
                //取消加载框
                [hud hide:YES];
                NSLog(@"获取评论请求失败，%@",error);
                ShowHud(@"网络请求失败", NO);
                self.commentArray = nil;
            }
            //刷新
            [self.commentView.tableView reloadData];
            
        }];
    }

}




#pragma mark - 注册通知
- (void)addObservers {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //增加监听，当手势开始的时候
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentViewDisappearWithAnimation) name:@"狼来了" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hide) name:@"狼来了" object:nil];
}

#pragma mark 注销通知
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)dealloc {
    [self removeObservers];
}

#pragma mark - 键盘事件
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    //    NSDictionary *userInfo = [aNotification userInfo];
    //    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [value CGRectValue];
    //    float height = keyboardRect.size.height;
    
    CGRect frame=self.commentView.containView.frame;
    frame.origin.y=-frame.size.height*0.3;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.containView.frame=frame;
    }completion:^(BOOL finished) {
        NSLog(@"commentView %@",NSStringFromCGRect(self.commentView.frame));
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    CGPoint centerPoint=CGPointMake(self.commentView.bounds.size.width/2, self.commentView.bounds.size.height/2) ;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.containView.center=centerPoint;
    }];
}

#pragma mark - commentView的textView的代理方法
//wf 从HSCommentView类中移动此处7.1
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.commentTextView.text =  textView.text;
    if (textView.text.length == 0) {
        if (self.selectComment) {
            self.commentView.uilabel.text = [NSString stringWithFormat:@"回复%@：",self.selectComment.user_nickname];
        }else{
            self.commentView.uilabel.text = @"我也说一句";
        }
        
    }else{
        self.commentView.uilabel.text = @"";
    }
}






#pragma mark - 按钮点击事件
#pragma mark <点击发送评论按钮>
- (void)sendCommentBtnClick:(id)sender {
    //发送评论去后台
    NSString *comment = self.commentView.commentTextView.text;
    
    NSLog(@"-----%@",self.commentView.commentTextView.text);
    [self sendCommentWithComment:comment];
    
}

#pragma mark <黑色背景按钮点击事件，让评论视图消失的动画>
- (void)blackBtnClick:(UIButton *)sender {
    if ([self.commentView.commentTextView isFirstResponder]) {
        [self.commentView.commentTextView resignFirstResponder];
    } else {
//        [self commentViewDisappearWithAnimation];
//        [self.view removeFromSuperview];
        [self hide];
    }
}

#pragma mark <关闭按钮点击事件，让评论视图消失的动画>
- (void)backBtnClick:(id)sender {
//    [self commentViewDisappearWithAnimation];
//    [self.view removeFromSuperview];
    [self hide];
}

#pragma mark - 显示和消失动画
- (void)hide {
    [self commentViewDisappearWithAnimation];
//    [self.view removeFromSuperview];
}
- (void)showOrHide {
    
    if (self.view.superview) {
        [self hide];
    } else {
        //清空原来数据
        [self.commentArray removeAllObjects];
        //去后台评论数据，获取后刷新
        [self getShareCommet];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
        [self commentViewShowWithAnimation];
    }
}
#pragma mark <评论视图的显示动画>
-(void)commentViewShowWithAnimation {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.commentView.center = CGPointMake(frame.size.width,frame.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:2
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
//        self.commentView.alpha = 1;
        self.commentView.center = [UIApplication sharedApplication].keyWindow.center;
//        self.commentView.containView.transform=CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark <评论视图的消失动画>
-(void)commentViewDisappearWithAnimation {
    
    //滑动scrollView之前关闭键盘
    [self.commentView.commentTextView resignFirstResponder];
   
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:2
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                                 self.commentView.alpha = 0.1;
                                 self.commentView.containView.transform=CGAffineTransformMakeScale(0.1, 0.1);
                     }
                     completion:^(BOOL finished) {
                         self.commentView.containView.transform=CGAffineTransformMakeScale(0.85, 0.85);
                         self.commentView.alpha = 1;
                         
                         [self.view removeFromSuperview];
    }];

}
@end
