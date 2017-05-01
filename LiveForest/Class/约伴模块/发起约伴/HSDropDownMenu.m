//
//  HSDropDownMenu.m
//  LiveForest
//
//  Created by wangfei on 8/5/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import "HSDropDownMenu.h"
#import "UIView+Extension.h"
#import "HSSportLabelView.h"
#import "HSSportModel.h"

#define kpadding 15
#define kCount 4
#define subViewH 65
#define subViewW 50

@interface HSDropDownMenu()<SportLabelViewDelegate>

/**
 *  背景容器
 */
@property(nonatomic,weak) UIView *containerView;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIScrollView *scrollView;
/**
 * 存储供用户选择的的运动标签
 */
@property (nonatomic, strong)NSArray *sportArray;

/**
 * 用户已经选择的运动id
 */
@property (nonatomic, copy)NSString *selectedID;


@end

@implementation HSDropDownMenu
-(UIView *)containerView
{
    if (_containerView == nil) {
        //创建一个imageView
        UIImageView *downImageView = [[UIImageView alloc]init];
        downImageView.image = [UIImage imageNamed:@"notif-bg"];
        //宽度，图片宽度，固定
//        downImageView.width = 217;
        downImageView.height =290;
        downImageView.userInteractionEnabled = YES;//交互打开
        
        [self addSubview:downImageView];
        _containerView = downImageView;
    }
    return _containerView;
}
-(instancetype)initWithFrom:(UIView *)from sportID:(NSString *)sportID
{
    self = [super init];
    if (self) {
        
        //todo  缩放
//        float fitFactor=[UIScreen mainScreen].bounds.size.width/ self.containerView.frame.size.width;
//        self.containerView.transform=CGAffineTransformMakeScale(fitFactor, fitFactor);
//        self.containerView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
//        
        
        //蒙版
        self.backgroundColor = [UIColor clearColor];
        //加入容器
        self.containerView.width = from.width;
        self.selectedID = sportID;
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.scrollView];
    
    }
    return self;
}

+(instancetype)menuFrom:(UIView *)from sportID:(NSString *)sportID
{
    return [[self alloc]initWithFrom:from sportID:sportID];
}
-(NSArray *)sportArray
{
    if (_sportArray == nil) {
        _sportArray = [HSSportModel sportModels];
    }
    return _sportArray;
}
-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kpadding, 5, self.containerView.width *0.5, 44)];
        _titleLabel.text = @"运动项目选择";
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _titleLabel;
}
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        CGFloat scrollViewY = CGRectGetMaxY(self.titleLabel.frame);
        CGFloat scrollViewW = self.containerView.width - 2 * kpadding;
        CGFloat scrollViewH = self.containerView.height - 50;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kpadding,scrollViewY, scrollViewW, scrollViewH)];
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //添加子空间，9宫格
        CGFloat marginX = (scrollViewW - kCount * subViewW)/ (kCount - 1);
        CGFloat marginY =  20;
        for (int i = 0; i < self.sportArray.count; i++) {
            //行 0，1，2----0；3，4，5---1
            int row = i/kCount;
            //列 0，3，6，----0; 1, 4, 5---1
            int col = i%kCount;
            
            HSSportLabelView *labelView = [[HSSportLabelView alloc]initWithIsSingleSelect:YES];
            labelView.delegate = self;
            HSSportModel *sportModel = self.sportArray[i];
            labelView.sportID = sportModel.sportID;
            labelView.sportLable.text = sportModel.sportName;
            
            [labelView.sportButton setBackgroundImage:[UIImage imageNamed:sportModel.normalIcon] forState:UIControlStateNormal];
            [labelView.sportButton setBackgroundImage:[UIImage imageNamed:sportModel.selectedIcon] forState:UIControlStateSelected];
            
            if ([self.selectedID isEqualToString:sportModel.sportID]) {
                labelView.sportButton.selected = YES;
            }
            //行x的数据主要关系是哪一列 col(从0开始)
            //列y的数据主要关系是哪一行 row（从0开始）
            CGFloat x = col * (marginX + subViewW);
            CGFloat y = row * (marginY + subViewH);
            
            labelView.frame = CGRectMake(x, y, subViewW, subViewH);
            
            [_scrollView addSubview:labelView];
        }
        CGFloat contentSizeH = CGRectGetMaxY([_scrollView.subviews.lastObject frame]);
        _scrollView.contentSize = CGSizeMake(scrollViewW, contentSizeH + 5);
    }
    return _scrollView;
}

-(void)showFrom:(UIView *)from
{
    //取出当前的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //设置容器的位置
    self.containerView.centerX = from.centerX;

    //转换坐标系 nil--window
    CGRect newRect = [from convertRect:from.bounds toView:nil];
    self.containerView.y = CGRectGetMaxY(newRect);
    
    //将自己加入到当前的窗口中
    [window addSubview:self];
    
    //设置尺寸
    self.frame = window.bounds;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuDidShow" object:self];
}

#pragma -mark 用户选择确定按钮
-(void)save
{
    //确定选取的id,单选
    NSString *selectedId = @"";
    NSString *sportName = @"";
    
    for (id subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[HSSportLabelView class]]) {
            if ([subView sportButton].selected) {
                selectedId = [subView sportID];
                sportName = [subView sportLable].text;
                break;
            }
        }
    }
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:selectedId forKey:@"selectedId"];
    [dictM setObject:sportName forKey:@"sportName"];
    //通知上个页面修改
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectedSport" object:self
                                                      userInfo:dictM];
    //关闭
    [self dismiss];
}


/**
 *  点击空白页面，关闭下拉视图,通知修改图片方向
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
/**
 *  关闭视图
 */
-(void)dismiss
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuDidDismiss" object:self];
    [self removeFromSuperview];    
}

#pragma mark - 代理实现单选
- (void)sportLalelViewDidClickButton:(HSSportLabelView *)sportLabelView
{
    for (id subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[HSSportLabelView class]]) {
            if ([subView sportButton].selected) {
                [subView sportButton].selected = NO;
            }
        }
    }
}
#pragma mark - 代理直接关闭视图
- (void)sportLaleViewDidClose:(HSSportLabelView *)sportLabelView
{
    [self save];
}
@end
