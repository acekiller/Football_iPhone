//
//  Match.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Match.h"
#import "TimeUtils.h"

@implementation Match

@synthesize matchId;

@synthesize leagueId;
@synthesize status;
@synthesize date;
@synthesize firstHalfStartDate;
@synthesize secondHalfStartDate;

@synthesize homeTeamName;
@synthesize awayTeamName;

@synthesize homeTeamMandarinName;      // from detail interface
@synthesize awayTeamMandarinName;      // from detail interface

@synthesize homeTeamCantonName;        // from detail interface
@synthesize awayTeamCantonName;        // from detail interface

@synthesize homeTeamImage;             // from detail interface
@synthesize awayTeamImage;             // from detail interface

@synthesize homeTeamLeaguePos;         // from detail interface
@synthesize awayTeamLeaguePos;         // from detail interface

@synthesize hasLineUp;                  // 是否有阵容

@synthesize homeTeamScore;
@synthesize awayTeamScore;

@synthesize homeTeamFirstHalfScore;
@synthesize awayTeamFirstHalfScore;

@synthesize homeTeamRed;
@synthesize awayTeamRed;

@synthesize homeTeamYellow;
@synthesize awayTeamYellow;

@synthesize crownChuPan;

@synthesize events;
@synthesize stats;

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
               crownChuPan:(NSString*)crownChuPanValue
{
    
    self = [super init];
    self.matchId = idValue;
    self.leagueId = leagueIdValue;
    self.status = [statusValue intValue];
    
    //  TODO set date by status
    if (status == MATCH_STATUS_FIRST_HALF){
        self.firstHalfStartDate = dateFromChineseStringByFormat(dateValue, 
                                                            DEFAULT_DATE_FORMAT);
    }
    else if (status == MATCH_STATUS_SECOND_HALF){
        self.secondHalfStartDate = dateFromChineseStringByFormat(dateValue, 
                                                                DEFAULT_DATE_FORMAT);        
    }
    
    self.homeTeamName = homeTeamNameValue;
    self.homeTeamRed = homeTeamRedValue;
    self.homeTeamYellow = homeTeamYellowValue;
    self.homeTeamScore = homeTeamScoreValue;
    self.homeTeamFirstHalfScore = homeTeamFirstHalfScoreValue;

    self.awayTeamName = awayTeamNameValue;
    self.awayTeamRed = awayTeamRedValue;
    self.awayTeamYellow = awayTeamYellowValue;
    self.awayTeamScore = awayTeamScoreValue;
    self.awayTeamFirstHalfScore = awayTeamFirstHalfScoreValue;

    self.crownChuPan = [crownChuPanValue doubleValue];    
    return self;
}

- (void)dealloc
{
    [matchId release];
    
    [matchId release];
        
    [leagueId release];
    [date release];
    [firstHalfStartDate release];
    [secondHalfStartDate release];
        
    [homeTeamName release];
    [awayTeamName release];
        
    [homeTeamMandarinName release];      // from detail interface
    [awayTeamMandarinName release];      // from detail interface
        
    [homeTeamCantonName release];        // from detail interface
    [awayTeamCantonName release];        // from detail interface
        
    [homeTeamImage release];             // from detail interface
    [awayTeamImage release];             // from detail interface
        
    [homeTeamLeaguePos release];         // from detail interface
    [awayTeamLeaguePos release];         // from detail interface
        
    [homeTeamScore release];
    [awayTeamScore release];
        
    [homeTeamFirstHalfScore release];
    [awayTeamFirstHalfScore release];
        
    [homeTeamRed release];
    [awayTeamRed release];
        
    [homeTeamYellow release];
    [awayTeamYellow release];
        
    [events release];
    [stats release];
    [super dealloc];
}

@end
