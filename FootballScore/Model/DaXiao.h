//
//  DaXiao.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Odds.h"

@interface DaXiao : Odds {
    NSNumber* chupan;
    NSNumber* bigBallChupan;
    NSNumber* smallBallChupan;
    NSNumber* instantOdds;
    NSNumber* bigBallOdds;
    NSNumber* smallBallOdds;
    
}
@property (nonatomic, retain) NSNumber* chupan;
@property (nonatomic, retain) NSNumber* bigBallChupan;
@property (nonatomic, retain) NSNumber* smallBallChupan;
@property (nonatomic, retain) NSNumber* instantOdds;
@property (nonatomic, retain) NSNumber* bigBallOdds;
@property (nonatomic, retain) NSNumber* smallBallOdds;

- (id)initWithMatchId:(NSString*)matchIdValue 
            companyId:(NSString*)companyIdValue 
               oddsId:(NSString*)oddsIdValue 
               chupan:(NSString*)chupanValue 
        bigBallChupan:(NSString*)bigBallChupanValue 
      smallBallChupan:(NSString*)smallBallChupanValue 
          instantOdds:(NSString*)instantOddsValue 
          bigBallOdds:(NSString*)bigBallOddsValue 
        smallBallOdds:(NSString*)smallBallOddsValue;

- (void)updateInstantOdds:(NSString*)instantOddsValue 
              bigBallOdds:(NSString*)bigBallOddsValue 
            smallBallOdds:(NSString*)smallBallOddsValue;

@end
