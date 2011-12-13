//
//  RetryManager.h
//  FootballScore
//
//  Created by haodong qiu on 11-11-25.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetryManager : NSObject

+ (RetryManager*)defaultManager;

- (void)addFollowUnfollowToUserDefaults:(NSString *)matchId type:(NSString *)type;
- (void)removeFollowUnfollowFromUserDefaults:(NSString *)matchId type:(NSString *)type;
- (NSMutableDictionary*)getFollowUnfollowListFromUserDefaults;

- (void)saveNeedRetryPushSet:(BOOL)isNeed;
- (BOOL)getNeedRetryPushSet;

@end
