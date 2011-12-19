//
//  DaXiao.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DaXiao.h"
#import "LogUtil.h"

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
    self = [super init];
    if (self) {
        self.matchId = matchIdValue;
        self.commpanyId = companyIdValue;
        self.oddsId = oddsIdValue;
        self.chupan = [self getNumber:chupanValue];
        self.bigBallChupan = [self getNumber:bigBallChupanValue ] ;
        self.smallBallChupan = [self getNumber:smallBallChupanValue];
        self.instantOdds = [self getNumber:instantOddsValue];
        self.bigBallOdds = [self getNumber:bigBallOddsValue];
        self.smallBallOdds = [self getNumber:smallBallOddsValue];
        
        // add by Benson, init data
        [self setLastModifyTime:time(0)];        
    }

    return self;
}

- (void)dealloc
{
    [chupan release];
    [bigBallChupan release];
    [smallBallChupan release];
    [instantOdds release];
    [bigBallOdds release];
    [smallBallOdds release];
    [super dealloc];
}

-(ODDS_TYPE) oddsType
{
    return ODDS_TYPE_DAXIAO;
}

- (void)updateInstantOdds:(NSString*)instantOddsValue 
              bigBallOdds:(NSString*)bigBallOddsValue 
            smallBallOdds:(NSString*)smallBallOddsValue
{
    NSNumber *home = [self getNumber:bigBallOddsValue];
    NSNumber *away = [self getNumber:smallBallOddsValue];
    NSNumber *instant = [self getNumber:instantOddsValue];
    
    NSComparisonResult instantFlag = [self.instantOdds compare:instant];
    NSComparisonResult homeTeamFlag = [self.bigBallOdds compare:home];
    NSComparisonResult awayTeamFlag = [self.smallBallOdds compare:away];
    
    [self setInstantOdds:instant];
    [self setBigBallOdds:home];
    [self setSmallBallOdds:away];
    
    [self setPankouFlag:instantFlag];
    [self setAwayTeamOddsFlag:awayTeamFlag];
    [self setHomeTeamOddsFlag:homeTeamFlag];  
    
    if (instantFlag != 0 | homeTeamFlag != 0 | awayTeamFlag != 0) {
        PPDebug(@"Match(%@) Daxiao Odds Changed, Instant(%d), Home(%d), Away(%d)", 
                matchId, instantFlag, homeTeamFlag, awayTeamFlag);        
        [self setLastModifyTime:time(0)];
    }    
}

@end
