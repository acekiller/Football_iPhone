//
//  DaXiao.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DaXiao.h"

@implementation DaXiao
@synthesize chupan;
@synthesize bigBallChupan;
@synthesize smallBallChupan;
@synthesize instantOdds;
@synthesize bigBallOdds;
@synthesize smallBallOdds;

- (id)initWithMatchId:(NSString*)matchIdValue 
            companyId:(NSString*)companyIdValue 
               oddsId:(NSString*)oddsIdValue 
               chupan:(NSString*)chupanValue 
        bigBallChupan:(NSString*)bigBallChupanValue 
      smallBallChupan:(NSString*)smallBallChupanValue 
          instantOdds:(NSString*)instantOddsValue 
          bigBallOdds:(NSString*)bigBallOddsValue 
        smallBallOdds:(NSString*)smallBallOddsValue
{
    [super init];
    [super init];
    self.matchId = matchIdValue;
    self.commpanyId = companyIdValue;
    self.oddsId = oddsIdValue;
    self.chupan = [NSNumber numberWithFloat:[chupanValue floatValue]];
    self.bigBallChupan = [NSNumber numberWithFloat:[bigBallChupanValue floatValue]];
    self.smallBallChupan = [NSNumber numberWithFloat:[smallBallChupanValue floatValue]];
    self.instantOdds = [NSNumber numberWithFloat:[instantOddsValue floatValue]];
    self.bigBallOdds = [NSNumber numberWithFloat:[bigBallOddsValue floatValue]];
    self.smallBallOdds = [NSNumber numberWithFloat:[smallBallOddsValue floatValue]];
    return self;
}

@end
