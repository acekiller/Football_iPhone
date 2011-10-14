//
//  LanguageManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LanguageManager.h"

#define LANGUAGE_KEY @"language"

@implementation LanguageManager

+(NSInteger)getLanguage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger lang =  [userDefault integerForKey:LANGUAGE_KEY];
    return lang;
}

+(void) setLanguage:(NSInteger)lang
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:lang forKey:LANGUAGE_KEY];
    [userDefault synchronize];
}

@end
