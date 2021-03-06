//
//  LeagueManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LeagueManager.h"
#import "League.h"
#import "ColorManager.h"


enum{    
    LEAGUE_NAME,
    LEAGUE_ID,
    IS_TOP,
    LEAGUE_COUNT    
};

enum{    
    INDEX_LEAGUE_ID,
    INDEX_LEAGUE_NAME,
    INDEX_IS_TOP,
    INDEX_LEAGUE_COUNT    
};



@implementation LeagueManager

@synthesize leagueArray;
@synthesize leagueData;

- (id)init
{
    self = [super init];
    leagueArray = [[NSMutableArray alloc] init];
    leagueData = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)dealloc
{
    [leagueArray release];
    [leagueData release];
    [super dealloc];
}



// for match
+ (LeagueManager*)defaultManager
{
    return GlobalLeagueManager();
}




// for match Index
+ (LeagueManager*)defaultIndexManager
{
    return GlobalLeagueIndexManager();
}


+ (LeagueManager*)defaultLeagueScheduleManager
{
    return GlobalLeagueScheduleManager();
}


//for match 
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
        //        NSLog(@"add league : %@", [league description]);
#endif
        
        [retArray addObject:league];
        [league release];
    }
    
    NSLog(@"parse league data, total %d league added", [retArray count]);
    
    return retArray;
}

- (BOOL)hasLeaguageData
{
    if ([leagueArray count] > 0)
        return YES;
    else
        return NO;
}

//for index 
+(NSArray*)fromIndexString:(NSArray*)stringArray
{    
    int count = [stringArray count];
    if (count == 0)
        return nil;
    
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<count; i++){
        NSArray* fields = [stringArray objectAtIndex:i];
        int fieldCount = [fields count];
        if (fieldCount != INDEX_LEAGUE_COUNT){
            NSLog(@"incorrect league field count = %d", fieldCount);
            continue;
        }
        
        BOOL isTop = ([[fields objectAtIndex:INDEX_IS_TOP] intValue] == 1);
        League* league = [[League alloc] initWithName:[fields objectAtIndex:INDEX_LEAGUE_NAME]
                                             leagueId:[fields objectAtIndex:INDEX_LEAGUE_ID]
                                                isTop:isTop];
        
        
        
        
#ifdef DEBUG
        //        NSLog(@"add league : %@", [league description]);
#endif
        
        [retArray addObject:league];
        [league release];
    }
    
    NSLog(@"parse index league data, total %d league added", [retArray count]);
    
    return retArray;
}

- (void)updateLeague:(NSArray*)updateArray
{
    if ([updateArray count] > 0){
        [self.leagueArray removeAllObjects];
        [self.leagueArray addObjectsFromArray:updateArray];
        
        [self.leagueData removeAllObjects];
        for (League* league in leagueArray){
            if (league != nil && league.leagueId != nil){
                [leagueData setValue:league forKey:league.leagueId];
            }
            else{
                NSLog(@"WARNING <updateLeague> but league has nil league ID");
            }
        }
    }
}

- (NSString*)getNameById:(NSString*)leagueId
{
    if (leagueId == nil)
        return nil;
    
    League* league = [leagueData objectForKey:leagueId];
    return league.name;
}

- (UIColor*)getLeagueColorById:(NSString *)leagueId
{
    int colorIndex = [leagueId intValue]%5;
    switch (colorIndex) {
        case 0: {
            return [ColorManager leagueColor1]; 
        }
        case 1: {
            return [ColorManager leagueColor2];
        }
        case 2: {
            return [ColorManager leagueColor3];
        }
        case 3: {
            return [ColorManager leagueColor4];
        }
        case 4: {
            return [ColorManager leagueColor5];
        }
        default:
            break;
    }
    return [UIColor blackColor];
}

@end


// for match

LeagueManager* leagueManager;

LeagueManager* GlobalLeagueManager()
{
    if (leagueManager == nil){
        leagueManager = [[LeagueManager alloc] init];
    }
    
    return leagueManager;
}




// for match Index 

LeagueManager* leagueIndexManager;

LeagueManager* GlobalLeagueIndexManager()
{
    if (leagueIndexManager == nil){
        leagueIndexManager = [[LeagueManager alloc] init];
    }
    
    return leagueIndexManager;
}


LeagueManager* leagueScheduleManager;

LeagueManager* GlobalLeagueScheduleManager()
{
    if (leagueScheduleManager == nil){
        leagueScheduleManager = [[LeagueManager alloc] init];
    }
    
    return leagueScheduleManager;
}





