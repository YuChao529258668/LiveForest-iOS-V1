//
//  HSRelatedActivityVC.h
//  LiveForest
//
//  Created by wangfei on 7/28/15.
//  Copyright (c) 2015 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRelatedActivityVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backBut;
@property (weak, nonatomic) IBOutlet UIButton *confirmBut;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;


@property (nonatomic, strong) NSString *activityID;
@end
