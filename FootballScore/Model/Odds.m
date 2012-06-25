//
//  Odds.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Odds.h"
#import "OuPei.h"
#import "YaPei.h"
#import "DaXiao.h"
@implementation Odds

@synthesize matchId;
@synthesize commpanyId;
@synthesize oddsId;
@synthesize lastModifyTime;
@synthesize homeTeamOddsFlag;
@synthesize awayTeamOddsFlag;
@synthesize pankouFlag;

- (id)init
{
    self = [super init];
    if (self) {
        self.matchId = [[NSString alloc] init];
        self.commpanyId = [[NSString alloc] init];
        self.oddsId = [[NSString alloc] init];

        self.lastModifyTime = 0;
        self.homeTeamOddsFlag = ODDS_UNCHANGE;
        self.awayTeamOddsFlag = ODDS_UNCHANGE;
        self.pankouFlag = ODDS_UNCHANGE;
    }
    return self;
}

- (void)dealloc
{
    [self.matchId release];
    [self.commpanyId release];
    [self.oddsId release];
    [super dealloc];
}

-(ODDS_TYPE) oddsType
{
    return ODDS_TYPE_ODDS;
}

-(NSNumber *)getNumber:(NSString *)stringValue
{
    if (stringValue == nil || [stringValue length] == 0)
        return nil;
    return [NSNumber numberWithFloat:[stringValue floatValue]];
}


@end
