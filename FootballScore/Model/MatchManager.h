//
//  MatchManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MatchManager : NSObject {
    
}

+ (NSArray*)parseMatchData:(NSString*)data;
+ (NSArray*)fromString:(NSArray*)stringArray;

@end
