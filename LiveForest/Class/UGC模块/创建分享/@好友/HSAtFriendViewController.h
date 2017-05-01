//
//  HSAtFriendViewController.h
//  LiveForest
//
//  Created by 余超 on 15/7/28.
//  Copyright © 2015年 HOTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAtFriendViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

/**
 *  选中的@好友
 */
@property (nonatomic, strong) NSMutableArray *selectedFriendsID;

@end
