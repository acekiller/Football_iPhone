//
//  RepositoryManager.m
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepositoryManager.h"
#import "Repository.h"
#import "League.h"
#import "LocaleConstants.h"

RepositoryManager *manager = nil;
RepositoryManager *GlobalGetRepositoryManager()
{
    if (manager == nil) {
        manager = [[RepositoryManager alloc] init];
    }
    return manager;
}

@implementation RepositoryManager
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

+ (RepositoryManager *)defaultManager
{
    return GlobalGetRepositoryManager();
}

#pragma mark - update methods
- (void)updateContinentArray:(NSArray *)outPutContinentArray
{
    if ([outPutContinentArray count] == 0) {
        return;
    }
    
    [_continentArray removeAllObjects];    
    for(NSArray *continentArray in outPutContinentArray)
    {
        if ([continentArray count] >= CONTINENT_INDEX_COUNT) {
            NSString *continentId = [continentArray objectAtIndex:CONTINENT_ID_INDEX];
            NSString *continentName = [continentArray objectAtIndex:CONTINENT_NAME_INDEX];
            Continent *continent = [[Continent alloc]initWithId:continentId name:continentName];
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
    
    [_countryArray removeAllObjects];
    for(NSArray *countryArray in outPutCountryArray)
    {
        if ([countryArray count] >= COUNTRY_INDEX_COUNT) {
            NSString *countryId = [countryArray objectAtIndex:COUNTRY_ID_INDEX];
            NSString *continentId = [countryArray objectAtIndex:COUNTRY_CONTINENT_ID_INDEX];
            NSString *countryName = [countryArray objectAtIndex:COUNTRY_NAME_INDEX];
            Country *country = [[Country alloc] initWithId:countryId name:countryName aContinentId:continentId];
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
    
    [_leagueArray removeAllObjects];
    for (NSArray *leagueArray in outPutLeagueArray) {
        if ([leagueArray count] >= LEAGUE_INDEX_COUNT) {
            NSString *leagueId = [leagueArray objectAtIndex:LEAGUE_ID_INDEX];
            NSString *leagueName = [leagueArray objectAtIndex:LEAGUE_NAME_INDEX];
            NSString *leagueCountryId = [leagueArray objectAtIndex:LEAGUE_COUNTRY_ID_INDEX];
            NSInteger leagueType = [[leagueArray objectAtIndex:LEAGUE_TYPE_INDEX]intValue];
            NSString *seasonListString = [leagueArray objectAtIndex:LEAGUE_LIST_INDEX];
            
            NSArray *seasonList = [seasonListString componentsSeparatedByString:@","];
            League *league = [[League alloc]initWithLeagueId:leagueId leagueName:leagueName countryId:leagueCountryId leagueType:leagueType seasonList:seasonList];
            [_leagueArray addObject:league];
            [league release];
        }
    }
}


#pragma mark - filter methods 

- (NSArray *)filterCountryArrayWithContinentId:(NSInteger)continentId
{
    if ([_countryArray count] == 0) {
        return nil;
    }
    NSMutableArray *countryArray = [[[NSMutableArray alloc] init]autorelease];
    for (Country *country in _countryArray) {
        if (country  && country.continentId && 
            [country.continentId intValue] == continentId) {
            [countryArray addObject:country];
        }
    }
    return countryArray;
}

#pragma mark - get data methods

- (Country *)getCountryById:(NSString *)countryId
{
    for (Country *country in _countryArray) {
        if ([country.countryId isEqualToString:countryId]) {
            return country;
        }
    }
    return nil;
}


- (Continent *)getContinentById:(NSString *)continentId
{
    for (Continent *continent in _continentArray) {
        if ([continent.continentId isEqualToString:continentId]) {
            return continent;
        }
    }
    return nil;
}


- (NSArray *)getLeagueArrayByCountryId:(NSString *)countryId
{
    if ([_leagueArray count] == 0) {
        return nil;
    }
    NSMutableArray *leagueArray = [[[NSMutableArray alloc]init] autorelease];
    for (League * league in _leagueArray) {
        if ([league.countryId isEqualToString:countryId]) {
            [leagueArray addObject:league];
        }
    }
    return leagueArray;
}

- (NSArray *)getLeagueArrayByKey:(NSString *)key
{
    if ([_leagueArray count] == 0) {
        return nil;
    }
    NSMutableArray *leagueArray = [[[NSMutableArray alloc]init] autorelease];
    
    for (League * league in _leagueArray) {
        //search in league name
        NSRange range = [league.name rangeOfString:FNSWithLang(key, 0)];
        
        if (range.length != 0) {
            [leagueArray addObject:league];
            continue;
        }
        
        range = [league.name rangeOfString:FNSWithLang(key, 1)];
        if (range.length != 0) {
            [leagueArray addObject:league];
            continue;
        }
        //search in country name
        Country *country = [self getCountryById:league.countryId];
        if (country == nil || country.countryName == nil) {
            continue;
        }
        
        NSString *name = country.countryName;
        range = [name rangeOfString:FNSWithLang(key, 0)];
        if (range.length != 0) {
            [leagueArray addObject:league];
            continue;
        }
        range = [name rangeOfString:FNSWithLang(key, 1)];
        if (range.length != 0) {
            [leagueArray addObject:league];
            continue;
        }
    }
    
    return leagueArray;
}

-(void)dealloc
{
    [_continentArray release];
    [_countryArray release];
    [_leagueArray release];
    [super dealloc];
}
@end
