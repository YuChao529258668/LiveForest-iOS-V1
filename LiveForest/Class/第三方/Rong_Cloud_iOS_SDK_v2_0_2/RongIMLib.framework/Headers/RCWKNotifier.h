//
//  RCWKNotifier.h
//  RongWKLib
//
//  Created by litao on 15/4/7.
//
//

#import <Foundation/Foundation.h>

@interface RCWKNotifier : NSObject
//for App use
+ (void)notifyWatchKitEvent:(NSString *)appEvent;
+ (void)NotifyWatchKitMessageChanged;
+ (void)NotifyWatchKitFriendChanged;
+ (void)NotifyWatchKitLoadImageDone:(NSString *)userID;
+ (void)NotifyWatchKitConnectionStatusChanged;
@end
