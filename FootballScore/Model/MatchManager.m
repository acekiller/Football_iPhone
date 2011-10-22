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
#import "ScoreUpdateManager.h"
#import "ScoreUpdate.h"
#import "LogUtil.h"

#define FILTER_LEAGUE_ID_LIST       @"FILTER_LEAGUE_ID_LIST"
#define FOLLOW_MATCH_LIST        @"FOLLOW_MATCH_LIST"

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
@synthesize followMatchList;
@synthesize serverDate;
@synthesize followMatchArray;

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

- (void)loadFollowMatchList
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* listData = [userDefault objectForKey:FOLLOW_MATCH_LIST];
    NSMutableDictionary *getFollowMatchList = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    self.followMatchList = getFollowMatchList;                 
}

- (void)saveFollowMatchList
{
    if (followMatchList == nil)
        return;
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData *followList = [NSKeyedArchiver archivedDataWithRootObject:self.followMatchList];
    [userDefault setObject:followList forKey:FOLLOW_MATCH_LIST];

}

- (void)followMatch:(Match*)match
{
    if (match == nil)
        return;
    
    [match setIsFollow:[NSNumber numberWithBool:YES]];
    
    if ([followMatchList objectForKey:match.matchId] == nil){
        
        [self.followMatchList setObject:match forKey:match.matchId];
        [self saveFollowMatchList];
        
        PPDebug(@"follow match (%@)", [match description]);
    }
    
}

- (void)unfollowMatch:(Match*)match
{
    if (match == nil)
        return;

    [match setIsFollow:[NSNumber numberWithBool:NO]];
    [self.followMatchList removeObjectForKey:match.matchId];    
    [self saveFollowMatchList];

    PPDebug(@"unfollow match (%@)", [match description]);
}

- (BOOL)isMatchFollowed:(NSString*)matchId
{
    if (matchId == nil || followMatchList == nil)
        return NO;
    if ([followMatchList objectForKey:matchId] == nil) {
        return NO;
    } else {
        return YES;
    }

}

#pragma INIT/DEALLOC
#pragma mark

- (id)init
{
    self = [super init];    
    filterLeagueIdList = [[NSMutableSet alloc] init];
    [self loadFilterLeagueIdList];
    
    followMatchList = [[NSMutableDictionary alloc] init];
    [self loadFollowMatchList];
    
    serverDate = [[NSDate date] retain];
    
    filterMatchStatus = MATCH_SELECT_STATUS_ALL;
    filterMatchScoreType = MATCH_SCORE_TYPE_ALL;
    
    return self;
}

- (void)dealloc
{
    [followMatchArray release];
    [serverDate release];
    [matchArray release];
    [followMatchList release];
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
//            PPDebug(@"match status = %d, select status = %d", match.status, [match matchSelectStatus]);
            continue;
        }
        
        if (filterMatchStatus == MATCH_SELECT_STATUS_MYFOLLOW &&
            match.isFollow == [NSNumber numberWithBool:NO]){
            // follow required by the match is not followed
            continue;
        }
        
        if (isCheckLeague == YES && [filterLeagueIdList containsObject:match.leagueId] == NO){
            continue;
        }

        [retArray addObject:match];
    }
        
    PPDebug(@"filter match done, total %d match return", [retArray count]);
    return retArray;

}

- (void)updateServerDate:(NSDate*)newServerDate
{
    if (newServerDate){        
        self.serverDate = newServerDate;
        serverDiffSeconds = [newServerDate timeIntervalSinceNow];
        PPDebug(@"<updateServerDate> new date : %@, diff = %d", [serverDate description], serverDiffSeconds);
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
    
    for (Match *match in updateArray) {
        [self updateFollowMatch:match];
    }
    
    // TODO save match if match is followed
    
}

- (void)updateRealtimeMatchArray:(NSArray*)realtimeMatchArray
{
    // TODO do what??? 
}

- (NSSet *)getScoreUpdateSet:(NSArray *)realtimeScoreStringArray
{
    if ([realtimeScoreStringArray count] == 0)
        return nil;
    
    NSMutableSet* retSet = [[[NSMutableSet alloc] init] autorelease];
    MatchManager *matchManager = [MatchManager defaultManager];
    for (NSArray* fields in realtimeScoreStringArray){
        int fieldCount = [fields count];
        if (fieldCount < REALTIME_SCORE_FILED_COUNT){
            PPDebug(@"<updateMatchRealtimeScore> get record but field count (%d) not enough!", fieldCount);
            continue;
        }
        else{
            
            NSString* matchId = [fields objectAtIndex:INDEX_REALTIME_SCORE_MATCHID];
            Match* match = [self getMathById:matchId];
            if (match == nil){
                PPDebug(@"<warning> cannot find match by match ID (%@)", matchId);
                continue;
            }
            NSString* homeTeamScore = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_SCORE];
            NSString* awayTeamScore = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_SCORE];
            NSString* homeTeamRed = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_RED];
            NSString* awayTeamRed = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_RED];
            NSString* homeTeamYellow = [fields objectAtIndex:INDEX_REALTIME_SCORE_HOME_TEAM_YELLOW];
            NSString* awayTeamYellow = [fields objectAtIndex:INDEX_REALTIME_SCORE_AWAY_TEAM_YELLOW];
        
            //home team score update
            int increase = [homeTeamScore intValue] - [matchManager getHomeTeamScore:match];
            if (increase > 0) {
                ScoreUpdate *homeScoreUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMSCORE];
                [retSet addObject:homeScoreUpdate];
                [homeScoreUpdate release];
                
                PPDebug(@"match (%@) has realtime update, home team score, value = %d", [match description], increase);
                
                [match updateScoreModifyTime];
            }
            
            //away team score update
            increase = [awayTeamScore intValue] - [matchManager getAwayTeamScore:match];
            if (increase > 0) {
                ScoreUpdate *awayScoreUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:AWAYTEAMSCORE];
                [retSet addObject:awayScoreUpdate];
                [awayScoreUpdate release];

                PPDebug(@"match (%@) has realtime update, away team score, value = %d", [match description], increase);
                
                [match updateScoreModifyTime];
            }
            
            //home team red card update
            increase = [homeTeamRed intValue] - [matchManager getHomeTeamRedCount:match];
            if (increase > 0) {
                ScoreUpdate *homeRedUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMRED];
                [retSet addObject:homeRedUpdate];
                [homeRedUpdate release];
                
                PPDebug(@"match (%@) has realtime update, home team RED, value = %d", [match description], increase);                
            }
            
            //away team red card update
            increase = [awayTeamRed intValue] - [matchManager getAwayTeamRedCount:match];
            if (increase > 0) {
                ScoreUpdate *awayRedUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:AWAYTEAMRED];
                [retSet addObject:awayRedUpdate];
                [awayRedUpdate release];
                
                PPDebug(@"match (%@) has realtime update, away team RED, value = %d", [match description], increase);                
            }
            
            //home team yellow card update
            increase = [homeTeamYellow intValue] - [matchManager getHomeTeamYellowCount:match];
            if (increase > 0) {
                ScoreUpdate *homeYellowUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMYELLOW];
                [retSet addObject:homeYellowUpdate];
                [homeYellowUpdate release];
                
                PPDebug(@"match (%@) has realtime update, home team YELLOW, value = %d", [match description], increase);                                
            }
            
            //away team yellow card update
            increase = [awayTeamYellow intValue] - [matchManager getAwayTeamYellowCount:match];
            if (increase > 0) {
                ScoreUpdate *awayYellowUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:AWAYTEAMYELLOW];
                [retSet addObject:awayYellowUpdate];
                [awayYellowUpdate release];
                
                PPDebug(@"match (%@) has realtime update, away team YELLOW, value = %d", [match description], increase);                                
            }

        }
    } 
    return retSet;

}

- (NSSet *)updateMatchRealtimeScore:(NSArray*)realtimeScoreStringArray
{
    if ([realtimeScoreStringArray count] == 0)
        return nil;
        
    NSMutableSet* retSet = [[[NSMutableSet alloc] init] autorelease];
    
    for (NSArray* fields in realtimeScoreStringArray){
        int fieldCount = [fields count];
        if (fieldCount < REALTIME_SCORE_FILED_COUNT){
            PPDebug(@"<updateMatchRealtimeScore> get record but field count (%d) not enough!", fieldCount);
            continue;
        }
        else{
           
            NSString* matchId = [fields objectAtIndex:INDEX_REALTIME_SCORE_MATCHID];
            Match* followMatch = [self getFollowMatchById:matchId];
            [self updateMatch:followMatch ByFields:fields];
            Match* match = [self getMathById:matchId];
            
            if (match == nil){
                PPDebug(@"<warning> cannot find match by match ID (%@)", matchId);
                continue;
            }
            
            [retSet addObject:matchId];
            
            [self updateMatch:match ByFields:fields];
            
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
            PPDebug(@"incorrect match field count = %d", fieldCount);
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
//        PPDebug(@"add match : %@", [match description]);
#endif
        
        [retArray addObject:match];
        [match release];
    }
    
    PPDebug(@"parse match data, total %d match added", [retArray count]);

    
    return retArray;
    
}

- (NSArray*)updateMatchFromString:(NSArray*)stringArray
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
            PPDebug(@"incorrect match field count = %d", fieldCount);
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
        //        PPDebug(@"add match : %@", [match description]);
#endif
        
        [retArray addObject:match];
        [match release];
    }
    
    PPDebug(@"parse match data, total %d match added", [retArray count]);
    
    
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

- (Match *)getFollowMatchById:(NSString *)matchId
{
    if (matchId == nil) {
        return nil;
    }
    for (Match* match in [self.followMatchList allValues]) {
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
    if ([match.status intValue] == MATCH_STATUS_FIRST_HALF){

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
    else if ([match.status intValue]== MATCH_STATUS_SECOND_HALF){
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
    else if ([match.status intValue] == MATCH_STATUS_FIRST_HALF){
        if ([seconds intValue] <= MATCH_MAX_FIRST_HALF_TIME){
            return [NSString stringWithFormat:@"%d'", [seconds intValue]/60];
        }
        else{
            return @"45+";
        }
    }
    else if ([match.status intValue] == MATCH_STATUS_SECOND_HALF){
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
        if (match.isFollow == [NSNumber numberWithBool:YES]){
            count ++;
        }    
    }
    
    return count;
}


- (int)getHomeTeamRedCount:(Match *)match
{
    if (match) {
        if (match.homeTeamRed) {
            return [match.homeTeamRed intValue];
        }
    }
    return 0;
}
- (int)getAwayTeamRedCount:(Match *)match
{
    if (match) {
        if (match.awayTeamRed) {
            return [match.awayTeamRed intValue];
        }
    }
    return 0;
}
- (int)getHomeTeamYellowCount:(Match *)match
{
    {
        if (match) {
            if (match.homeTeamYellow) {
                return [match.homeTeamYellow intValue];
            }
        }
        return 0;
    }
}
- (int)getAwayTeamYellowCount:(Match *)match
{
    {
        if (match) {
            if (match.awayTeamYellow) {
                return [match.awayTeamYellow intValue];
            }
        }
        return 0;
    }
}

- (int)getHomeTeamScore:(Match *)match
{
    if (match) {
        if (match.homeTeamScore) {
            return [match.homeTeamScore intValue];
        }
    }
    return 0;
}
- (int)getAwayTeamScore:(Match *)match
{
    if (match) {
        if (match.awayTeamScore) {
            return [match.awayTeamScore intValue];
        }
    }
    return 0;
}

- (NSArray*)getAllFollowMatch
{
    return [followMatchList allValues];
}

- (void)updateFollowMatch:(Match*)match
{
    Match *matchInFollow = [self.followMatchList objectForKey:match.matchId];
    if (matchInFollow != nil) {
        [matchInFollow updateByMatch:match];
    }
}

- (void)updateMatch:(Match*)match ByFields:(NSArray*)fields
{
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
        [match setStatus:[NSNumber numberWithInt:[status intValue]]];
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
    
    PPDebug(@"match %@ updated, data=%@", 
            [match description], [fields componentsJoinedByString:@" "]);
}

@end
