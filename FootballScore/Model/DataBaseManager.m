//
//  DataBaseManager.m
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseManager.h"
#import "DataBase.h"

DataBaseManager *manager = nil;
DataBaseManager *GlobalGetDataBaseManager()
{
    if (manager == nil) {
        manager = [[DataBaseManager alloc] init];
    }
    return manager;
}

@implementation DataBaseManager
@synthesize countryArray = _countryArray;
@synthesize continentArray = _continentArray;
@synthesize leagueArray = _leagueArray;

-(id)init
{
    self = [super init];
    if (self) {
        _countryArray = [[NSMutableArray alloc]init];
        _continentArray = [[NSMutableArray alloc]init];
        _leagueArray = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (DataBaseManager *)defaultManager
{
    return GlobalGetDataBaseManager();
}


- (void)updateContinentArray:(NSArray *)outPutContinentArray
{
    if ([outPutContinentArray count] == 0) {
        return;
    }
    
    for(NSArray *continentArray in outPutContinentArray)
    {
        if ([continentArray count] == CONTINENT_INDEX_COUNT) {
            NSString *continentId = [continentArray objectAtIndex:CONTINENT_ID_INDEX];
            NSString *continentName = [continentArray objectAtIndex:CONTINENT_NAME_INDEX];
            DBContinent *continent = [[DBContinent alloc]initWithId:continentId name:continentName];
            [_continentArray addObject:continent];
            [continent release];
        }
    }
}

- (void)updateCountryArray:(NSArray *)outPutCountryArray
{
    if ([outPutCountryArray count] == 0) {
        return;
    }
    for(NSArray *countryArray in outPutCountryArray)
    {
        if ([countryArray count] == COUNTRY_INDEX_COUNT) {
            NSString *countryId = [countryArray objectAtIndex:COUNTRY_ID_INDEX];
            NSString *countryName = [countryArray objectAtIndex:COUNTRY_NAME_INDEX];
            NSString *continentId = [countryArray objectAtIndex:COUNTRY_CONTINENT_ID_INDEX];
            DBCountry *country = [[DBCountry alloc] initWithId:countryId name:countryName aContinentId:continentId];
            [_countryArray addObject:country];
            [country release];
        }
    }
}

- (void)updateLeagueArray:(NSArray *)outPutLeagueArray
{
    if ([outPutLeagueArray count] == 0) {
        return;
    }
    for (NSArray *leagueArray in outPutLeagueArray) {
        if ([leagueArray count] == LEAGUE_INDEX_COUNT) {
            NSString *leagueId = [leagueArray objectAtIndex:LEAGUE_ID_INDEX];
            NSString *leagueName = [leagueArray objectAtIndex:LEAGUE_NAME_INDEX];
            NSString *leagueCountryId = [leagueArray objectAtIndex:LEAGUE_COUNTRY_ID_INDEX];
            NSInteger leagueType = [[leagueArray objectAtIndex:LEAGUE_TYPE_INDEX]intValue];
            NSArray *seasonList = [[[leagueArray objectAtIndex:LEAGUE_LIST_INDEX] string]componentsSeparatedByString:@","];
            DBLeague *league = [[DBLeague alloc]initWithLeagueId:leagueId leagueName:leagueName countryId:leagueCountryId type:leagueType seasonList:seasonList];
            [_leagueArray addObject:league];
            [league release];
        }
    }
}
-(void)dealloc
{
    [_continentArray release];
    [_countryArray release];
    [_leagueArray release];
    [super dealloc];
}
@end
