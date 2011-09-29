//
//  MatchManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchManager.h"
#import "Match.h"
#import "MatchConstants.h"

#define FILTER_LEAGUE_ID_LIST       @"FILTER_LEAGUE_ID_LIST"

MatchManager* matchManager;

MatchManager* GlobalGetMatchManager()
{
    if (matchManager == nil){
        matchManager = [[MatchManager alloc] init];
    }
    
    return matchManager;
}

@implementation MatchManager

@synthesize matchArray;
@synthesize filterLeagueIdList;
@synthesize filterMatchStatus;
@synthesize filterMatchScoreType;

+ (MatchManager*)defaultManager
{
    return GlobalGetMatchManager();
}

- (void)saveFilterLeagueIdList
{
    if (filterLeagueIdList == nil || [filterLeagueIdList count] == 0)
        return;
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.filterLeagueIdList forKey:FILTER_LEAGUE_ID_LIST];
}

- (void)loadFilterLeagueIdList
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSSet* list = [userDefault objectForKey:FILTER_LEAGUE_ID_LIST];
    if (list != nil){
        [self.filterLeagueIdList addObjectsFromArray:[list allObjects]];
    }
}

- (id)init
{
    self = [super init];    
    self.filterLeagueIdList = [[NSMutableSet alloc] init];
    [self loadFilterLeagueIdList];
    return self;
}

- (void)dealloc
{
    [matchArray release];
    [filterLeagueIdList release];
    [super dealloc];
}

- (NSArray*)filterMatch
{
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    BOOL isCheckLeague = ([filterLeagueIdList count] > 0);
    for (Match* match in matchArray){
        
        if (filterMatchStatus != MATCH_SELECT_STATUS_ALL && 
            [match matchSelectStatus] != filterMatchStatus){
            // status not match, skip
//            NSLog(@"match status = %d, select status = %d", match.status, [match matchSelectStatus]);
            continue;
        }
        
        if (isCheckLeague == YES && [filterLeagueIdList containsObject:match.leagueId] == NO){
            continue;
        }

        [retArray addObject:match];
    }
    
    NSLog(@"filter match done, total %d match return", [retArray count]);
    return retArray;

}

- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist
{
    if (removeExist)
        [filterLeagueIdList removeAllObjects];
    
    [filterLeagueIdList addObjectsFromArray:[updateLeagueArray allObjects]];
}

- (void)updateFilterMatchStatus:(int)selectMatchStatus
{
    self.filterMatchStatus = selectMatchStatus;
}

//- (NSArray*)filterMatchByLeauge:(NSSet*)leagueIdArray
//{
//    self.filterLeagueIdList = leagueIdArray;
//    
//    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
//    for (Match* match in matchArray){
//        if ([leagueIdArray containsObject:match.leagueId]){
//            [retArray addObject:match];
//        }
//    }
//    return retArray;
//}

- (void)updateAllMatchArray:(NSArray*)updateArray
{
    self.matchArray = updateArray;
}

- (void)updateRealtimeMatchArray:(NSArray*)realtimeMatchArray
{
    // TODO
}

+ (NSArray*)parseMatchData:(NSString*)data
{
    NSMutableArray* matchArray = [[[NSMutableArray alloc] init] autorelease];
    
    
    
    return matchArray;
}

+ (NSArray*)fromString:(NSArray*)stringArray
{
    int count = [stringArray count];
    if (count == 0)
        return nil;
    
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<count; i++){
        NSArray* fields = [stringArray objectAtIndex:i];
        int fieldCount = [fields count];
        if (fieldCount != MATCH_FIELD_COUNT){
            NSLog(@"incorrect match field count = %d", fieldCount);
            continue;
        }
        
        Match* match = [[Match alloc] initWithId:[fields objectAtIndex:INDEX_MATCH_ID]
                                        leagueId:[fields objectAtIndex:INDEX_MATCH_LEAGUE_ID]
                                          status:[fields objectAtIndex:INDEX_MATCH_STATUS]
                                            date:[fields objectAtIndex:INDEX_MATCH_DATE]
                                       startDate:[fields objectAtIndex:INDEX_MATCH_START_DATE]
                                    homeTeamName:[fields objectAtIndex:INDEX_MATCH_HOME_TEAM_NAME]
                                    awayTeamName:[fields objectAtIndex:INDEX_MATCH_AWAY_TEAM_NAME]
                                   homeTeamScore:[fields objectAtIndex:INDEX_MATCH_HOME_TEAM_SCORE]
                                   awayTeamScore:[fields objectAtIndex:INDEX_MATCH_AWAY_TEAM_SCORE]
                          homeTeamFirstHalfScore:[fields objectAtIndex:INDEX_MATCH_HOME_TEAM_FIRST_HALF_SCORE]
                          awayTeamFirstHalfScore:[fields objectAtIndex:INDEX_MATCH_AWAY_TEAM_FIRST_HALF_SCORE]
                                     homeTeamRed:[fields objectAtIndex:INDEX_MATCH_HOME_TEAM_RED]
                                     awayTeamRed:[fields objectAtIndex:INDEX_MATCH_AWAY_TEAM_RED]
                                  homeTeamYellow:[fields objectAtIndex:INDEX_MATCH_HOME_TEAM_YELLOW]
                                  awayTeamYellow:[fields objectAtIndex:INDEX_MATCH_AWAY_TEAM_YELLOW]
                                     crownChuPan:[fields objectAtIndex:INDEX_MATCH_CROWN_CHUPAN]];
                        
                                                
        
#ifdef DEBUG
//        NSLog(@"add match : %@", [match description]);
#endif
        
        [retArray addObject:match];
        [match release];
    }
    
    NSLog(@"parse match data, total %d match added", [retArray count]);

    
    return retArray;
    
}

@end
