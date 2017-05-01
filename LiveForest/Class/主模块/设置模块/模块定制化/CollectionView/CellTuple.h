//
//  CellTuple.h
//  testCollectionView
//
//  Created by payne on 15/5/10.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellTuple : NSObject

@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (id)initWithTag:(NSUInteger)tag AndIndexPath:(NSIndexPath *)indexPath;

@end
