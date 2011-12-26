//
//  OddsManager.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OddsManager.h"
#import "match.h"
#import "TimeUtils.h"
#import "Odds.h"
#import "YaPei.h"
#import "DaXiao.h"
#import "OuPei.h"
#import "MatchManager.h"
#import "LogUtil.h"
#import "League.h"
#import "TimeUtils.h"

OddsManager* oddsManager;
OddsManager* GlobleGetOddsManager() 
{
    if (oddsManager == nil) {
        oddsManager = [[OddsManager alloc] init];
    }
    return oddsManager;
}

@implementation OddsManager

@synthesize matchArray;
@synthesize leagueArray;
@synthesize yapeiArray;
@synthesize oupeiArray;
@synthesize daxiaoArray;
@synthesize filterLeagueIdList;

+ (OddsManager*)defaultManager
{
    return GlobleGetOddsManager();
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.filterLeagueIdList = [[NSMutableSet alloc] init];
        self.matchArray = [[NSMutableArray alloc] init];
        self.leagueArray = [[NSMutableArray alloc] init];
        self.yapeiArray = [[NSMutableArray alloc] init];
        self.oupeiArray = [[NSMutableArray alloc] init];
        self.daxiaoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc

{   [self.filterLeagueIdList release];
    [self.matchArray release];
    [self.leagueArray release];
    [self.yapeiArray release];
    [self.oupeiArray release];
    [self.daxiaoArray release];
    [super dealloc];
}


- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist
{
    if (removeExist)
        [filterLeagueIdList removeAllObjects];
    
    [filterLeagueIdList addObjectsFromArray:[updateLeagueArray allObjects]];
    // [self saveFilterLeagueIdList];
}






- (NSArray*)filterMatchByLeagueIdList:(NSSet*)leagueIdList
{
    NSMutableArray* retArray = [[[NSMutableArray alloc] init] autorelease];
    for (Match* match in matchArray){
        
        if ([leagueIdList containsObject:match.leagueId] == NO){
            continue;
        }
        
        [retArray addObject:match];
    }
    
    PPDebug(@"filter match by league id array, total %d match return", [retArray count]);
    return retArray;
}

-(int)getHiddenMatchCount:(NSSet*)leagueIdSet{
    // count all matches 
    int totalCount = [matchArray count];
    
    int filterCount = [[self filterMatchByLeagueIdList:leagueIdSet] count];
    return totalCount - filterCount;
}





- (NSString*)getMatchTitleByMatchId:(NSString*)matchId
{
    for (Match* match in self.matchArray) {
        if ([matchId isEqualToString:match.matchId]) {
            return [NSString stringWithFormat:@"(%@)%@ vs %@",dateToString(match.date),match.homeTeamName,match.awayTeamName];
        }
    }
    return nil;
}

+ (void)addOdds:(Odds*)odds toDictionary:(NSMutableDictionary*)dict
{
    NSMutableArray * array;
    if ([dict objectForKey:odds.matchId] == nil) {
        array = [[NSMutableArray alloc] init];
        [array addObject:odds];
        [dict setObject:array forKey:odds.matchId];
        [array release];
    } else {
        array = [dict objectForKey:odds.matchId];
        [array addObject:odds];
        [dict setObject:array forKey:odds.matchId];
    }
}



- (Odds *)getOddsByMatchId:(NSString *)matchId companyId:(NSString *)companyId oddsType:(NSInteger)oddsType
{
    NSArray *oddsArray = nil;
    if (oddsType == ODDS_TYPE_YAPEI) {
        oddsArray = yapeiArray;
    }else if(oddsType == ODDS_TYPE_OUPEI)
    {
        oddsArray = oupeiArray;
    }else if(oddsType == ODDS_TYPE_DAXIAO){
        oddsArray = daxiaoArray;
    }else{
        return nil;
    }
    for (Odds *odds in oddsArray){
        if ([odds.matchId isEqualToString:matchId] && [odds.commpanyId isEqualToString:companyId]) {
            return odds;
        }
    }
    return nil;
}


- (NSSet *)getOddsUpdateSet:(NSArray *)realtimeOddsArray oddsType:(ODDS_TYPE)oddsType
{
    if (realtimeOddsArray == nil || [realtimeOddsArray count] == 0) {
        return nil;
    }
    
    NSMutableSet *retSet = [[[NSMutableSet alloc] init] autorelease];
    
    for (NSArray * data in realtimeOddsArray) {
        if (data && [data count] >= ODDS_REALTIME_INDEX_COUNT) {
            NSString *matchId = [data objectAtIndex:INDEX_OF_MATCH_ID_ODDS];
            NSString *companyId = [data objectAtIndex:INDEX_OF_COMPANY_ID_ODDS];
            NSString *awayTeamOdds = [data objectAtIndex:INDEX_OF_AWAY_ODDS];
            NSString *homeTeamOdds = nil;
            NSString *pankou = nil;
            
            if (oddsType == ODDS_TYPE_OUPEI) {
                homeTeamOdds = [data objectAtIndex:INDEX_OF_PANKOU];
                pankou = [data objectAtIndex:INDEX_OF_HOME_ODDS];
            }else{
                pankou = [data objectAtIndex:INDEX_OF_PANKOU];
                homeTeamOdds = [data objectAtIndex:INDEX_OF_HOME_ODDS];
            }
            
            //judge the change and call delegate method to update the interface
            Odds *odds = [[OddsManager defaultManager]getOddsByMatchId:matchId companyId:companyId oddsType:oddsType];
            
            if (odds) {
                switch ([odds oddsType]) {
                    case ODDS_TYPE_YAPEI:
                        [(YaPei *)odds updateHomeTeamOdds:homeTeamOdds awayTeamOdds:awayTeamOdds instantOdds:pankou];
                        break;
                    case ODDS_TYPE_OUPEI:
                        [(OuPei *)odds updateHomeWinInstantOdds:homeTeamOdds drawInstantOdds:pankou awayWinInstantsOdds:awayTeamOdds];
                        break;
                        
                    case ODDS_TYPE_DAXIAO:
                        [(DaXiao *)odds updateInstantOdds:pankou bigBallOdds:homeTeamOdds smallBallOdds:awayTeamOdds];
                        break;
                        
                    default:
                        break;
                }
 
                if (odds.homeTeamOddsFlag != 0 || 
                    odds.awayTeamOddsFlag != 0 || 
                    odds.pankouFlag != 0) {
                    [retSet addObject:odds];
                }
            }
            
        }
    }
    NSInteger count = [retSet count];
    PPDebug(@"<Odds Update>, total updated count = %d", count);
    return retSet;
}

- (NSString*)getLeagueIdByMatchId:(NSString*)matchId
{
    NSInteger mId = [matchId integerValue];
    for (Match* match in matchArray) {
        if (mId == [match.matchId integerValue]) {
            return match.leagueId;
        }
    }
    return nil;
}

- (BOOL)canDisplayOdds:(Odds*)odds date:(NSDate*)filterDate
{
    BOOL isToday = isChineseToday(filterDate);
    if (!isToday)   // the conditions only work for today
        return YES;
    
    MatchManager* matchManager = [MatchManager defaultMatchIndexManger];
    Match* match = [matchManager getMathById:odds.matchId];
    if (match == nil)
        return YES;
    
    if ([match.status intValue] == MATCH_STATUS_FINISH)  
        //The match has finished, don't display
    {
        return NO;
    }
    else if(([match.status intValue] == MATCH_STATUS_FIRST_HALF 
        || [match.status intValue] == MATCH_STATUS_MIDDLE 
        || [match.status intValue] == MATCH_STATUS_SECOND_HALF
        )
       && [match.date timeIntervalSinceNow]<=-15*60)  //The match has started, and more than 15 minutes
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSMutableDictionary*)filterOddsByOddsType:(int)oddsType date:(NSDate*)filterDate
{
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init ] autorelease];
    switch (oddsType) {
        case ODDS_TYPE_YAPEI: {
            for (Odds* odds in self.yapeiArray) {
                if ([self.filterLeagueIdList containsObject:[self getLeagueIdByMatchId:odds.matchId]] && [self canDisplayOdds:odds date:filterDate]) {
                    [OddsManager addOdds:odds toDictionary:dict];
                }
            }
        }
            break;
        case ODDS_TYPE_OUPEI: {
            for (Odds* odds in self.oupeiArray) {
                if ([self.filterLeagueIdList containsObject:[self getLeagueIdByMatchId:odds.matchId]] && [self canDisplayOdds:odds date:filterDate]) {
                    [OddsManager addOdds:odds toDictionary:dict];
                }
            }
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            for (Odds* odds in self.daxiaoArray) {
                if ([self.filterLeagueIdList containsObject:[self getLeagueIdByMatchId:odds.matchId]] && [self canDisplayOdds:odds date:filterDate]) {
                    [OddsManager addOdds:odds toDictionary:dict];
                }
            }
        }
            break;
        default:
            break;
    }
    return dict;
    
}

- (void)selectAllLeague
{
    [self.filterLeagueIdList removeAllObjects];
    for (League* league in leagueArray) {
        [self.filterLeagueIdList addObject:league.leagueId];
    }
}

- (void)selectTopLeague
{
    [self.filterLeagueIdList removeAllObjects];
    for (League* league in leagueArray) {
        if ([league isTop])
        [self.filterLeagueIdList addObject:league.leagueId];
    }
}

- (BOOL)hasLeagueData
{
    if ([self.leagueArray count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
