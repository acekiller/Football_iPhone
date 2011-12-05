//
//  DataBaseManager.h
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface DataBaseManager : NSObject
{
    NSMutableArray *_countryArray;
    NSMutableArray *_continentArray;
    NSMutableArray *_leagueArray;
}

@property(nonatomic, retain)    NSMutableArray *countryArray;
@property(nonatomic, retain)    NSMutableArray *continentArray;
@property(nonatomic, retain)    NSMutableArray *leagueArray;

+ (DataBaseManager *)defaultManager;
- (void)updateContinentArray:(NSArray *)outPutContinentArray;
- (void)updateCountryArray:(NSArray *)outPutCountryArray;
- (void)updateLeagueArray:(NSArray *)outPutLeagueArray;

@end
extern DataBaseManager *GlobalGetDataBaseManager();