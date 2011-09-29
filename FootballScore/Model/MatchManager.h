//
//  MatchManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MatchManager : NSObject {
    
    NSArray* matchArray;
    
    NSMutableSet*   filterLeagueIdList;
    int             filterMatchStatus;
    int             filterMatchScoreType;
}

@property (nonatomic, retain) NSArray*          matchArray;
@property (nonatomic, retain) NSMutableSet*     filterLeagueIdList;
@property (nonatomic, assign) int               filterMatchStatus;
@property (nonatomic, assign) int               filterMatchScoreType;


+ (MatchManager*)defaultManager;
+ (NSArray*)parseMatchData:(NSString*)data;
+ (NSArray*)fromString:(NSArray*)stringArray;

- (void)updateAllMatchArray:(NSArray*)updateArray;
- (void)updateRealtimeMatchArray:(NSArray*)realtimeMatchArray;
- (void)updateFilterLeague:(NSSet*)updateLeagueArray removeExist:(BOOL)removeExist;
- (void)updateFilterMatchStatus:(int)selectMatchStatus;
//- (NSArray*)filterMatchByLeauge:(NSSet*)leagueIdArray;

// filter match by conditions : league, match status, match score type
- (NSArray*)filterMatch;

@end
