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
#define GET_REALTIME_SCORE  @"GET_REALTIME_SCORE"
#define GET_MATCH_EVENT  @"GET_MATCH_EVENT"

@implementation MatchService

@synthesize realtimeScoreTimer;
@synthesize matchControllerDelegate;

- (NSDate*)parseSeverDate:(NSArray*)dataArray
{
    if ([dataArray count] == 0)
        return nil;
    
    NSArray* fields = [dataArray objectAtIndex:0];
    if ([fields count] == 0)
        return nil;
    
    NSString* dateString = [fields objectAtIndex:0];
    if (dateString == nil)
        return nil;
    
    return dateFromChineseStringByFormat(dateString, DEFAULT_DATE_FORMAT);
}

- (void)stopRealtimeScoreUpdate
{
    NSLog(@"<stopRealtimeScoreUpdate>");
    [realtimeScoreTimer invalidate];
    self.realtimeScoreTimer = nil;
    
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_SCORE];
    if ([queue operationCount] > 0){
        [queue cancelAllOperations];        
    }
}

#define REALTIME_SCORE_TIMER_INTERVAL   5       // 5 seconds

- (void)startRealtimeScoreUpdate
{
    NSLog(@"<startRealtimeScoreUpdate>");

    // stop timer firstly
    [self stopRealtimeScoreUpdate];
    
    // create new timer
    self.realtimeScoreTimer = [NSTimer scheduledTimerWithTimeInterval:REALTIME_SCORE_TIMER_INTERVAL target:self selector:@selector(getRealtimeScore) userInfo:nil repeats:NO];
}

- (void)getRealtimeMatch:(id<MatchServiceDelegate>)delegate matchScoreType:(int)matchScoreType
{
    int lang = 1; // TODO replace by LanguageManager    
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_MATCH];

    // stop timer to avoid incorrect update
    [self stopRealtimeScoreUpdate];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRealtimeMatch:lang
                                                                     scoreType:matchScoreType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDate* serverDate = nil;
            NSArray* leagueArray = nil;
            NSArray* updateMatchArray = nil;
            
            if (output.resultCode == ERROR_SUCCESS){

                // parse server timestamp and update 
                serverDate = [self parseSeverDate:
                              [output.arrayData objectAtIndex:REALTIME_MATCH_SERVER_TIMESTAMP]];
                [[MatchManager defaultManager] updateServerDate:serverDate];
                
                // parse league data and update                        
                leagueArray = [LeagueManager fromString:
                               [output.arrayData objectAtIndex:REALTIME_MATCH_LEAGUE]];                    
                [[LeagueManager defaultManager] updateLeague:leagueArray];
            
                // parser result into match array and update
                updateMatchArray = [MatchManager fromString:
                                    [output.arrayData objectAtIndex:REALTIME_MATCH_DATA]];
                [[MatchManager defaultManager] updateAllMatchArray:updateMatchArray];
            }
            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:
                             @selector(getRealtimeMatchFinish:serverDate:leagueArray:updateMatchArray:)]){
                [delegate getRealtimeMatchFinish:output.resultCode
                 serverDate:serverDate leagueArray:leagueArray updateMatchArray:updateMatchArray];
            }
            
            // no matter what result it is, start the score update timer again
            [self startRealtimeScoreUpdate];
        });                        
    }];
}

- (void)getRealtimeScore
{
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_SCORE];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRealtimeScore];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSSet* updateMatchSet = nil;
            if (output.resultCode == ERROR_SUCCESS){
                
                // parse score records and update match
                if ([output.arrayData count] > 0){
                    NSArray* realtimeScoreArray = [output.arrayData objectAtIndex:0];
                    updateMatchSet = [[MatchManager defaultManager] 
                                      updateMatchRealtimeScore:realtimeScoreArray];
                }
                else{
                    NSLog(@"no realtime score updated");
                }                
            }
            
            // step 2 : update UI
            if (matchControllerDelegate && [matchControllerDelegate 
                                            respondsToSelector:@selector(getRealtimeScoreFinish:)]){
                [matchControllerDelegate getRealtimeScoreFinish:updateMatchSet];
            }
            
//            if (delegate && [delegate respondsToSelector:
//                             @selector(getRealtimeMatchFinish:serverDate:leagueArray:updateMatchArray:)]){
//                [delegate getRealtimeMatchFinish:output.resultCode
//                                      serverDate:serverDate leagueArray:leagueArray updateMatchArray:updateMatchArray];
//            }
            
            // schedule next timer
            [self startRealtimeScoreUpdate];
        });                        
    }];
}    

- (void)getMatchEvent:(id<MatchServiceDelegate>)delegate matchId:(NSString*)matchId
{
    int lang = 1; // TODO replace by LanguageManager    
    NSOperationQueue* queue = [self getOperationQueue:GET_MATCH_EVENT];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getMatchDetail:lang matchId:matchId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *eventArray = nil;
            NSArray *statArray = nil;
            Match *match = nil;
            if (output.resultCode == ERROR_SUCCESS){
                eventArray = [output.arrayData objectAtIndex:MATCH_EVENT];
                statArray = [output.arrayData objectAtIndex:MATCH_TECHNICAL_STATISTICS];
                MatchManager *defaultManager = [MatchManager defaultManager];
                match = [defaultManager getMathById:matchId];
                [defaultManager updateMatch:match WithEventArray:eventArray];
                [defaultManager updateMatch:match WithStatArray:statArray];
            }
            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:@selector(getMatchEventFinish:match:)])
            {
                [delegate getMatchEventFinish:output.resultCode match:match];
            }
        });                        
    }];
}

@end
