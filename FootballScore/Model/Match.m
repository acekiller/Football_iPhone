//
//  Match.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchConstants.h"
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
@synthesize isFollow;

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
                  isFollow:(BOOL)isFollowValue
{
    
    self = [super init];
    self.matchId = idValue;
    self.leagueId = leagueIdValue;
    self.status = [statusValue intValue];
    
    if (status == MATCH_STATUS_FIRST_HALF){
        self.firstHalfStartDate = dateFromChineseStringByFormat(dateValue, 
                                                            DEFAULT_DATE_FORMAT);
    }
    else if (status == MATCH_STATUS_SECOND_HALF){
        self.secondHalfStartDate = dateFromChineseStringByFormat(dateValue, 
                                                                DEFAULT_DATE_FORMAT);        
    }
    self.date = dateFromChineseStringByFormat(dateValue, 
                                              DEFAULT_DATE_FORMAT); 
    
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

    if (crownChuPanValue != nil){
        self.crownChuPan = [NSNumber numberWithInt:[crownChuPanValue doubleValue]];   
    }

    
    self.isFollow = isFollowValue;

    return self;
}

- (void)dealloc
{
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
    
    [crownChuPan release];
        
    [events release];
    [stats release];
    [super dealloc];
}

- (int)matchSelectStatus
{
    // 0:未开,1:上半场,2:中场,3:下半场,-11:待定,-12:腰斩,-13:中断,-14:推迟,-1:完场，-10取消
    
//    MATCH_STATUS_NOT_STARTED = 0,
//    MATCH_STATUS_FIRST_HALF = 1,
//    MATCH_STATUS_MIDDLE = 2,
//    MATCH_STATUS_SECOND_HALF = 3,
//    MATCH_STATUS_TBD = -11,
//    MATCH_STATUS_KILL = -12,
//    MATCH_STATUS_PAUSE = -13,
//    MATCH_STATUS_POSTPONE = -14,
//    MATCH_STATUS_FINISH = -1,
//    MATCH_STATUS_CANCEL = -10
    
    switch (status) {
                        
        case MATCH_STATUS_FIRST_HALF:
        case MATCH_STATUS_MIDDLE:
        case MATCH_STATUS_SECOND_HALF:
        case MATCH_STATUS_PAUSE:
            return MATCH_SELECT_STATUS_ON_GOING;
            
        case MATCH_STATUS_FINISH:
            return MATCH_SELECT_STATUS_FINISH;
            
        case MATCH_STATUS_NOT_STARTED:
        case MATCH_STATUS_TBD:
        case MATCH_STATUS_KILL:
        case MATCH_STATUS_POSTPONE:
        case MATCH_STATUS_CANCEL:
        default:
            return MATCH_SELECT_STATUS_NOT_STARTED;
    }
}

- (void)updateStartDate:(NSDate*)newStartDate
{
    if (status == MATCH_STATUS_FIRST_HALF){
        self.firstHalfStartDate = newStartDate;
    }
    else if (status == MATCH_STATUS_SECOND_HALF){
        self.secondHalfStartDate = newStartDate;        
    }    
}

@end
