//
//  DataBase.m
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"

@implementation DBContinent
@synthesize continentId;
@synthesize continentName;

-(id)initWithId:(NSString *)aContinentId name:(NSString *)aContinentName
{
    self = [super init];
    if (self) {
        self.continentId = aContinentId;
        self.continentName = aContinentName;
    }
    return self;
}

- (void)dealloc
{
    [continentId release];
    [continentName release];
    [super dealloc];
}

@end

@implementation DBCountry

@synthesize countryId;
@synthesize continentId;
@synthesize countryName;

- (id)initWithId:(NSString *)aCountryId name:(NSString *)aCountryName aContinentId:(NSString *)aContinentId
{
    self = [super init];
    if (self) {
        self.continentId = aCountryName;
        self.countryId = aCountryId;
        self.countryName = aCountryName;
    }
    return self;
}

- (void)dealloc
{
    [countryId release];
    [countryName release];
    [continentId release];
    [super dealloc];
}
@end

@implementation DBLeague

@synthesize dbLeagueId;
@synthesize dbCountryId;
@synthesize dbLeagueName;
@synthesize dbType;
@synthesize seasonList;

- (id)initWithLeagueId: (NSString *)leagueId leagueName:(NSString *)leagueName 
             countryId:(NSString *)countryId type:(NSInteger)type 
            seasonList:(NSArray *)aSeasonList
{
    self = [super init];
    if (self) {
        self.dbLeagueId = leagueId;
        self.dbCountryId = countryId;
        self.dbLeagueName = leagueName;
        self.dbType = type;
        self.seasonList = seasonList;
    }
    return self;
}

-(void)dealloc
{
    [dbLeagueName release];
    [dbLeagueId release];
    [dbCountryId release];
    [seasonList release];
    [super release];
}

@end
