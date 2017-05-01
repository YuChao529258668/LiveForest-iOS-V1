//
//  CellTuple.m
//  testCollectionView
//
//  Created by payne on 15/5/10.
//  Copyright (c) 2015年 payne. All rights reserved.
//

#import "CellTuple.h"

@implementation CellTuple

- (id)initWithTag:(NSUInteger)tag AndIndexPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        self.tag = tag;
        self.indexPath = indexPath;
    }
    return self;
}

@end
