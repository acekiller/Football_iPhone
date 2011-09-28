//
//  MatchService.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchService.h"
#import "FootballNetworkRequest.h"
#import "League.h"
#import "LeagueManager.h"
#import "Match.h"
#import "MatchManager.h"
#import "TimeUtils.h"

#define GET_REALTIME_MATCH  @"GET_REALTIME_MATCH"

@implementation MatchService

- (void)getRealtimeMatch:(id<MatchServiceDelegate>)delegate
{
    int lang = 1; // TODO replace by LanguageManager    
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_MATCH];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRealtimeMatch:lang];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDate* serverDate = nil;
            NSArray* leagueArray = nil;
            NSArray* updateMatchArray = nil;
            
            if (output.resultCode == ERROR_SUCCESS){

                // parse server timestamp
                // TODO it's a string in the array!
//                serverDate = dateFromChineseStringByFormat(
//                              [output.arrayData objectAtIndex:REALTIME_MATCH_SERVER_TIMESTAMP],
//                                                           DEFAULT_DATE_FORMAT);
                
                // parse league data and update                        
                leagueArray = [LeagueManager fromString:
                               [output.arrayData objectAtIndex:REALTIME_MATCH_LEAGUE]];    
                
                [[LeagueManager defaultManager] updateLeague:leagueArray];
            
                // parser result into match array
                updateMatchArray = [MatchManager fromString:
                                    [output.arrayData objectAtIndex:REALTIME_MATCH_DATA]];
            }
            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:
                             @selector(getRealtimeMatchFinish:serverDate:leagueArray:updateMatchArray:)]){
                [delegate getRealtimeMatchFinish:output.resultCode
                 serverDate:serverDate leagueArray:leagueArray updateMatchArray:updateMatchArray];
            }
        });                        
    }];
}

@end
