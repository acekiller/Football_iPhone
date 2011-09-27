//
//  Match.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    INDEX_MATCH_ID,
    INDEX_MATCH_LEAGUE_ID,
    INDEX_MATCH_STATUS,
    INDEX_MATCH_DATE,
    INDEX_MATCH_START_DATE,
    INDEX_MATCH_HOME_TEAM_NAME,
    INDEX_MATCH_AWAY_TEAM_NAME,
    INDEX_MATCH_HOME_TEAM_SCORE,
    INDEX_MATCH_AWAY_TEAM_SCORE,
    INDEX_MATCH_HOME_TEAM_FIRST_HALF_SCORE,
    INDEX_MATCH_AWAY_TEAM_FIRST_HALF_SCORE,
    INDEX_MATCH_HOME_TEAM_RED,
    INDEX_MATCH_AWAY_TEAM_RED,
    INDEX_MATCH_HOME_TEAM_YELLOW,
    INDEX_MATCH_AWAY_TEAM_YELLOW,
    INDEX_MATCH_CROWN_CHUPAN,
    MATCH_FIELD_COUNT
};

enum{
  
    MATCH_STATUS_FIRST_HALF = 1,
    MATCH_STATUS_MIDDLE,
    MATCH_STATUS_SECOND_HALF
};


@interface Match : NSObject {
    
    int         sportsType;                 // football, basketball, etc
    
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
    
    NSString    *homeTeamScore;
    NSString    *awayTeamScore;
    
    NSString    *homeTeamFirstHalfScore;
    NSString    *awayTeamFirstHalfScore;
    
    NSString    *homeTeamRed;
    NSString    *awayTeamRed;
    
    NSString    *homeTeamYellow;
    NSString    *awayTeamYellow;
    
    float       crownChuPan;
    
    NSMutableArray  *events;
    NSMutableArray  *stats;
}

@property (nonatomic, retain) NSString    *matchId;
@property (nonatomic, retain) NSString    *leagueId;
@property (nonatomic, assign) int         status;
@property (nonatomic, retain) NSDate      *date;
@property (nonatomic, retain) NSDate      *firstHalfStartDate;
@property (nonatomic, retain) NSDate      *secondHalfStartDate;

@property (nonatomic, retain) NSString    *homeTeamName;
@property (nonatomic, retain) NSString    *awayTeamName;

@property (nonatomic, retain) NSString    *homeTeamMandarinName;      // from detail interface
@property (nonatomic, retain) NSString    *awayTeamMandarinName;      // from detail interface

@property (nonatomic, retain) NSString    *homeTeamCantonName;        // from detail interface
@property (nonatomic, retain) NSString    *awayTeamCantonName;        // from detail interface

@property (nonatomic, retain) NSString    *homeTeamImage;             // from detail interface
@property (nonatomic, retain) NSString    *awayTeamImage;             // from detail interface

@property (nonatomic, retain) NSString    *homeTeamLeaguePos;         // from detail interface
@property (nonatomic, retain) NSString    *awayTeamLeaguePos;         // from detail interface

@property (nonatomic, assign) BOOL        hasLineUp;                  // 是否有阵容

@property (nonatomic, retain) NSString    *homeTeamScore;
@property (nonatomic, retain) NSString    *awayTeamScore;

@property (nonatomic, retain) NSString    *homeTeamFirstHalfScore;
@property (nonatomic, retain) NSString    *awayTeamFirstHalfScore;

@property (nonatomic, retain) NSString    *homeTeamRed;
@property (nonatomic, retain) NSString    *awayTeamRed;

@property (nonatomic, retain) NSString    *homeTeamYellow;
@property (nonatomic, retain) NSString    *awayTeamYellow;

@property (nonatomic, assign) float       crownChuPan;

@property (nonatomic, retain) NSMutableArray  *events;
@property (nonatomic, retain) NSMutableArray  *stats;

- (id)          initWithId:(NSString*)idValue
                  leagueId:(NSString*)leagueIdValue
                    status:(NSString*)statusValue
                      date:(NSString*)dateValue
                 startDate:(NSString*)startDateValue
              homeTeamName:(NSString*)homeTeamNameValue
              awayTeamName:(NSString*)awayTeamNameValue
             homeTeamScore:(NSString*)homeTeamScoreValue
             awayTeamScore:(NSString*)awayTeamScoreValue
    homeTeamFirstHalfScore:(NSString*)homeTeamFirstHalfScoreValue
    awayTeamFirstHalfScore:(NSString*)awayTeamFirstHalfScoreValue
               homeTeamRed:(NSString*)homeTeamRedValue
               awayTeamRed:(NSString*)awayTeamRedValue
            homeTeamYellow:(NSString*)homeTeamYellowValue
            awayTeamYellow:(NSString*)awayTeamYellowValue
               crownChuPan:(NSString*)crownChuPanValue;

@end
