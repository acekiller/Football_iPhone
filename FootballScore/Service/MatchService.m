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

#define GET_REALTIME_MATCH  @"GET_REALTIME_MATCH"

@implementation MatchService

- (void)getRealtimeMatch:(id<MatchServiceDelegate>)delegate
{
    int lang = 1; // TODO replace by LanguageManager    
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_MATCH];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRealtimeMatch:lang];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (output.resultCode == ERROR_SUCCESS){

                // parse server timestamp
//                NSDate* serverDate = 
                
                // parse league data                        
                NSArray* leagueArray = [LeagueManager fromString:[output.arrayData objectAtIndex:REALTIME_MATCH_LEAGUE]];                
            
                // step 1 : parser result into match array
//                NSArray* updateMatchArray = [MatchManager fromString:[output.arrayData objectAtIndex:1]];
            }
            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:@selector(getRealtimeMatchFinish:)]){
                [delegate getRealtimeMatchFinish:output.resultCode];
            }
        });                        
    }];
}

@end
