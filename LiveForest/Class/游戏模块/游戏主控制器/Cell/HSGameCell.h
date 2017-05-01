//
//  HSGameCell.h
//  LiveForest
//
//  Created by 余超 on 15/9/10.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGameCell : UICollectionViewCell

#pragma mark <设置cell的子视图透明度>
-(void)setSubviewsAlphaWithFactor:(float) factor;
- (void)setSubviewsAlphaWithNSNumberFactor:(NSNumber *) factorNumber ;

@end
