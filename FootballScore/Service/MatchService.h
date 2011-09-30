//
//  MatchService.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "MatchEvent.h"
#import "MatchStat.h"

@class Match;

@protocol MatchServiceDelegate <NSObject>

@optional
- (void)getRealtimeMatchFinish:(int)result
                    serverDate:(NSDate*)serverDate
                   leagueArray:(NSArray*)leagueArray
              updateMatchArray:(NSArray*)updateMatchArray;

- (void)getMatchEventFinish:(int)result match:(Match *)match;
@end

@interface MatchService : CommonService {
    
}

- (void)getRealtimeMatch:(id<MatchServiceDelegate>)delegate matchScoreType:(int)matchScoreType;

- (void)getMatchEvent:(id<MatchServiceDelegate>)delegate matchId:(NSString *)matchId;

@end

extern MatchService *GlobalGetMatchService();