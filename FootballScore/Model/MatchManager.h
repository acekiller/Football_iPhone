//
//  MatchManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Match;

@interface MatchManager : NSObject {
    
    NSArray* matchArray;
    
    NSMutableSet*   filterLeagueIdList;
    int             filterMatchStatus;
    int             filterMatchScoreType;
    
    NSDate*         serverDate;
    int             serverDiffSeconds;
    
    NSMutableSet*   followMatchIdList;
}

@property (nonatomic, retain) NSDate*           serverDate;
@property (nonatomic, retain) NSArray*          matchArray;
@property (nonatomic, retain) NSMutableSet*     filterLeagueIdList;
@property (nonatomic, retain) NSMutableSet*     followMatchIdList;
@property (nonatomic, assign) int               filterMatchStatus;
@property (nonatomic, assign) int               filterMatchScoreType;


+ (MatchManager*)defaultManager;
+ (NSArray*)fromString:(NSArray*)stringArray;

- (void)updateServerDate:(NSDate*)newServerDate;
- (void)updateAllMatchArray:(NSArray*)updateArray;
- (void)updateRealtimeMatchArray:(NSArray*)realtimeMatchArray;
- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist;
- (void)updateFilterMatchStatus:(int)selectMatchStatus;



// follow match methods
- (void)followMatch:(Match*)match;
- (void)unfollowMatch:(Match*)match;
- (BOOL)isMatchFollowed:(NSString*)matchId;


// filter match by conditions : league, match status, match score type
- (NSArray*)filterMatch;

// 返回开赛从上半场／下半场开始动态时间（秒）
- (NSNumber*)matchSeconds:(Match*)match;
- (NSString*)matchSecondsString:(Match*)match;


@end
