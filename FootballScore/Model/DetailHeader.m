//
//  DetailHeader.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailHeader.h"


@implementation DetailHeader

@synthesize homeTeamSCName; //简体名字
@synthesize awayTeamSCName;
@synthesize homeTeamYYName; //粤语名
@synthesize awayTeamYYName;
@synthesize matchStatus;
@synthesize matchDateString;
@synthesize homeTeamRank;
@synthesize awayTeamRank;   
@synthesize homeTeamImage;
@synthesize awayTeamImage;
@synthesize homeTeamScore;
@synthesize awayTeamScore;
//@synthesize homeHalfScore;
//@synthesize awayHalfScore;
@synthesize hasLineUp;


- (id)initWithDetailHeaderArray:(NSArray *)headerArray
{
    self = [super init];
    if (self && headerArray && [headerArray count] >= DETAIL_HEADER_FILED_COUNT) {
        self.homeTeamSCName = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_HOME_TEAM_SCNAME];
        self.awayTeamSCName = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_AWAY_TEAM_SCNAME];
        self.homeTeamYYName = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_HOME_TEAM_YYNAME];
        self.awayTeamYYName = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_AWAY_TEAM_YYNAME];
        self.matchStatus = [[headerArray objectAtIndex:INDEX_DETAIL_HEADER_MATCH_STATUS]intValue];
        
        self.matchDateString = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_MATCH_TIME];
        
        self.homeTeamRank = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_HOME_TEAM_RANK];
        self.awayTeamRank = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_AWAY_TEAM_RANK];
        
        self.homeTeamImage = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_HOME_TEAM_IMAGE];
        self.awayTeamImage = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_AWAY_TEAM_IMAGE];
        self.homeTeamImage = [NSString stringWithFormat:@"%@%@",IMAGE_PREFFIX_URL,self.homeTeamImage];
        self.awayTeamImage = [NSString  stringWithFormat:@"%@%@",IMAGE_PREFFIX_URL,self.awayTeamImage];
        
        self.homeTeamScore = [[headerArray objectAtIndex:INDEX_DETAIL_HEADER_HOME_TEAM_SCORE]intValue];
        self.awayTeamScore = [[headerArray objectAtIndex:INDEX_DETAIL_HEADER_AWAY_TEAM_SCORE] intValue];
        
        NSString *lineUp = [headerArray objectAtIndex:INDEX_DETAIL_HEADER_HAS_LINEUP];
        self.hasLineUp = ((lineUp ==nil)||[lineUp length]==0) ? NO : YES;

        //self.awayHalfScore = [[headerArray objectAtIndex:INDEX_DETAIL_HEADER_AWAY_TEAM_HALF_SCORE]intValue];
    }
    return self;
}

- (void)dealloc
{
    [homeTeamSCName release];
    [awayTeamSCName release];
    [homeTeamYYName release]; //粤语名
    [awayTeamYYName release];
    [matchDateString release];
    [homeTeamRank release];
    [awayTeamRank release];   
    [homeTeamImage release];
    [awayTeamImage release];
    [super dealloc];
}

@end
