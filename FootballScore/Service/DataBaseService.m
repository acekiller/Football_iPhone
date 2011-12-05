//
//  DataBaseService.m
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseService.h"
#import "FootballNetworkRequest.h"
#import "DataBaseManager.h"

#define UPDATE_DATABASE @"UPDATE_DATABASE"


@implementation DataBaseService


- (void) updateDataBase:(NSInteger)language delegate:(id<DataBaseDelegate>)aDelegate
{
    NSOperationQueue* queue = [self getOperationQueue:UPDATE_DATABASE];
    if (aDelegate && [aDelegate respondsToSelector:@selector(willUpdateDataBase)]) {
        [aDelegate willUpdateDataBase];
    }
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getDataBase:language];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (output.resultCode == ERROR_SUCCESS){
                
                // parse score records and update match
                NSArray *continentArray = [output.arrayData objectAtIndex:CONTINENT_INDEX];
                NSArray *countryArray = [output.arrayData objectAtIndex:COUNTRY_INDEX];
                NSArray *leagueArray = [output.arrayData objectAtIndex:LEAGUE_INDEX];
                DataBaseManager *manager = [DataBaseManager defaultManager];
                [manager updateContinentArray:continentArray];
                [manager updateContinentArray:countryArray];
                [manager updateLeagueArray:leagueArray];
            }
            
            if (aDelegate && [aDelegate respondsToSelector:@selector(didUpdateDataBase:)]) {
                [aDelegate didUpdateDataBase:output.resultCode];
            }

        });                       
    }];
}
@end
