//
//  HSActivityCardViewController.m
//  LiveForest
//
//  Created by 余超 on 15/7/20.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import "HSActivityCardViewController.h"
#import "HSActivityCardView.h"
#import "HSActivityLargeCardCell.h"
#import "HSActivityLargeCardTopCell.h"

static NSString *reuseIdentifier = @"HSActivityLargeCardCell";

@interface HSActivityCardViewController ()
@property (strong, nonatomic) HSActivityCardView *cardView;
@end

@implementation HSActivityCardViewController
@synthesize cardView;
@synthesize largeCardViewData;

//- (instancetype)init {
//    if (self = [super init]) {
//        cardView = [[HSActivityCardView alloc]init];
//        self.view = cardView;
//        
//        [self setSmallCardView];
//        [self setLargeCardView];
////        [self setSubviewsAlphaWithFactor:1];
//        self.cardView.smallCardView.alpha=0;
//        self.cardView.largeCardView.alpha=1;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <设置cardView的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor {
    cardView.smallCardView.alpha=2-factor;
    cardView.largeCardView.alpha=factor-1;
}
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber {
    float factor=[factorNumber floatValue];
    cardView.smallCardView.alpha=2-factor;
    cardView.largeCardView.alpha=factor-1;
}

#pragma mark <设置小卡片>
- (void)setSmallCardView {
    
}

#pragma mark <设置大卡片>
- (void)setLargeCardView {
//    [cardView.tableView registerClass:[HSActivityLargeCardCell class] forCellReuseIdentifier:reuseIdentifier];
    cardView.tableView.dataSource = self;
    cardView.tableView.delegate = self;
}

#pragma mark <tableView data source>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        HSActivityLargeCardTopCell *topCell = [[HSActivityLargeCardTopCell alloc]init];
        return topCell;
    } else {
        //不注册会跪
//        [tableView registerClass:[HSActivityLargeCardCell class] forCellReuseIdentifier:@"HSActivityLargeCardCell"];
        [tableView registerNib: [UINib nibWithNibName:@"HSActivityLargeCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HSActivityLargeCardCell"];
        HSActivityLargeCardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        return cell;
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 270;
    }
    return 332;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return NO;
}
//- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
@end
