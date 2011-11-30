//
//  ConfigManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HAS_SOUND @"HAS_SOUND"
#define IS_VIBRATION @"HAS_IS_VIBRATION"

@interface ConfigManager : NSObject {
    
}

//+ (NSString*)getValue:(NSString*)configKey;
//+ (void)setValue:(NSString*)configKey value:(NSString*)value;

+ (void)saveHasSound:(BOOL)hasSound;
+ (void)saveIsVibration:(BOOL)isVibration;

+ (BOOL)getHasSound;
+ (BOOL)getIsVibration;

@end
