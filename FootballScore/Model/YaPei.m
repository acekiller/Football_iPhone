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
    self.matchId = matchIdValue;
    self.commpanyId = companyIdValue;
    self.oddsId = oddsIdValue;
    self.chupan = [NSNumber numberWithFloat:[chupanValue floatValue]];
    self.homeTeamChupan = [NSNumber numberWithFloat:[homeTeamChupanValue floatValue]];
    self.awayTeamChupan = [NSNumber numberWithFloat:[awayTeamChupanValue floatValue]];
    self.instantOdds = [NSNumber numberWithFloat:[instantOddsValue floatValue]];
    self.homeTeamOdds = [NSNumber numberWithFloat:[homeTeamOddsValue floatValue]];
    self.awayTeamOdds = [NSNumber numberWithFloat:[awayTeamOddsValue floatValue]];
    return self;
}
-(ODDS_TYPE) oddsType
{
    return ODDS_TYPE_YAPEI;
}

@end
