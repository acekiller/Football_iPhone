//
//  DataBase.h
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    CONTINENT_ID_INDEX = 0,
    CONTINENT_NAME_INDEX,
    CONTINENT_INDEX_COUNT
};

enum
{
    COUNTRY_ID_INDEX = 0,
    COUNTRY_CONTINENT_ID_INDEX = 1,
    COUNTRY_NAME_INDEX,
    COUNTRY_INDEX_COUNT
};

enum
{
    LEAGUE_ID_INDEX = 0,
    LEAGUE_COUNTRY_ID_INDEX = 1,
    LEAGUE_NAME_INDEX,
    LEAGUE_SHORT_NAME_INDEX,
    LEAGUE_TYPE_INDEX,
    LEAGUE_LIST_INDEX,
    LEAGUE_INDEX_COUNT
};

@interface Continent : NSObject
{
    NSString *continentId;
    NSString *continentName;
}
-(id)initWithId:(NSString *)aContinentId name:(NSString *)aContinentName;
@property(nonatomic, retain) NSString *continentId;
@property(nonatomic, retain) NSString *continentName;

@end


@interface Country : NSObject
{
    NSString *countryId;
    NSString *countryName;
    NSString *continentId;
}
@property(nonatomic, retain) NSString *countryId;
@property(nonatomic, retain) NSString *countryName;
@property(nonatomic, retain) NSString *continentId;

- (id)initWithId:(NSString *)aCountryId name:(NSString *)aCountryName aContinentId:(NSString *)aContinentId;
@end


