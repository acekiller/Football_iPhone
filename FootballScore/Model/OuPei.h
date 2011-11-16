//
//  OuPei.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Odds.h"

@interface OuPei : Odds {
    NSNumber* homeWinInitOdds;
    NSNumber* drawInitOdds;
    NSNumber* awayWinInitOdds;
    NSNumber* homeWinInstantOdds;
    NSNumber* drawInstantOdds;
    NSNumber* awayWinInstantsOdds;
    
}
@property (nonatomic, retain) NSNumber* homeWinInitOdds;
@property (nonatomic, retain) NSNumber* drawInitOdds;
@property (nonatomic, retain) NSNumber* awayWinInitOdds;
@property (nonatomic, retain) NSNumber* homeWinInstantOdds;
@property (nonatomic, retain) NSNumber* drawInstantOdds;
@property (nonatomic, retain) NSNumber* awayWinInstantsOdds;
- (id)initWithMatchId:(NSString*)matchIdValue 
            companyId:(NSString*)companyIdValue 
               oddsId:(NSString*)oddsIdValue 
      homeWinInitOdds:(NSString*)homeWinInitOddsValue 
         drawInitOdds:(NSString*)drawInitOddsValue 
      awayWinInitOdds:(NSString*)awayWinInitOddsValue 
   homeWinInstantOdds:(NSString*)homeWinInstantOddsValue 
      drawInstantOdds:(NSString*)drawInstantOddsValue
  awayWinInstantsOdds:(NSString*)awayWinInstantOddsValue;

- (void)updateHomeWinInstantOdds:(NSString*)homeWinInstantOddsValue 
                 drawInstantOdds:(NSString*)drawInstantOddsValue
             awayWinInstantsOdds:(NSString*)awayWinInstantOddsValue;

@end
