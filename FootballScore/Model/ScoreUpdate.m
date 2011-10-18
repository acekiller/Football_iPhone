//
//  UpdateScore.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreUpdate.h"
#import "Match.h"
#import "MatchManager.h"
@implementation ScoreUpdate

@synthesize match;
//@synthesize homeRedFlag;
//@synthesize awayRedFlag;
//@synthesize homeYellowFlag;
//@synthesize awayYelloFlag;
@synthesize scoreUpdateType;

-(void)dealloc
{
    [match release];
    [super dealloc];
}

-(id)initWithMatch:(Match *)aMatch ScoreUpdateType:(int)type
{
    self = [super init];
    if (self) {
        self.match = aMatch;
        self.scoreUpdateType = type;
    }
    return self;
}

- (NSInteger)state
{
    return self.match.status;
}

- (NSString *)homeTeamName
{
    return self.match.homeTeamName;
}
- (NSString *)awayTeamName
{
    return self.match.awayTeamName;
}
- (NSDate *)startTime
{
    return self.match.date;
}
- (NSString *)matchTimeString
{
    return [[MatchManager defaultManager] matchMinutesString:self.match];
}
- (NSString *)leagueName
{
    return [[MatchManager defaultManager] getLeagueNameByMatch:self.match];
}
- (NSString *)homeTeamScore
{
    return [self.match homeTeamScore];
}
- (NSString *)awayTeamScore
{
    return [self.match awayTeamScore];
}

@end
