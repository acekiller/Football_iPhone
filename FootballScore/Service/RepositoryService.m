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

#define UPDATE_Repository @"UPDATE_Repository"


@implementation RepositoryService


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
                NSArray *continentArray = [output.arrayData objectAtIndex:CONTINENT_INDEX];
                NSArray *countryArray = [output.arrayData objectAtIndex:COUNTRY_INDEX];
                NSArray *leagueArray = [output.arrayData objectAtIndex:LEAGUE_INDEX];
                RepositoryManager *manager = [RepositoryManager defaultManager];
                [manager updateContinentArray:continentArray];
                [manager updateContinentArray:countryArray];
                [manager updateLeagueArray:leagueArray];
            }
            
            if (aDelegate && [aDelegate respondsToSelector:@selector(didUpdateRepository:)]) {
                [aDelegate didUpdateRepository:output.resultCode];
            }

        });                       
    }];
}
@end
