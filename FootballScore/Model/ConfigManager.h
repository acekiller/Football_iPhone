//
//  ConfigManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigManager : NSObject {
    
}

+ (NSString*)getValue:(NSString*)configKey;
+ (void)setValue:(NSString*)configKey value:(NSString*)value;

@end
