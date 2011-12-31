//
//  ConfigManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigManager.h"


@implementation ConfigManager


+ (void)saveHasSound:(BOOL)hasSound
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:hasSound forKey:HAS_SOUND];
}

+ (void)saveIsVibration:(BOOL)isVibration
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isVibration forKey:IS_VIBRATION];
}

+ (void)saveRefreshInterval:(NSTimeInterval)refreshInterval
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:refreshInterval forKey:REFRESH_INTERVAL];
}

+ (void)saveIsLockScreen:(BOOL)isLockScreen
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isLockScreen forKey:IS_LOCK_SCREEN];
}




+ (BOOL)getHasSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:HAS_SOUND];
}

+ (BOOL)getIsVibration
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_VIBRATION];
}

+ (NSTimeInterval)getRefreshInterval
{
    NSNumber* timeInterval = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_INTERVAL];
    if (timeInterval == nil) 
        return REFRESH_INTERVAL_MIN;  
    else
        return [timeInterval doubleValue];
}

+ (BOOL)getIsLockScreen
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOCK_SCREEN];
}

@end
