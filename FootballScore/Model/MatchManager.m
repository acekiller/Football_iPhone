//
//  MatchManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchManager.h"
#import "Match.h"
#import "MatchEvent.h"
#import "MatchStat.h"
#import "MatchConstants.h"
#import "TimeUtils.h"
#import "LeagueManager.h"

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

- (NSSet*)updateMatchRealtimeScore:(NSArray*)realtimeScoreStringArray
{
    if ([realtimeScoreStringArray count] == 0)
        return nil;
        
    NSMutableSet* retSet = [[[NSMutableSet alloc] init] autorelease];
    
    for (NSArray* fields in realtimeScoreStringArray){
        int fieldCount = [fields count];
        if (fieldCount < REALTIME_SCORE_FILED_COUNT){
            NSLog(@"<updateMatchRealtimeScore> get record but field count (%d) not enough!", fieldCount);
            continue;
        }
        else{
                        
            NSString* matchId = [fields objectAtIndex:INDEX_REALTIME_SCORE_MATCHID];
            Match* match = [self getMathById:matchId];
            if (match == nil){
                NSLog(@"<warning> cannot find match by match ID (%@)", matchId);
                continue;
            }
            
            [retSet addObject:matchId];
            
            NSString* status = [fields objectAtIndex:INDEX_REALTIME_SCORE_STATUS];
            NSString* dateString = [fields objectAtIndex:INDEX_REALTIME_SCORE_DATE];
            NSString* startDateString = [fields objectAtIndex:INDEX_REALTIME_SCORE_START_DATE];
            NSString* homeTeamScore = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_SCORE];
            NSString* awayTeamScore = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_SCORE];
            NSString* homeTeamFirstHalfScore = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_FIRST_HALF_SCORE];
            NSString* awayTeamFirstHalfScore = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_FIRST_HALF_SCORE];
            NSString* homeTeamRed = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_RED];
            NSString* awayTeamRed = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_RED];
            NSString* homeTeamYellow = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_YELLOW];
            NSString* awayTeamYellow = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_YELLOW];
            
            if ([status length]){
                [match setStatus:[status intValue]];
            }
            
            if ([dateString length]){
                [match setDate:dateFromChineseStringByFormat(dateString, DEFAULT_DATE_FORMAT)];
            }
                 
            if ([startDateString length]){
                [match updateStartDate:dateFromChineseStringByFormat(startDateString, DEFAULT_DATE_FORMAT)];
            }

            if ([homeTeamScore length]){
                [match setHomeTeamScore:homeTeamScore];
            }

            if ([awayTeamScore length]){
                [match setAwayTeamScore:awayTeamScore];
            }

            if ([homeTeamFirstHalfScore length]){
                [match setHomeTeamFirstHalfScore:homeTeamFirstHalfScore];
            }

            if ([awayTeamFirstHalfScore length]){
                [match setAwayTeamFirstHalfScore:awayTeamFirstHalfScore];
            }

            if ([homeTeamRed length]){
                [match setHomeTeamRed:homeTeamRed];
            }

            if ([awayTeamRed length]){
                [match setAwayTeamRed:awayTeamRed];
            }

            if ([homeTeamYellow length]){
                [match setHomeTeamYellow:homeTeamYellow];
            }

            if ([awayTeamYellow length]){
                [match setAwayTeamYellow:awayTeamYellow];
            }

            NSLog(@"match %@ updated, data=%@", matchId, [fields componentsJoinedByString:@" "]);
        }
    }
    
    return retSet;
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


- (Match *)getMathById:(NSString *)matchId
{
    if (matchId == nil) {
        return nil;
    }
    for (int i = 0; i < [self.matchArray count]; ++i) {
        Match *match = [self.matchArray objectAtIndex:i];
        if ([match.matchId isEqualToString:matchId]) {
            return match;
        }
    }
    return nil;
}

- (void)updateMatch:(Match*)match WithEventArray:(NSArray *)eventArray
{
    if (eventArray == nil || [eventArray count] == 0) {
        return;
    }
    if (match.events) {
        [match.events removeAllObjects];
    }else{
        match.events = [[NSMutableArray alloc] init];
    }
    [match.events removeAllObjects];
    for (NSArray *event in eventArray) {
        if ([event count] < 3) {
            break;
        }
        MatchEvent *matchEvent = [[MatchEvent alloc] init];
        matchEvent.homeAwayFlag = [[event objectAtIndex:0] intValue];
        matchEvent.type = [[event objectAtIndex:1] intValue];
        matchEvent.minutes = [[event objectAtIndex:2] intValue];
        if ([event count] > 3) {
            NSString *playerName = (NSString *)[event objectAtIndex:3] ;
            matchEvent.player = playerName;
        }else{
            matchEvent.player = nil;
        }
        [match.events addObject:matchEvent];
        [matchEvent release];
    }
}

- (void)updateMatch:(Match*)match WithStatArray:(NSArray *)statArray
{
    if (statArray == nil || [statArray count] == 0) {
        return;
    }
    if (match.stats) {
        [match.stats removeAllObjects];
    }else{
        match.stats = [[NSMutableArray alloc] init];
    }
    for (NSArray *stat in statArray) {
        if ([stat count] != 3) {
            break;
        }
        MatchStat *matchStat = [[MatchStat alloc] init];
        
        matchStat.type = [[stat objectAtIndex:0] intValue];
        matchStat.homeValue = [stat objectAtIndex:1];
        matchStat.awayValue = [stat objectAtIndex:2];
        [match.stats addObject:matchStat];
        
        [matchStat release];
    }
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
        
        NSDate* now = [NSDate date];
        int seconds = [now timeIntervalSinceDate:startDate] + serverDiffSeconds; // add server difference
        return [NSNumber numberWithInt:seconds];
    }
    else if (match.status == MATCH_STATUS_SECOND_HALF){
        if (match.secondHalfStartDate != nil)
            startDate = match.secondHalfStartDate;
        else if (match.date != nil)
            startDate = [match.date dateByAddingTimeInterval:(45+15)*60];    // 半场45分钟，中场休息15分钟
        else
            return nil;

        NSDate* now = [NSDate date];
        int HALF_MATCH_TIME = 45 * 60;       // 半场要加45分钟
        int seconds = [now timeIntervalSinceDate:startDate] + serverDiffSeconds + HALF_MATCH_TIME; // add server difference
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

- (NSString*)matchMinutesString:(Match*)match
{
    int MATCH_MAX_FIRST_HALF_TIME = 45*60;
    int MATCH_MAX_TIME = 90*60;    
    
    NSNumber* seconds = [self matchSeconds:match];
    if (seconds == nil){
        return @"";
    }
    else if (match.status == MATCH_STATUS_FIRST_HALF){
        if ([seconds intValue] <= MATCH_MAX_FIRST_HALF_TIME){
            return [NSString stringWithFormat:@"%d'", [seconds intValue]/60];
        }
        else{
            return @"45+";
        }
    }
    else if (match.status == MATCH_STATUS_SECOND_HALF){
        if ([seconds intValue] <= MATCH_MAX_TIME){
            return [NSString stringWithFormat:@"%d'", [seconds intValue]/60];
        }
        else{
            return @"90+";
        }
    }
    else{
        return @"";
    }
        
}
- (NSString *)getLeagueNameByMatch:(Match *)match
{
    if (match == nil) {
        return nil;
    }
    LeagueManager *leagueManager = [LeagueManager defaultManager];
    return [leagueManager getNameById:match.leagueId];
}

- (NSString *)getLeagueNameByMatchId:(NSString *)matchId
{
    Match *match = [self getMathById:matchId];
    return [self getLeagueNameByMatch:match];
}

- (int)getCurrentFollowMatchCount
{
    int count = 0;
    for (Match* match in matchArray){                
        if ([match isFollow]){
            count ++;
        }    
    }
    
    return count;
}

@end
