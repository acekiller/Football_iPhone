//
//  OddsManager.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OddsManager.h"
#import "match.h"
#import "TimeUtils.h"

OddsManager* oddsManager;
OddsManager* GlobleGetOddsManager() 
{
    if (oddsManager == nil) {
        oddsManager = [[OddsManager alloc] init];
    }
    return oddsManager;
}

@implementation OddsManager

@synthesize matchArray;
@synthesize leagueArray;
@synthesize yapeiArray;
@synthesize oupeiArray;
@synthesize daxiaoArray;

+ (OddsManager*)defaultManager
{
    return GlobleGetOddsManager();
}

- (id)init
{
    [super init];
    self.matchArray = [[NSMutableArray alloc] init];
    self.leagueArray = [[NSMutableArray alloc] init];
    self.yapeiArray = [[NSMutableArray alloc] init];
    self.oupeiArray = [[NSMutableArray alloc] init];
    self.daxiaoArray = [[NSMutableArray alloc] init];
    return self;
}

- (void)dealloc
{
    [self.matchArray release];
    [self.leagueArray release];
    [self.yapeiArray release];
    [self.oupeiArray release];
    [self.daxiaoArray release];
    [super dealloc];
}

- (NSString*)getMatchTitleByMatchId:(NSString*)matchId
{
    for (Match* match in self.matchArray) {
        if ([matchId isEqualToString:match.matchId]) {
            return [NSString stringWithFormat:@"(%@)%@ vs %@",dateToString(match.date),match.homeTeamName,match.awayTeamName];
        }
    }
    return nil;
}

+ (void)addOdds:(Odds*)odds toDictionary:(NSMutableDictionary*)dict
{
    NSMutableArray * array;
    if ([dict objectForKey:odds.matchId] == nil) {
        array = [[NSMutableArray alloc] init];
        [array addObject:odds];
        [dict setObject:array forKey:odds.matchId];
        [array release];
    } else {
        array = [dict objectForKey:odds.matchId];
        [array addObject:odds];
        [dict setObject:array forKey:odds.matchId];
    }
}

@end
