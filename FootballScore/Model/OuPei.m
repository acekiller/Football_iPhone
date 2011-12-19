//
//  OuPei.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OuPei.h"
#import "LogUtil.h"
#import "Match.h"
#import "MatchManager.h"

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
        
        // add by Benson, init data
        [self setLastModifyTime:time(0)];
    }

    return self;
}

- (void)dealloc
{
    [homeWinInitOdds release];
    [drawInitOdds release];
    [awayWinInitOdds release];
    [homeWinInstantOdds release];
    [drawInstantOdds release];
    [awayWinInstantsOdds release];
    [super dealloc];
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
    
    if (instantFlag != 0 || homeTeamFlag != 0 || awayTeamFlag != 0) {
        PPDebug(@"Match(%@) Oupei Odds Changed, Instant(%d), Home(%d), Away(%d)", 
                matchId, instantFlag, homeTeamFlag, awayTeamFlag);        
        [self setLastModifyTime:time(0)];
        
        Match *match = [[MatchManager defaultMatchIndexManger] getMathById:matchId];

        NSString *vsString = [NSString stringWithFormat:@"%@ vs %@ ",match.homeTeamName,match.awayTeamName];
        PPDebug(@"Match title:%@", vsString);
    }    
}

@end
