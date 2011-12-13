//
//  RetryManager.m
//  FootballScore
//
//  Created by haodong qiu on 11-11-25.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import "RetryManager.h"

#define FOLLOW_UNFOLLOW_RETRYLIST   @"followUnfollowRetryList"
#define NEET_RETRY_PUSH_SET         @"needRetryPushSet"


RetryManager* retryManager;

RetryManager* GlobalGetRetryManager()
{
    if (retryManager == nil){
        retryManager = [[RetryManager alloc] init];
    }
    
    return retryManager;
}


@implementation RetryManager


+ (RetryManager*)defaultManager
{
    return GlobalGetRetryManager();
}

- (void)addFollowUnfollowToUserDefaults:(NSString *)matchId type:(NSString *)type
{
    if (matchId != nil && type != nil)
    {
        NSMutableDictionary *list =[NSMutableDictionary dictionaryWithDictionary:
                                                    [[NSUserDefaults standardUserDefaults] objectForKey:FOLLOW_UNFOLLOW_RETRYLIST]];
        
        [list setObject:type forKey:matchId];
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:FOLLOW_UNFOLLOW_RETRYLIST];
    }
}

- (void)removeFollowUnfollowFromUserDefaults:(NSString *)matchId type:(NSString *)type
{
    if (matchId != nil && type != nil)
    {
        NSMutableDictionary *list =[NSMutableDictionary dictionaryWithDictionary:
                                                  [[NSUserDefaults standardUserDefaults] objectForKey:FOLLOW_UNFOLLOW_RETRYLIST]];
        [list removeObjectForKey:matchId];
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:FOLLOW_UNFOLLOW_RETRYLIST];
    }
}

- (NSMutableDictionary*)getFollowUnfollowListFromUserDefaults
{
    NSMutableDictionary *list =[NSMutableDictionary dictionaryWithDictionary:
                                [[NSUserDefaults standardUserDefaults] objectForKey:FOLLOW_UNFOLLOW_RETRYLIST]];
    return list;
}

- (void)saveNeedRetryPushSet:(BOOL)isNeed
{
    [[NSUserDefaults standardUserDefaults] setBool:isNeed forKey:NEET_RETRY_PUSH_SET];
}

- (BOOL)getNeedRetryPushSet
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:NEET_RETRY_PUSH_SET];
}

@end
