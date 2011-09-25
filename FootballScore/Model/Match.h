//
//  Match.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Match : NSObject {
    
    NSString    *matchId;
    NSString    *leagueId;
    int         status;
    NSDate      *date;
    NSDate      *firstHalfStartDate;
    NSDate      *secondHalfStartDate;
    
    NSString    *homeTeamName;
    NSString    *awayTeamName;

    int         homeTeamScore;
    int         awayTeamScore;
    
    int         homeTeamFirstHalfScore;
    int         awayTeamFirstHalfScore;
    
    int         homeTeamRed;
    int         awayTeamRed;
    
    int         homeTeamYellow;
    int         awayTeamYellow;
    
    float       crownChuPan;
    
    NSMutableArray  *events;
    NSMutableArray  *stats;
}

@end
