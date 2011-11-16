//
//  YaPei.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "YaPei.h"

@implementation YaPei
@synthesize chupan;
@synthesize homeTeamChupan;
@synthesize awayTeamChupan;
@synthesize instantOdds;
@synthesize homeTeamOdds;
@synthesize awayTeamOdds;

- (id)initWithMatchId:(NSString*)matchIdValue 
            companyId:(NSString*)companyIdValue 
               oddsId:(NSString*)oddsIdValue 
               chupan:(NSString*)chupanValue 
       homeTeamChupan:(NSString*)homeTeamChupanValue 
       awayTeamChupan:(NSString*)awayTeamChupanValue 
          instantOdds:(NSString*)instantOddsValue 
        homeTeamOddds:(NSString*)homeTeamOddsValue 
         awayTeamOdds:(NSString*)awayTeamOddsValue
{
    [super init];
    if (self) {
        self.matchId = matchIdValue;
        self.commpanyId = companyIdValue;
        self.oddsId = oddsIdValue;
        self.chupan = [self getNumber:chupanValue]; 
        self.homeTeamChupan = [self getNumber:homeTeamChupanValue];
        self.awayTeamChupan = [self getNumber:awayTeamChupanValue];
        self.instantOdds = [self getNumber:instantOddsValue];
        self.homeTeamOdds = [self getNumber:homeTeamOddsValue];
        self.awayTeamOdds = [self getNumber:awayTeamOddsValue];
    }

    return self;
}
-(ODDS_TYPE) oddsType
{
    return ODDS_TYPE_YAPEI;
}

- (void)updateHomeTeamOdds:(NSString *)homeTeamOddsString awayTeamOdds:(NSString *)awayTeamOddsString instantOdds:(NSString *)instantOddsString
{
    NSNumber *home = [self getNumber:homeTeamOddsString];
    NSNumber *away = [self getNumber:awayTeamOddsString];
    NSNumber *instant = [self getNumber:instantOddsString];

    //instant smaller
    NSComparisonResult instantFlag = [self.instantOdds compare:instant];
    NSComparisonResult homeTeamFlag = [self.homeTeamOdds compare:home];
    NSComparisonResult awayTeamFlag = [self.awayTeamOdds compare:away];
    
    [self setInstantOdds:instant];
    [self setHomeTeamOdds:home];
    [self setAwayTeamOdds:away];
    
    [self setPankouFlag:instantFlag];
    [self setAwayTeamOddsFlag:awayTeamFlag];
    [self setHomeTeamOddsFlag:homeTeamFlag];
    
    if ((instantFlag | homeTeamFlag | awayTeamFlag) != 0) {
        [self setLastModifyTime:time(0)];
    }

}

@end
