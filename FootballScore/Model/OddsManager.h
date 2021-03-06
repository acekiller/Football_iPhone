//
//  OddsManager.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Odds.h"
@class YaPei;
@class OuPei;
@class DaXiao;

enum ODDS_REALTIME_INDEX {
    INDEX_OF_MATCH_ID_ODDS = 0,
    INDEX_OF_COMPANY_ID_ODDS = 1,
    INDEX_OF_PANKOU = 2,
    INDEX_OF_HOME_ODDS = 3,
    INDEX_OF_AWAY_ODDS = 4,
    ODDS_REALTIME_INDEX_COUNT = 5
};


@interface OddsManager : NSObject {
    NSMutableArray *leagueArray;
    NSMutableArray *matchArray;
    NSMutableArray *yapeiArray;
    NSMutableArray *oupeiArray;
    NSMutableArray *daxiaoArray;
    
}


@property (nonatomic, retain) NSMutableSet* filterLeagueIdList;

@property (nonatomic, retain) NSMutableArray* matchArray;
@property (nonatomic, retain) NSMutableArray* leagueArray;
@property (nonatomic, retain) NSMutableArray* yapeiArray;
@property (nonatomic, retain) NSMutableArray* oupeiArray;
@property (nonatomic, retain) NSMutableArray* daxiaoArray;

+ (OddsManager*)defaultManager;
- (NSString*)getMatchTitleByMatchId:(NSString*)matchId;
+ (void)addOdds:(Odds*)odds toDictionary:(NSMutableDictionary*)dict;
- (Odds *)getOddsByMatchId:(NSString *)matchId companyId:(NSString *)companyId oddsType:(NSInteger)oddsType;

- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist;

- (NSSet *)getOddsUpdateSet:(NSArray *)realtimeOddsArray oddsType:(ODDS_TYPE)oddsType;
-(int)getHiddenMatchCount:(NSSet*)leagueIdSet;
- (NSString*)getLeagueIdByMatchId:(NSString*)matchId;
- (NSMutableDictionary*)filterOddsByOddsType:(int)oddsType date:(NSDate*)filterDate;
- (void)selectAllLeague;
- (void)selectTopLeague;

- (BOOL)canDisplayOdds:(Odds*)odds date:(NSDate*)filterDate;
- (BOOL)hasLeagueData;

@end
