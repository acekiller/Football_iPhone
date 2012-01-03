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
#import "LanguageManager.h"
#import "TimeUtils.h"
#import "LogUtil.h"
#import "RetryManager.h"
#import "ConfigManager.h"

#define GET_REALTIME_MATCH  @"GET_REALTIME_MATCH"
#define GET_REALTIME_SCORE  @"GET_REALTIME_SCORE"
#define GET_MATCH_EVENT  @"GET_MATCH_EVENT"
#define GET_MATCH_DETAIL_HEADER @"GET_MATCH_DETAIL_HEADER"
#define GET_MATCH_OUPEI @"GET_MATCH_OUPEI"
#define UPDATE_FOLLOW_MATCH @"UPDATE_FOLLOW_MATCH"
#define FOLLOW_MATCH  @"FOLLOW_MATCH"
#define UNFOLLOW_MATCH  @"UNFOLLOW_MATCH"


@implementation MatchService

@synthesize realtimeScoreTimer;
@synthesize realtimeMatchTimer;
@synthesize matchControllerDelegate;
@synthesize scoreUpdateControllerDelegate;

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

//#define REALTIME_SCORE_TIMER_INTERVAL   10       // 10 seconds

- (void)startRealtimeScoreUpdate
{
    NSLog(@"<startRealtimeScoreUpdate>");

    // stop timer firstly
    [self stopRealtimeScoreUpdate];
    
    // create new timer
    self.realtimeScoreTimer = [NSTimer scheduledTimerWithTimeInterval:[ConfigManager getRefreshInterval] target:self selector:@selector(getRealtimeScore) userInfo:nil repeats:NO];
}

- (void)stopRealtimeMatchUpdate
{
    NSLog(@"<stopRealtimeMatchUpdate>");
    [realtimeMatchTimer invalidate];
    self.realtimeScoreTimer = nil;
    
//    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_MATCH];
//    if ([queue operationCount] > 0){
//        [queue cancelAllOperations];        
//    } 
}

- (void)startRealtimeMatchUpdate
{
    static int MATCH_UPDATE_INTERVAL = 30*60;
    
    //it used to update realtime match info every half an hour,for the match info may change during this time
    NSLog(@"<startRealtimeMatcheUpdate>");
    
    // stop timer firstly
    [self stopRealtimeMatchUpdate];
    
    // create new timer
    self.realtimeMatchTimer = [NSTimer scheduledTimerWithTimeInterval:MATCH_UPDATE_INTERVAL target:self selector:@selector(realtimeMatchUpdateTimerTask) userInfo:nil repeats:YES];
}

- (void)realtimeMatchUpdateTimerTask
{
    NSLog(@"<realtimeMatchUpdateTimer> Timer Task Fired");
    [self addRealtimeMatchUpdateToQueue:currentDelegate matchScoreType:currentScoreType];
}

- (void)getRealtimeMatch:(id<MatchServiceDelegate>)delegate matchScoreType:(int)matchScoreType
{
    currentDelegate = delegate;
    currentScoreType = matchScoreType;
    
    // stop timer to avoid incorrect update
    [self stopRealtimeScoreUpdate];
    [self addRealtimeMatchUpdateToQueue:delegate matchScoreType:matchScoreType];   
    
//    [self startRealtimeMatchUpdate];
//    [self startRealtimeScoreUpdate];
}

- (void)getRealtimeScore
{
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_SCORE];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRealtimeScore];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSSet* updateMatchSet = nil;
            NSSet* scoreUpdateSet = nil;
            
            if (output.resultCode == ERROR_SUCCESS){
                
                // parse score records and update match
                if ([output.arrayData count] > 0){
                    NSArray* realtimeScoreArray = [output.arrayData objectAtIndex:0];                    
                    
                    // update real time score info
                    scoreUpdateSet = [[MatchManager defaultManager] getScoreUpdateSet:realtimeScoreArray];

                    // update match info
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
            
            if (scoreUpdateControllerDelegate && [scoreUpdateControllerDelegate 
                                                  respondsToSelector:@selector(getScoreUpdateFinish:resultCode:)]){
                [scoreUpdateControllerDelegate getScoreUpdateFinish:scoreUpdateSet resultCode:output.resultCode];
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
    int lang = [LanguageManager getLanguage];
    NSOperationQueue* queue = [self getOperationQueue:GET_MATCH_EVENT];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getMatchDetail:lang matchId:matchId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            NSArray *eventArray = nil;
//            NSArray *statArray = nil;
//            Match *match = nil;
            if (output.resultCode == ERROR_SUCCESS){
                /* rem by Benson because the data processing is moved to Java Script
                eventArray = [output.arrayData objectAtIndex:MATCH_EVENT];
                statArray = [output.arrayData objectAtIndex:MATCH_TECHNICAL_STATISTICS];
                MatchManager *defaultManager = [MatchManager defaultManager];
                match = [defaultManager getMathById:matchId];
                [defaultManager updateMatch:match WithEventArray:eventArray];
                [defaultManager updateMatch:match WithStatArray:statArray];
                 */
            }
            
            // step 2 : update UI            
            if (delegate && [delegate respondsToSelector:@selector(getMatchEventFinish:data:)])
            {
                [delegate getMatchEventFinish:output.resultCode data:output.textData];
            }

        });                        
    }];
}

- (void)getMatchDetailHeader:(id<MatchServiceDelegate>)delegate matchId:(NSString*)matchId
{
    NSOperationQueue* queue = [self getOperationQueue:GET_MATCH_DETAIL_HEADER];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getMatchDetailHeader:matchId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *headerInfo = nil;
            
            if (output.resultCode == ERROR_SUCCESS){                
                if ([output.arrayData count] > 0) {
                    NSArray *headerArray = [output.arrayData objectAtIndex:0];
                    if ([headerArray count] > 0) {
                        headerInfo = [headerArray objectAtIndex:0];
                        PPDebug(@"<getMatchDetailHeader> get header info = %@", [headerInfo description]);
                    }
                    else{
                        PPDebug(@"<getMatchDetailHeader> get header info, but header info array is 0");
                    }
                }
                else{
                    PPDebug(@"<getMatchDetailHeader> get header info, but array data is 0");                    
                }
            }            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:@selector(getMatchDetailHeaderFinish:)]) {
                [delegate getMatchDetailHeaderFinish:headerInfo];
            }
        });                        
    }];
}

- (void)getMatchOupei:(id<MatchServiceDelegate>)delegate matchId:(NSString *)matchId
{
    NSOperationQueue* queue = [self getOperationQueue:GET_MATCH_OUPEI];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getMatchOupei:matchId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (delegate && [delegate respondsToSelector:@selector(getMatchOupeiFinish:data:)]) {
                [delegate getMatchOupeiFinish:output.resultCode data:output.textData];
            }
        });                        
    }];

}

- (void)stopAllUpdates
{
    [self stopRealtimeScoreUpdate];
    [self stopRealtimeMatchUpdate];
}

- (void)startAllUpdates:(id<MatchServiceDelegate>)delegate matchScoreType:(int)matchScoreType
{
    [self getRealtimeMatch:delegate matchScoreType:matchScoreType];
    //[self startRealtimeMatchUpdate];
}

- (void)addRealtimeMatchUpdateToQueue:(id<MatchServiceDelegate>)delegate matchScoreType:(int)matchScoreType
{
    int lang = [LanguageManager getLanguage]; 
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_MATCH];
    
    BOOL hasLeagueData = [[LeagueManager defaultManager] hasLeaguageData];
    
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
            
            if (!hasLeagueData){
                PPDebug(@"First time to create leaguage data, select all league");
                [[MatchManager defaultManager] selectAllLeague];
            }
            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:
                                    @selector(getRealtimeMatchFinish:serverDate:leagueArray:updateMatchArray:)]){
                [delegate getRealtimeMatchFinish:output.resultCode
                                             serverDate:serverDate leagueArray:leagueArray updateMatchArray:updateMatchArray];
            }
                        
            [self startRealtimeScoreUpdate];
            
        });                        
    }];
}

- (void)updateLatestFollowMatch
{
    NSOperationQueue* queue = [self getOperationQueue:UPDATE_FOLLOW_MATCH];
    MatchManager *manager = [MatchManager defaultManager];
    for (Match* match in [manager.followMatchList allValues]) {
        if ([match isFinish] == NO) { // if match is finished, no need to update
            [queue addOperationWithBlock:^{
                
                CommonNetworkOutput* output = [FootballNetworkRequest getMatchDetailHeader:match.matchId];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSArray *headerInfo = nil;
                    
                    if (output.resultCode == ERROR_SUCCESS){                
                        if ([output.arrayData count] > 0) {
                            NSArray *headerArray = [output.arrayData objectAtIndex:0];
                            if ([headerArray count] > 0) {
                                
                                headerInfo = [headerArray objectAtIndex:0];
                                                                
                                // update match data by header detail info
                                PPDebug(@"Update follow match(%@) by info(%@)", [match description], [headerInfo description]);
                                [match updateByHeaderInfo:headerInfo];                                
                            }
                        }
                    }    
                    

                });                        
            }];
        }
        else{
//            PPDebug(@"<updateLatestFollowMatch> skip request match (%@) detail because it's found", [match description]);
        }
    }
    
}

- (void)followMatch:(NSString*)userId match:(Match*)match
{
    NSOperationQueue* queue = [self getOperationQueue:FOLLOW_MATCH];
    MatchManager* manager = [MatchManager defaultManager];
    [manager followMatch:match];
    
    [queue addOperationWithBlock:^{
        CommonNetworkOutput* output = [FootballNetworkRequest followUnfollowMatch:userId matchId:match.matchId type:FOLLOW_MATCH_TYPE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(output.resultCode == ERROR_SUCCESS)
            {
                PPDebug(@"Follow match (%@) success", [match description]);
            }
            else
            {
                PPDebug(@"Follow match (%@) fail, error = %d", 
                        [match description], output.resultCode);
                
                // TODO save it to a retry list to send request later
                [[RetryManager defaultManager] addFollowUnfollowToUserDefaults:match.matchId type:FOLLOW_MATCH_TYPE];
            }
        });
    }];
}

- (void)unfollowMatch:(NSString*)userId match:(Match*)match
{
    NSOperationQueue* queue = [self getOperationQueue:UNFOLLOW_MATCH];
    MatchManager* manager = [MatchManager defaultManager];
    [manager unfollowMatch:match];
    
    [queue addOperationWithBlock:^{
        CommonNetworkOutput* output = [FootballNetworkRequest followUnfollowMatch:userId matchId:match.matchId type:UNFOLLOW_MATCH_TYPE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(output.resultCode == ERROR_SUCCESS)
            {
                PPDebug(@"Unfollow match (%@) success",[match description]);
            }
            else
            {
                PPDebug(@"Unfollow match (%@) fail,error = %d",[match description],output.resultCode);
                 // TODO save it to a retry list to send request later
                [[RetryManager defaultManager] addFollowUnfollowToUserDefaults:match.matchId type:UNFOLLOW_MATCH_TYPE];
            }
        });
    }];
}

@end
