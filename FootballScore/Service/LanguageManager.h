//
//  LanguageManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSNumber *langId = nil;
@interface LanguageManager : NSObject {

}

+(NSInteger)getLanguage;
+(void) setLanguage:(NSInteger)lang;

@end

NSString *fns(NSString *msg);
NSString *fnsWithLang(NSString *msg, NSInteger lang);