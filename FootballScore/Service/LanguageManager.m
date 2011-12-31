//
//  LanguageManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.

//  lang=0 国语 1 粤语 2简体(皇冠)

#import "LanguageManager.h"

#define LANGUAGE_KEY @"language"

static NSNumber *langId = nil;

@implementation LanguageManager

+(NSInteger)getLanguage
{
    if (langId == nil) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        langId = [userDefault objectForKey:LANGUAGE_KEY];
        //set default value = 0
        if (langId == nil) {
            langId = [NSNumber numberWithInt:0];
            [LanguageManager setLanguage:0];
        }
    }
    return [langId integerValue];
}

+(void) setLanguage:(NSInteger)lang
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    langId = [NSNumber numberWithInt:lang];
    [userDefault setObject:langId forKey:LANGUAGE_KEY];
    [userDefault synchronize];
}

@end

#define SIMPLE @"SimpleChinese"
#define MANDARIN @"Mandarin"
#define CANTONESE @"Cantonese"

NSString *fnsWithLang(NSString *msg, NSInteger lang)
{
    // changed by Benson
    NSString* ret = NSLocalizedStringFromTable(msg, MANDARIN, nil);
    if ([ret length] == 0)
        return msg;
    else
        return ret;
    
    // old implementation, NOT used now
    switch (lang) {
        case 0:
            return NSLocalizedStringFromTable(msg, MANDARIN, nil);
        case 1:
            return NSLocalizedStringFromTable(msg, CANTONESE, nil);            
        case 2:
            return NSLocalizedStringFromTable(msg, SIMPLE, nil);            
        default:
            return NSLocalizedStringFromTable(msg, MANDARIN, nil);
    }
}

NSString *fns(NSString *msg)
{
    NSInteger lang = [LanguageManager getLanguage];
    return fnsWithLang(msg, lang);
}