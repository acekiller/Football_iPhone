//
//  LeagueManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LeagueManager.h"
#import "League.h"

enum{    
    LEAGUE_NAME,
    LEAGUE_ID,
    IS_TOP,
    LEAGUE_COUNT    
};

@implementation LeagueManager

+ (NSArray*)fromString:(NSArray*)stringArray
{    
    int count = [stringArray count];
    if (count == 0)
        return nil;
 
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<count; i++){
        NSArray* fields = [stringArray objectAtIndex:i];
        int fieldCount = [fields count];
        if (fieldCount != LEAGUE_COUNT){
            NSLog(@"incorrect league field count = %d", fieldCount);
            continue;
        }
        
        BOOL isTop = ([[fields objectAtIndex:IS_TOP] intValue] == 1);
        League* league = [[League alloc] initWithName:[fields objectAtIndex:LEAGUE_NAME]
                                             leagueId:[fields objectAtIndex:LEAGUE_ID]
                                                isTop:isTop];
        
#ifdef DEBUG
        NSLog(@"add league : %@", [league description]);
#endif
        
        [retArray addObject:league];
        [league release];
    }
    
    return retArray;
}

@end
