//
//  RepositoryService.m
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RepositoryService.h"
#import "FootballNetworkRequest.h"
#import "RepositoryManager.h"
#import "CupMatchType.h"

#define UPDATE_Repository @"UPDATE_Repository"
#define GET_GROUP_INFO    @"GET_GROUP_INFO"
#define GET_ROUNDS_COUNT  @"GET_ROUNDS_COUNT"

RepositoryService *service = nil;
RepositoryService *GlobalGetRepositoryService()
{
    if (service == nil) {
        service = [[RepositoryService alloc] init];
    }
    return service;
}

@implementation RepositoryService


#define RepositoryData @"RepositoryData"
#define RepositoryDataTimeStamp @"RepositoryDataTimeStamp"
#define REPOSITROY_TIMEOUT 3600 * 24 * 7                    // 7 days
- (void)storeRepositoryData:(NSArray *)outputArray
{
    NSNumber *timestamp = [NSNumber numberWithLong:time(0)];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:timestamp forKey:RepositoryDataTimeStamp];
    [userDefault setObject:outputArray forKey:RepositoryData];
    [userDefault synchronize];
}

- (NSArray *)getLocalRepositoryData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *timestamp = [userDefault objectForKey:RepositoryDataTimeStamp];
    if (timestamp == nil) {
        return nil;
    }
    time_t stamp = [timestamp longValue];
    if (time(0) - stamp >= REPOSITROY_TIMEOUT) {
        return nil;
    }
    NSArray *data = [userDefault objectForKey:RepositoryData];
    if (data) {
        return data;
    }
    return nil;
}


- (void)dealWithOutputArray:(NSArray *)outputArray delegate:(id<RepositoryDelegate>)aDelegate
{
    // parse score records and update match
    NSArray *continentArray = [outputArray objectAtIndex:CONTINENT_INDEX];
    NSArray *countryArray = [outputArray objectAtIndex:COUNTRY_INDEX];
    NSArray *leagueArray = [outputArray objectAtIndex:LEAGUE_INDEX];
    RepositoryManager *manager = [RepositoryManager defaultManager];
    [manager updateContinentArray:continentArray];
    [manager updateCountryArray:countryArray];
    [manager updateLeagueArray:leagueArray];
    
    if (aDelegate && [aDelegate respondsToSelector:@selector(didUpdateRepository:)]) {
        [aDelegate didUpdateRepository:ERROR_SUCCESS];
    }

}

- (void) updateRepository:(NSInteger)language delegate:(id<RepositoryDelegate>)aDelegate
{
    NSOperationQueue* queue = [self getOperationQueue:UPDATE_Repository];
    if (aDelegate && [aDelegate respondsToSelector:@selector(willUpdateRepository)]) {
        [aDelegate willUpdateRepository];
    }
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRepository:language];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (output.resultCode == ERROR_SUCCESS){
                
                // parse score records and update match
                [self dealWithOutputArray:output.arrayData delegate:nil];
                [self storeRepositoryData:output.arrayData];

//                NSArray *continentArray = [output.arrayData objectAtIndex:CONTINENT_INDEX];
//                NSArray *countryArray = [output.arrayData objectAtIndex:COUNTRY_INDEX];
//                NSArray *leagueArray = [output.arrayData objectAtIndex:LEAGUE_INDEX];
//                RepositoryManager *manager = [RepositoryManager defaultManager];
//                [manager updateContinentArray:continentArray];
//                [manager updateCountryArray:countryArray];
//                [manager updateLeagueArray:leagueArray];
            }
            
            if (aDelegate && [aDelegate respondsToSelector:@selector(didUpdateRepository:)]) {
                [aDelegate didUpdateRepository:output.resultCode];
            }

        });                       
    }];
}
#define MATCH_TYPE_INFO_INDEX 0
- (void) getGroupInfo:(int)language leagueId:(NSString*)leagueId season:(NSString*)season Delegate:(id<RepositoryDelegate>)aDelegate
{
    NSOperationQueue* queue = [self getOperationQueue:GET_GROUP_INFO];
    if (aDelegate && [aDelegate respondsToSelector:@selector(willUpdateRepository)]) {
        [aDelegate willUpdateRepository];
    }
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getCupScheduleMatchInfo:leagueId season:season language:language];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray* matchTypeArray = nil;
            
            if (output.resultCode == ERROR_SUCCESS){
                
                // parse score records and update match
                NSArray *array = [output.arrayData objectAtIndex:MATCH_TYPE_INFO_INDEX];
                RepositoryManager *manager = [RepositoryManager defaultManager];
                matchTypeArray = [manager getCupMatchTypes:array];
            }
            
            if (aDelegate && [aDelegate respondsToSelector:@selector(getGroupInfoFinish:)]) {
                [aDelegate getGroupInfoFinish:matchTypeArray];
            }
            
        });                       
    }];
}


@end
