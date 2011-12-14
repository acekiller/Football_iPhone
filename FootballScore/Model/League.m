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
@synthesize shortName;
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

- (id)initWithLeagueId: (NSString *)lId 
            leagueName:(NSString *)lName 
       leagueShortName:(NSString*)sName
             countryId:(NSString *)cId 
            leagueType:(NSInteger)lType 
            seasonList:(NSArray *)sList
{
    self = [super init];
    if (self) {
        self.leagueId = lId;
        self.name = lName;
        self.shortName = sName;
        self.countryId = cId;
        self.leagueType = lType;
        self.seasonList = sList;
    }
    return self;
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"[name=%@(%@), id=%@, isTop=%d", 
            name, shortName , leagueId, isTop];
}

- (void)dealloc
{
    [name release];
    [shortName release];
    [leagueId release];
    [countryId release];
    [seasonList release];
    [super dealloc];
}

@end
