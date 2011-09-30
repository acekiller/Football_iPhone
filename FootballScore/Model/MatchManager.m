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
#define FOLLOW_MATCH_ID_LIST        @"FOLLOW_MATCH_ID_LIST"

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
@synthesize followMatchIdList;
@synthesize serverDate;

+ (MatchManager*)defaultManager
{
    return GlobalGetMatchManager();
}

#pragma LOAD/SAVE FILTER LEAGUE
#pragma mark

- (void)saveFilterLeagueIdList
{
    if (filterLeagueIdList == nil || [filterLeagueIdList count] == 0)
        return;
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[self.filterLeagueIdList allObjects] forKey:FILTER_LEAGUE_ID_LIST];
}

- (void)loadFilterLeagueIdList
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* list = [userDefault objectForKey:FILTER_LEAGUE_ID_LIST];
    if (list != nil){
        [self.filterLeagueIdList addObjectsFromArray:list];
    }
}

#pragma FOLLOW MATCH
#pragma mark

- (void)loadFollowMatchIdList
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* list = [userDefault objectForKey:FOLLOW_MATCH_ID_LIST];
    if (list != nil){
        [self.followMatchIdList addObjectsFromArray:list];
    }    
}

- (void)saveFollowMatchIdList
{
    if (followMatchIdList == nil || [followMatchIdList count] == 0)
        return;
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[self.followMatchIdList allObjects] forKey:FOLLOW_MATCH_ID_LIST];
}

- (void)followMatch:(Match*)match
{
    if (match == nil)
        return;
    
    [match setIsFollow:YES];
    [self.followMatchIdList addObject:match.matchId];
    [self saveFollowMatchIdList];
    
    NSLog(@"follow match (%@)", match.matchId);
}

- (void)unfollowMatch:(Match*)match
{
    if (match == nil)
        return;

    [match setIsFollow:NO];
    [self.followMatchIdList removeObject:match.matchId];    
    [self saveFollowMatchIdList];

    NSLog(@"unfollow match (%@)", match.matchId);
}

- (BOOL)isMatchFollowed:(NSString*)matchId
{
    if (matchId == nil)
        return NO;
    
    return [followMatchIdList containsObject:matchId];
}

#pragma INIT/DEALLOC
#pragma mark

- (id)init
{
    self = [super init];    
    filterLeagueIdList = [[NSMutableSet alloc] init];
    [self loadFilterLeagueIdList];
    
    followMatchIdList = [[NSMutableSet alloc] init];
    [self loadFollowMatchIdList];
    
    serverDate = [[NSDate date] retain];
    
    filterMatchStatus = MATCH_SELECT_STATUS_ALL;
    filterMatchScoreType = MATCH_SCORE_TYPE_ALL;
    
    return self;
}

- (void)dealloc
{
    [serverDate release];
    [matchArray release];
    [followMatchIdList release];
    [filterLeagueIdList release];
    [super dealloc];
}

- (NSArray*)filterMatch
{
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    BOOL isCheckLeague = ([filterLeagueIdList count] > 0);
    for (Match* match in matchArray){
        
        if (filterMatchStatus != MATCH_SELECT_STATUS_ALL && 
            filterMatchStatus != MATCH_SELECT_STATUS_MYFOLLOW &&
            [match matchSelectStatus] != filterMatchStatus){
            // status not match, skip
//            NSLog(@"match status = %d, select status = %d", match.status, [match matchSelectStatus]);
            continue;
        }
        
        if (filterMatchStatus == MATCH_SELECT_STATUS_MYFOLLOW &&
            [match isFollow] == NO){
            // follow required by the match is not followed
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

- (void)updateServerDate:(NSDate*)newServerDate
{
    if (newServerDate){        
        self.serverDate = newServerDate;
        serverDiffSeconds = [newServerDate timeIntervalSinceNow];
        NSLog(@"<updateServerDate> new date : %@, diff = %d", [serverDate description], serverDiffSeconds);
    }
}

- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist
{
    if (removeExist)
        [filterLeagueIdList removeAllObjects];
    
    [filterLeagueIdList addObjectsFromArray:[updateLeagueArray allObjects]];
    [self saveFilterLeagueIdList];
}

- (void)updateFilterMatchStatus:(int)selectMatchStatus
{
    self.filterMatchStatus = selectMatchStatus;
}

- (void)updateAllMatchArray:(NSArray*)updateArray
{
    self.matchArray = updateArray;
}

- (void)updateRealtimeMatchArray:(NSArray*)realtimeMatchArray
{
    // TODO
}

+ (NSArray*)fromString:(NSArray*)stringArray
{
    int count = [stringArray count];
    if (count == 0)
        return nil;
    
    MatchManager* manager = [MatchManager defaultManager];
    
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<count; i++){
        NSArray* fields = [stringArray objectAtIndex:i];
        int fieldCount = [fields count];
        if (fieldCount != MATCH_FIELD_COUNT){
            NSLog(@"incorrect match field count = %d", fieldCount);
            continue;
        }
        
        NSString* matchId = [fields objectAtIndex:INDEX_MATCH_ID];
        Match* match = [[Match alloc] initWithId:matchId
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
                                     crownChuPan:[fields objectAtIndex:INDEX_MATCH_CROWN_CHUPAN]
                                        isFollow:[manager isMatchFollowed:matchId]];
                        
                                                
        
#ifdef DEBUG
//        NSLog(@"add match : %@", [match description]);
#endif
        
        [retArray addObject:match];
        [match release];
    }
    
    NSLog(@"parse match data, total %d match added", [retArray count]);

    
    return retArray;
    
}


// 返回开赛动态时间秒数
- (NSNumber*)matchSeconds:(Match*)match
{
    if (match == nil)
        return nil;
    
    NSDate* startDate = nil;
    if (match.status == MATCH_STATUS_FIRST_HALF){

        if (match.firstHalfStartDate != nil)
            startDate = match.firstHalfStartDate;
        else if (match.date != nil)
            startDate = match.date;
        else
            return nil;
        
        int seconds = [startDate timeIntervalSinceNow] + serverDiffSeconds; // add server difference
        return [NSNumber numberWithInt:seconds];
    }
    else if (match.status == MATCH_STATUS_SECOND_HALF){
        if (match.secondHalfStartDate != nil)
            startDate = match.secondHalfStartDate;
        else if (match.date != nil)
            startDate = [match.date dateByAddingTimeInterval:45+15];    // 半场45分钟，中场休息15分钟
        else
            return nil;

        int seconds = [startDate timeIntervalSinceNow] + serverDiffSeconds; // add server difference
        return [NSNumber numberWithInt:seconds];
    }
    else{
        return nil;
    }
}

- (NSString*)matchSecondsString:(Match*)match
{
    NSNumber* seconds = [self matchSeconds:match];
    if (seconds == nil)
        return @"";
    else
        return [NSString stringWithFormat:@"%d'", [seconds intValue]];
}

@end
