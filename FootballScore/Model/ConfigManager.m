//
//  ConfigManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager

//+ (NSString*)getValue:(NSString*)configKey
//{
//    return nil;
//}
//
//+ (void)setValue:(NSString*)configKey value:(NSString*)value
//{
//    
//}

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

+ (BOOL)getHasSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:HAS_SOUND];
}

+ (BOOL)getIsVibration
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_VIBRATION];
}

@end
