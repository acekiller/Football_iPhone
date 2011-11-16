//
//  OuPei.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OuPei.h"

@implementation OuPei

@synthesize homeWinInitOdds;
@synthesize drawInitOdds;
@synthesize awayWinInitOdds;
@synthesize homeWinInstantOdds;
@synthesize drawInstantOdds;
@synthesize awayWinInstantsOdds;

- (id)initWithMatchId:(NSString*)matchIdValue 
            companyId:(NSString*)companyIdValue 
               oddsId:(NSString*)oddsIdValue 
      homeWinInitOdds:(NSString*)homeWinInitOddsValue 
         drawInitOdds:(NSString*)drawInitOddsValue 
      awayWinInitOdds:(NSString*)awayWinInitOddsValue 
   homeWinInstantOdds:(NSString*)homeWinInstantOddsValue 
      drawInstantOdds:(NSString*)drawInstantOddsValue
  awayWinInstantsOdds:(NSString*)awayWinInstantOddsValue
{
    self = [super init];
    if (self) {
        self.matchId = matchIdValue;
        self.commpanyId = companyIdValue;
        self.oddsId = oddsIdValue;        
        self.homeWinInitOdds = [self getNumber:homeWinInitOddsValue];
        self.drawInitOdds = [self getNumber:drawInitOddsValue];
        self.awayWinInitOdds = [self getNumber:awayWinInitOddsValue];
        self.homeWinInstantOdds = [self getNumber:homeWinInstantOddsValue];
        self.drawInstantOdds = [self getNumber:drawInstantOddsValue];
        self.awayWinInstantsOdds = [self getNumber:awayWinInstantOddsValue];
    }

    return self;
}

-(ODDS_TYPE) oddsType
{
    return ODDS_TYPE_OUPEI;
}


- (void)updateHomeWinInstantOdds:(NSString*)homeWinInstantOddsValue 
                 drawInstantOdds:(NSString*)drawInstantOddsValue
             awayWinInstantsOdds:(NSString*)awayWinInstantOddsValue
{
 
    NSNumber *home = [self getNumber:homeWinInstantOddsValue];
    NSNumber *away = [self getNumber:awayWinInstantOddsValue];
    NSNumber *instant = [self getNumber:drawInstantOddsValue];
    
    NSComparisonResult instantFlag = [self.drawInstantOdds compare:instant];
    NSComparisonResult homeTeamFlag = [self.homeWinInstantOdds compare:home];
    NSComparisonResult awayTeamFlag = [self.awayWinInstantsOdds compare:away];
    
    [self setDrawInstantOdds:instant];
    [self setHomeWinInstantOdds:home];
    [self setAwayWinInstantsOdds:away];
    
    [self setPankouFlag:instantFlag];
    [self setAwayTeamOddsFlag:awayTeamFlag];
    [self setHomeTeamOddsFlag:homeTeamFlag];
    
    if ((instantFlag | homeTeamFlag | awayTeamFlag) != 0) {
        [self setLastModifyTime:time(0)];
    }    
}

@end
