//
//  HSCollectionViewSmallLayout.m
//  Paper
//
//  Created by Heberti Almeida on 04/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HSCollectionViewSmallLayout.h"
#import "HSConstLayout.h"
@implementation HSCollectionViewSmallLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(kScreenWidth-2, kScreenHeight);//kCollectionViewCellHeight);//142, 254
//    _smallLayout.itemSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//    self.sectionInset = UIEdgeInsetsMake(100 ,100, 100,100 );//只是cell
//    self.headerReferenceSize=CGSizeMake(20, 10);
//    self.minimumInteritemSpacing = 2;
    self.minimumLineSpacing = 2;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return NO;
}

@end
