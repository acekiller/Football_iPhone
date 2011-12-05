//
//  League.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "League.h"


@implementation League

@synthesize name;
@synthesize leagueId;
@synthesize isTop;
@synthesize countryId;
@synthesize leagueType;
@synthesize seasonList;


- (id)initWithName:(NSString*)na
          leagueId:(NSString*)lid
             isTop:(BOOL)it
{
    self = [super init];
    self.name = na;
    self.leagueId = lid;
    self.isTop = it;
    
    return self;
}

- (id)initWithLeagueId: (NSString *)lId leagueName:(NSString *)lName 
             countryId:(NSString *)cId leagueType:(NSInteger)lType 
            seasonList:(NSArray *)sList
{
    self = [super init];
    if (self) {
        self.leagueId = lId;
        self.name = lName;
        self.countryId = cId;
        self.leagueType = lType;
        self.seasonList = sList;
    }
    return self;
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"[name=%@, id=%@, isTop=%d", 
            name, leagueId, isTop];
}

- (void)dealloc
{
    [name release];
    [leagueId release];
    [countryId release];
    [seasonList release];
    [super dealloc];
}

@end
