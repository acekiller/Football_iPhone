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
        self.homeWinInitOdds = [NSNumber numberWithFloat:[homeWinInitOddsValue floatValue]];
        self.drawInitOdds = [NSNumber numberWithFloat:[drawInitOddsValue floatValue]];
        self.awayWinInitOdds = [NSNumber numberWithFloat:[awayWinInitOddsValue floatValue]];
        self.homeWinInstantOdds = [NSNumber numberWithFloat:[homeWinInstantOddsValue floatValue]];
        self.drawInstantOdds = [NSNumber numberWithFloat:[drawInstantOddsValue floatValue]];
        self.awayWinInstantsOdds = [NSNumber numberWithFloat:[awayWinInstantOddsValue floatValue]];
    }
    return self;
}

-(ODDS_TYPE) oddsType
{
    return ODDS_TYPE_OUPEI;
}

@end
