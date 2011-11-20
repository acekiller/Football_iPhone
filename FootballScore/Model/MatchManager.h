//
//  MatchManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Match;
@class MatchEvent;
@class MatchStat;

@interface MatchManager : NSObject {
    
    NSArray* matchArray;
    
    NSMutableSet*   filterLeagueIdList;
    int             filterMatchStatus;
    int             filterMatchScoreType;
    
    NSDate*         serverDate;
    int             serverDiffSeconds;
    
    
    int hidedMatches;
    
    
    NSMutableDictionary*   followMatchList;
}

@property (nonatomic, retain) NSDate*           serverDate;
@property (nonatomic, retain) NSArray*          matchArray;
@property (nonatomic, retain) NSMutableSet*     filterLeagueIdList;
@property (nonatomic, retain) NSMutableDictionary*     followMatchList;
@property (nonatomic, assign) int               filterMatchStatus;
@property (nonatomic, assign) int               filterMatchScoreType;
@property (nonatomic, retain) NSMutableArray*   followMatchArray;


+ (MatchManager *)defaultManager;
+ (MatchManager *)defaultMatchIndexManger;
+ (NSArray*)fromString:(NSArray*)stringArray;

- (void)updateServerDate:(NSDate*)newServerDate;
- (void)updateAllMatchArray:(NSArray*)updateArray;
- (void)updateRealtimeMatchArray:(NSArray*)realtimeMatchArray;
- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist;
- (void)updateFilterMatchStatus:(int)selectMatchStatus;

- (NSSet*)updateMatchRealtimeScore:(NSArray*)realtimeScoreStringArray;
- (NSSet *)getScoreUpdateSet:(NSArray *)realtimeScoreStringArray;
- (Match *)getMathById:(NSString *)matchId;
- (Match *)getFollowMatchById:(NSString *)matchId;

// follow match methods
- (void)followMatch:(Match*)match;
- (void)unfollowMatch:(Match*)match;
- (BOOL)isMatchFollowed:(NSString*)matchId;
- (NSArray*)getAllFollowMatch;
- (void)updateFollowMatch:(Match*)match;
- (void)updateMatch:(Match*)match ByFields:(NSArray*)fields;

- (NSString *)getLeagueNameByMatchId:(NSString *)matchId;
- (NSString *)getLeagueNameByMatch:(Match *)match;

// filter match by conditions : league, match status, match score type
- (NSArray*)filterMatch;
- (BOOL) isFilter:(Match *)match;

// match event && static method
- (void)updateMatch:(Match*)match WithEventArray:(NSArray *)eventArray;
- (void)updateMatch:(Match*)match WithStatArray:(NSArray *)statArray;

// 返回开赛从上半场／下半场开始动态时间（秒）
- (NSNumber*)matchSeconds:(Match*)match;
- (NSString*)matchSecondsString:(Match*)match;
- (NSString*)matchMinutesString:(Match*)match;

- (int)getCurrentFollowMatchCount;

- (int)getHomeTeamRedCount:(Match *)match;
- (int)getAwayTeamRedCount:(Match *)match;
- (int)getHomeTeamYellowCount:(Match *)match;
- (int)getAwayTeamYellowCount:(Match *)match;

- (int)getHomeTeamScore:(Match *)match;
- (int)getAwayTeamScore:(Match *)match;


//get hided Matches
//-(void)getTheHidedMatches:(int)hidedMatches;
-(int)getHiddenMatchCount:(NSSet*)leagueIdSet;


@end
