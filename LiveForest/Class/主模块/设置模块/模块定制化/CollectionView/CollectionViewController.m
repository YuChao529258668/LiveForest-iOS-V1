//
//  CollectionViewController.m
//  testCollectionView
//
//  Created by payne on 15/5/5.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "collectionViewFlowLayout.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier1 = @"Cell1";
static NSString * const reuseIdentifier2 = @"Cell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    //初始化cell 标签数组
//    self.arrayWithInsertItem = [NSMutableArray array];
    self.arrayWithText1 = [[NSMutableArray alloc] init];
    self.arrayWithText2 = [[NSMutableArray alloc] init];
    
    //初始化cell背景图片数组
    self.arrayWithImage1 = [[NSMutableArray alloc] initWithObjects:@"customize_index",@"customize_activity",@"customize_home",@"customize_group.jpg", nil];
    self.arrayWithImage2 = [[NSMutableArray alloc] initWithObjects:@"customize_1",@"customize_2",@"customize_3",@"customize_4", nil];
    
//    for (int i = 0; i < 3; i++) {
//        [self.arrayWithText1 addObject:[NSString stringWithFormat:@"%d",i]];
//        
//        [self.arrayWithText2 addObject:[NSString stringWithFormat:@"new%d",i]];
//        
//    }
    //7.13 yc
    [self.arrayWithText1 addObject:@"HSInviteFriendsVC"];
    [self.arrayWithText1 addObject:@"HSIndexController"];
    [self.arrayWithText1 addObject:@"HSActivityController"];
    [self.arrayWithText2 addObject:@"HSInviteFriendsVC"];
    [self.arrayWithText2 addObject:@"HSIndexController"];
    [self.arrayWithText2 addObject:@"HSActivityController"];
    
    
    //collectionView1的布局
    collectionViewFlowLayout *flowLayout1 = [[collectionViewFlowLayout alloc] init];
    //collectionView2的布局
    collectionViewFlowLayout *flowLayout2 = [[collectionViewFlowLayout alloc] init];
    
    self.collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) / 2) collectionViewLayout:flowLayout1];
    //标识collectionView1，用于在layout类里面取得collectionView1
    self.collectionView1.tag = 111;
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    [self.collectionView1 registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier1];
    [self.collectionView1 setBackgroundColor:[UIColor grayColor]];

    self.collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView1.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) / 2) collectionViewLayout:flowLayout2];
    //标识collectionView1，用于在layout类里面取得collectionView2
    self.collectionView2.tag = 222;
    self.collectionView2.delegate = self;
    self.collectionView2.dataSource = self;
    [self.collectionView2 registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier2];
    [self.collectionView2 setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:self.collectionView1];
    [self.view addSubview:self.collectionView2];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == self.collectionView1) {
        return [self.arrayWithText1 count];
    }
    return [self.arrayWithText2 count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell;
    
    if (collectionView == self.collectionView1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.label.text = [self.arrayWithText1  objectAtIndex:indexPath.item];
        cell.backgroundColor = [UIColor redColor];
        [cell.backGroundImage setImage:[UIImage imageNamed:[self.arrayWithImage1 objectAtIndex:indexPath.item]]];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        cell.label.text = [self.arrayWithText2 objectAtIndex:indexPath.item];
        cell.backgroundColor = [UIColor greenColor];
        [cell.backGroundImage setImage:[UIImage imageNamed:[self.arrayWithImage2 objectAtIndex:indexPath.item]]];
    }
//     NSLog(@"cell frame:%@",NSStringFromCGRect(cell.frame));
//    NSLog(@"cell frame:%@",NSStringFromCGRect(cell.backGroundImage.frame));
//    [cell.contentView addSubview:cell.backGroundImage];
    return cell;
}

//向不同的collectionView中插入item，在layout中调用
- (void)collectionView:(UICollectionView *)fromCollectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didInsertToCollectionView:(UICollectionView *)toCollectionView IndexPath:(NSIndexPath *)toIndexPath
{
    NSString *str = nil;
    NSMutableArray *fromArray = nil;
    NSMutableArray *toArray = nil;
    
    //图片数组
    NSString *strImage = nil;
    NSMutableArray *fromArrayImage = nil;
    NSMutableArray *toArrayImage = nil;
    
    if (fromCollectionView == self.collectionView1) {
        str = [self.arrayWithText1 objectAtIndex:fromIndexPath.item];
        fromArray = self.arrayWithText1;
        
        strImage = [self.arrayWithImage1 objectAtIndex:fromIndexPath.item];
        fromArrayImage = self.arrayWithImage1;
    
    } else {
        str = [self.arrayWithText2 objectAtIndex:fromIndexPath.item];
        fromArray = self.arrayWithText2;
        
        strImage = [self.arrayWithImage2 objectAtIndex:fromIndexPath.item];
        fromArrayImage = self.arrayWithImage2;
    }
    
    if (toCollectionView == self.collectionView1) {
        toArray = self.arrayWithText1;
        
        toArrayImage = self.arrayWithImage1;
    } else {
        toArray = self.arrayWithText2;
        
        toArrayImage = self.arrayWithImage2;
    }
    
    [toArray insertObject:str atIndex:toIndexPath.item];
    [fromArray removeObjectAtIndex:fromIndexPath.item];
    
    [toArrayImage insertObject:strImage atIndex:toIndexPath.item];
    [fromArrayImage removeObjectAtIndex:fromIndexPath.item];
}

//同一个collectionView中交换item位置，在layout中调用
- (void)collectionView:(UICollectionView *)collectionView moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *str;
    NSMutableArray *array;
    
    NSString *strImage;
    NSMutableArray *arrayImage;
    
    if (collectionView == self.collectionView1) {
        str = [self.arrayWithText1 objectAtIndex:fromIndexPath.item];
        array = self.arrayWithText1;
        
        strImage = [self.arrayWithImage1 objectAtIndex:fromIndexPath.item];
        arrayImage = self.arrayWithImage1;
    } else {
        str = [self.arrayWithText2 objectAtIndex:fromIndexPath.item];
        array = self.arrayWithText2;
        
        strImage = [self.arrayWithImage2 objectAtIndex:fromIndexPath.item];
        arrayImage = self.arrayWithImage2;
    }
    [array removeObjectAtIndex:fromIndexPath.item];
    [array insertObject:str atIndex:toIndexPath.item];


    [arrayImage removeObjectAtIndex:fromIndexPath.item];
    [arrayImage insertObject:strImage atIndex:toIndexPath.item];
}

#pragma mark 7.13
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%@",self.arrayWithText1);
    NSLog(@"%@",self.arrayWithText2);
}

- (void)readControllerNames {
    
}

- (void)writeControllerNames {
    
}

- (void)completeBtnClick {
//    [self.arrayWithText1 addObject:@"HSInviteFriendsVC"];
//    [self.arrayWithText1 addObject:@"HSIndexController"];
//    [self.arrayWithText1 addObject:@"HSActivityController"];
}

@end