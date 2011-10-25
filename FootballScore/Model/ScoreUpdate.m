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
@synthesize homeTeamDataCount;
@synthesize awayTeamDataCount;
@synthesize scoreUpdateType;
@synthesize updateMinute;

-(void)dealloc
{
    [match release];
    [updateMinute release];
    [super dealloc];
}


//Increment
-(id)initWithMatch:(Match *)aMatch ScoreUpdateType:(int)type increment:(NSInteger)increment
{
    self = [super init];
    if (self) {
        self.match = aMatch;
        self.scoreUpdateType = type;
        self.updateMinute = [[MatchManager defaultManager] matchMinutesString:match];
        if (type < HOMETEAMRED && type >= HOMETEAMSCORE) {
            //score
            self.homeTeamDataCount =[[match homeTeamScore] integerValue];
            self.awayTeamDataCount = [[match awayTeamScore] integerValue];
        }else if(type < HOMETEAMYELLOW){
            //red card
            self.homeTeamDataCount = [[match homeTeamRed] integerValue];
            self.awayTeamDataCount = [[match awayTeamRed] integerValue];
        }else if(type < TYPECOUNT){
            //yellow card
            self.homeTeamDataCount = [[match homeTeamYellow] integerValue];
            self.awayTeamDataCount = [[match awayTeamYellow] integerValue];
        }else{
            //error type
            self.homeTeamDataCount = 0;
            self.awayTeamDataCount = 0;
        }
        
        //set increase data
        if (type < TYPECOUNT && type >= 0) {
            if (type %2 == 0) {
                self.homeTeamDataCount += increment;
            }else{
                self.awayTeamDataCount += increment;
            }
        }
    }
    return self;
}

- (NSInteger)state
{
    return [self.match.status intValue];
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
    if (self.match.firstHalfStartDate) {
        return self.match.firstHalfStartDate;
    }
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
@end
