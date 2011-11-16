//
//  YaPei.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Odds.h"

@interface YaPei : Odds {
    NSNumber* chupan;
    NSNumber* homeTeamChupan;
    NSNumber* awayTeamChupan;
    NSNumber* instantOdds;
    NSNumber* homeTeamOdds;
    NSNumber* awayTeamOdds;

}
@property (nonatomic, retain) NSNumber* chupan;
@property (nonatomic, retain) NSNumber* homeTeamChupan;
@property (nonatomic, retain) NSNumber* awayTeamChupan;
@property (nonatomic, retain) NSNumber* instantOdds;
@property (nonatomic, retain) NSNumber* homeTeamOdds;
@property (nonatomic, retain) NSNumber* awayTeamOdds;

- (id)initWithMatchId:(NSString*)matchIdValue 
            companyId:(NSString*)companyIdValue 
               oddsId:(NSString*)oddsIdValue 
               chupan:(NSString*)chupanValue 
       homeTeamChupan:(NSString*)homeTeamChupanValue 
       awayTeamChupan:(NSString*)awayTeamChupanValue 
          instantOdds:(NSString*)instantOddsValue 
        homeTeamOddds:(NSString*)homeTeamOddsValue 
         awayTeamOdds:(NSString*)awayTeamOddsValue;

- (void)updateHomeTeamOdds:(NSString *)homeTeamOddsString awayTeamOdds:(NSString *)awayTeamOddsString instantOdds:(NSString *)instantOddsString;

@end
