//
//  ConfigManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HAS_SOUND @"HAS_SOUND"
#define IS_VIBRATION @"IS_VIBRATION"
#define REFRESH_INTERVAL @"REFRESH_INTERVAL"

#define REFRESH_INTERVAL_MIN 10
#define REFRESH_INTERVAL_MAX 360

@interface ConfigManager : NSObject {
    
}

//+ (NSString*)getValue:(NSString*)configKey;
//+ (void)setValue:(NSString*)configKey value:(NSString*)value;

+ (void)saveHasSound:(BOOL)hasSound;
+ (void)saveIsVibration:(BOOL)isVibration;
+ (void)saveRefreshInterval:(NSTimeInterval)refreshInterval;

+ (BOOL)getHasSound;
+ (BOOL)getIsVibration;
+ (NSTimeInterval)getRefreshInterval;

@end
