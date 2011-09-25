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
    
    NSString    *homeTeamMandarinName;      // from detail interface
    NSString    *awayTeamMandarinName;      // from detail interface
    
    NSString    *homeTeamCantonName;        // from detail interface
    NSString    *awayTeamCantonName;        // from detail interface

    NSString    *homeTeamImage;             // from detail interface
    NSString    *awayTeamImage;             // from detail interface
    
    NSString    *homeTeamLeaguePos;         // from detail interface
    NSString    *awayTeamLeaguePos;         // from detail interface

    BOOL        hasLineUp;                  // 是否有阵容
    
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
