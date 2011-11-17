//
//  OddsService.m
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OddsService.h"
#import "FootballNetworkRequest.h"
#import "CompanyManager.h"
#import "Company.h"
#import "OddsManager.h"
#import "YaPei.h"
#import "OuPei.h"
#import "DaXiao.h"
#import "League.h"
#import "Match.h"
#import "LeagueManager.h"
#define GET_COMPANY_LIST @"GET_COMPANY_LIST"
#define GET_ODDS_LIST    @"GET_ODDS_LIST"
#define GET_REALTIME_ODDS @"GET_REALTIME_ODDS"
@class YaPei;
@class OuPei;
@class DaXiao;

enum {
    INDEX_OF_COMPANY_ID = 0,
    INDEX_OF_COMPANY_NAME,
    INDEX_OF_ASIAN_ODDS,
    INDEX_OF_EUROPE_ODDS,
    INDEX_OF_DAXIAO
    };

enum {
    INDEX_OF_LEAGUE = 0,
    INDEX_OF_MATCH,
    INDEX_OF_PEILV
    };

enum LEAGUE_INDEX {
    INDEX_OF_LEAGUE_ID = 0,
    INDEX_OF_LEAGUE_NAME,
    INDEX_OF_LEAGUE_LEVEL
   
    };

enum MATCH_INDEX {
    INDEX_OF_MATCH_MATCH_ID = 0,
    INDEX_OF_MATCH_LEAGUE_ID,
    INDEX_OF_MATCH_TIME,
    INDEX_OF_HOME_TEAM_NAME,
    INDEX_OF_AWAY_TEAM_NAME,
    };

enum YAPEI_INDEX {
    INDEX_OF_ODDS_MATCH_ID = 0,
    INDEX_OF_ODDS_COMPANY_ID,
    INDEX_OF_ODDS_ODDS_ID,
    INDEX_OF_ODDS_CHUPAN,
    INDEX_OF_ODDS_HOMETEAM_CHUPAN,
    INDEX_OF_ODDS_AWAYTEAM_CHUPAN,
    INDEX_OF_ODDS_INSTANT_ODDS,
    INDEX_OF_ODDS_HOMETEAM_ODDS,
    INDEX_OF_ODDS_AWAYTEAM_ODDS
    
    };
enum DAXIAO_INDEX {
    INDEX_OF_ODDS_BIG_CHUPAN = 4,
    INDEX_OF_ODDS_SMALL_CHUPAN = 5,
    INDEX_OF_ODDS_BIG_ODDS = 7,
    INDEX_OF_ODDS_SMALL_ODDS = 8
    
    };

enum OUPEI_INDEX {
    INDEX_OF_ODDS_HOMEWIN_CHUPEI = 3,
    INDEX_OF_ODDS_DRAW_CHUPEI,
    INDEX_OF_ODDS_AWAYWIN_CHUPEI,
    INDEX_OF_ODDS_HOMEWIN_ODDS,
    INDEX_OF_ODDS_DRAW_ODDS,
    INDEX_OF_ODDS_AWAYWIN_ODDS,
    };


@implementation OddsService
@synthesize delegate;
@synthesize realTimeOddsType;
@synthesize realTimeOddsTimer;
- (void)updateAllBetCompanyList
{
    NSOperationQueue* queue = [self getOperationQueue:GET_COMPANY_LIST];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getBetCompanyList];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            CompanyManager* manager = [CompanyManager defaultCompanyManager];
            
            if (output.resultCode == ERROR_SUCCESS){
                if ([output.arrayData count] > 0) {
                    [manager.allCompany removeAllObjects];
                    NSArray* segment = [output.arrayData objectAtIndex:0];
                    if ([segment count] > 0) {
                        for (NSArray* data in segment) {
                            if ([data count] == 5) {
                                NSString* companyId = [data objectAtIndex:INDEX_OF_COMPANY_ID];
                                NSString* companyName = [data objectAtIndex:INDEX_OF_COMPANY_NAME];
                                NSString* asianOdds = [data objectAtIndex:INDEX_OF_ASIAN_ODDS];
                                NSString* europeOdds = [data objectAtIndex:INDEX_OF_EUROPE_ODDS];
                                NSString* daXiao = [data objectAtIndex:INDEX_OF_DAXIAO];
                                
                                Company* company = [[Company alloc] initWithId:companyId 
                                                                   companyName:companyName 
                                                                      asianBet:[asianOdds boolValue] 
                                                                     europeBet:[europeOdds boolValue] 
                                                                        daXiao:[daXiao boolValue]];
                                [manager addCompany:company];
                                [company release];
                            } else {
                                continue;
                            }
                            
                        }
                    }
                    else {
                        NSLog(@"segment format error:%@",[segment description]);
                    }
                   
                }
                else {
                    NSLog(@"no company list updated");
                }                
            }

        });                        
    }];

}

- (void)getOddsListByDate:(NSDate*)date 
            companyIdArray:(NSArray*)companyIdAray 
                  language:(int)language 
                 matchType:(int)matchType 
                 oddsType:(int)oddsType 
                 delegate:(id<OddsServiceDelegate>)delegate
 {
     NSOperationQueue* queue = [self getOperationQueue:GET_ODDS_LIST];
     [queue addOperationWithBlock:^{
         
         CommonNetworkOutput* output = [FootballNetworkRequest getOddsListByDate:date companyIdArray:companyIdAray language:language matchType:matchType oddsType:oddsType];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             OddsManager* manager = [OddsManager defaultManager];
             
             if (output.resultCode == ERROR_SUCCESS){
                 if ([output.arrayData count] > 0) {
                     //[manager.allCompany removeAllObjects];
                     //OddsManager* manager = [OddsManager defaultManager];
                     NSMutableArray* leagueArray = [output.arrayData objectAtIndex:INDEX_OF_LEAGUE];
                     NSMutableArray* matchArray = [output.arrayData objectAtIndex:INDEX_OF_MATCH];
                     NSMutableArray* oddsArray = [output.arrayData objectAtIndex:INDEX_OF_PEILV];
                     
                     if ([leagueArray count] > 0) {
                         [manager.leagueArray removeAllObjects];
                         for (NSArray* data in leagueArray) {
                             NSString* leagueId = [data objectAtIndex:INDEX_OF_LEAGUE_ID];
                             NSString* leagueName = [data objectAtIndex:INDEX_OF_LEAGUE_NAME];
                             NSString* leagueLevel = [data objectAtIndex: INDEX_OF_LEAGUE_LEVEL];
                             
                             League* league = [[League alloc] initWithName:leagueName leagueId:leagueId isTop:[leagueLevel boolValue]];
                             [manager.leagueArray addObject:league];
                             [league release];
                         }
                     }
                     else {
                         NSLog(@"Get league array error:%@",[leagueArray description]);
                     }
                     
                     
                     
                     
                     
                     
                     //  Tom add this 
                     
                     // parse league data and update        
                     
                     
                     NSArray  *indexLeagueArray ;
                     
                     indexLeagueArray =  [LeagueManager fromIndexString:[output.arrayData objectAtIndex:INDEX_OF_LEAGUE]];
                     
                     [[LeagueManager defaultIndexManager] updateLeague:indexLeagueArray];
                     
                     

                     
                     
                     
                     
                     if ([matchArray count] > 0) {
                         [manager.matchArray removeAllObjects];
                         for (NSArray* data in matchArray) {
                             NSString* matchId = [data objectAtIndex:INDEX_OF_MATCH_MATCH_ID];
                             NSString* leagueId = [data objectAtIndex:INDEX_OF_MATCH_LEAGUE_ID];
                             NSString* matchTime = [data objectAtIndex:INDEX_OF_MATCH_TIME];
                             NSString* homeTeamName = [data objectAtIndex:INDEX_OF_HOME_TEAM_NAME];
                             NSString* awayTeamName = [data objectAtIndex:INDEX_OF_AWAY_TEAM_NAME];
                             
                             Match* match = [[Match alloc] initWithId:matchId leagueId:leagueId date:matchTime homeTeamName:homeTeamName awayTeamName:awayTeamName];
                             [manager.matchArray addObject:match];
                             [match release];
                         }
                     }
                     else {
                         NSLog(@"Get match error:%@",[matchArray description]);
                     }
                     
                     if ([oddsArray count] > 0) {
                         switch (oddsType) {
                             case ODDS_TYPE_YAPEI:
                                 [manager.yapeiArray removeAllObjects];
                                 for (NSArray* data in oddsArray) {
                                     NSString* matchId = [data objectAtIndex:INDEX_OF_ODDS_MATCH_ID];
                                     NSString* companyID = [data objectAtIndex:INDEX_OF_ODDS_COMPANY_ID];
                                     NSString* oddsId = [data objectAtIndex:INDEX_OF_ODDS_ODDS_ID];
                                     NSString* chupan = [data objectAtIndex:INDEX_OF_ODDS_CHUPAN];
                                     NSString* homeTeamChupan = [data objectAtIndex:INDEX_OF_ODDS_HOMETEAM_CHUPAN];
                                     NSString* awayTeamChupan = [data objectAtIndex:INDEX_OF_ODDS_AWAYTEAM_CHUPAN];
                                     NSString* instantOdds = [data objectAtIndex:INDEX_OF_ODDS_INSTANT_ODDS];
                                     NSString* homeTeamOdds = [data objectAtIndex:INDEX_OF_ODDS_HOMETEAM_ODDS];
                                     NSString* awayTeamOdds = [data objectAtIndex:INDEX_OF_ODDS_AWAYWIN_ODDS];
                                     
                                     YaPei* yapei = [[YaPei alloc] initWithMatchId:matchId companyId:companyID oddsId:oddsId chupan:chupan homeTeamChupan:homeTeamChupan awayTeamChupan:awayTeamChupan instantOdds:instantOdds homeTeamOddds:homeTeamOdds awayTeamOdds:awayTeamOdds];
                                     [manager.yapeiArray addObject:yapei];
                                     [yapei release];                            
                                     
                                     
                                 }
                                 break;
                             case ODDS_TYPE_DAXIAO:
                                 [manager.daxiaoArray removeAllObjects];
                                 for (NSArray* data in oddsArray) {
                                     NSString* matchId = [data objectAtIndex:INDEX_OF_ODDS_MATCH_ID];
                                     NSString* companyID = [data objectAtIndex:INDEX_OF_ODDS_COMPANY_ID];
                                     NSString* oddsId = [data objectAtIndex:INDEX_OF_ODDS_ODDS_ID];
                                     NSString* chupan = [data objectAtIndex:INDEX_OF_ODDS_CHUPAN];
                                     NSString* bigBallChupan = [data objectAtIndex:INDEX_OF_ODDS_HOMETEAM_CHUPAN];
                                     NSString* smallBallChupan = [data objectAtIndex:INDEX_OF_ODDS_AWAYTEAM_CHUPAN];
                                     NSString* instantOdds = [data objectAtIndex:INDEX_OF_ODDS_INSTANT_ODDS];
                                     NSString* bigBallOdds = [data objectAtIndex:INDEX_OF_ODDS_HOMETEAM_ODDS];
                                     NSString* smallBallOdds = [data objectAtIndex:INDEX_OF_ODDS_AWAYWIN_ODDS];
                                     
                                     DaXiao* daxiao = [[DaXiao alloc] initWithMatchId:matchId companyId:companyID oddsId:oddsId chupan:chupan bigBallChupan:bigBallChupan smallBallChupan:smallBallChupan instantOdds:instantOdds bigBallOdds:bigBallOdds smallBallOdds:smallBallOdds];
                                     [manager.daxiaoArray addObject:daxiao];
                                     [daxiao release];
                                     
                                     
                                     
                                 }
                                 break;
                             case ODDS_TYPE_OUPEI:
                                 [manager.oupeiArray removeAllObjects];
                                 for (NSArray* data in oddsArray) {
                                     NSString* matchId = [data objectAtIndex:INDEX_OF_ODDS_MATCH_ID];
                                     NSString* companyID = [data objectAtIndex:INDEX_OF_ODDS_COMPANY_ID];
                                     NSString* oddsId = [data objectAtIndex:INDEX_OF_ODDS_ODDS_ID];
                                     NSString* homeWinChupei= [data objectAtIndex:INDEX_OF_ODDS_CHUPAN];
                                     NSString* drawChupei = [data objectAtIndex:INDEX_OF_ODDS_HOMETEAM_CHUPAN];
                                     NSString* awayWinChupei = [data objectAtIndex:INDEX_OF_ODDS_AWAYTEAM_CHUPAN];
                                     NSString* homeWinOdds = [data objectAtIndex:INDEX_OF_ODDS_INSTANT_ODDS];
                                     NSString* drawOdds = [data objectAtIndex:INDEX_OF_ODDS_HOMETEAM_ODDS];
                                     NSString* awayWinOdds = [data objectAtIndex:INDEX_OF_ODDS_AWAYWIN_ODDS];
                                     
                                     OuPei* oupei = [[OuPei alloc] initWithMatchId:matchId companyId:companyID oddsId:oddsId homeWinInitOdds:homeWinChupei drawInitOdds:drawChupei awayWinInitOdds:awayWinChupei homeWinInstantOdds:homeWinOdds drawInstantOdds:drawOdds awayWinInstantsOdds:awayWinOdds];
                                     [manager.oupeiArray addObject:oupei];
                                     [oupei release];                            
                                     
                                     
                                 }
                                 break;
                             default:
                                 break;
                         }
                     }
                     else {
                         NSLog(@"look,no odds data:%@",[oddsArray description]);
                     }
                     
                     if (delegate && [delegate respondsToSelector:@selector(getOddsListFinish)]) {
                         [delegate getOddsListFinish];
                     }
                     
                 }
                 else {
                     NSLog(@"no odds, leagues, matches got");
                 }                
             }
             
         });                        
     }];
     
 }


- (void)getRealtimeOdds
{
    NSOperationQueue* queue = [self getOperationQueue:GET_COMPANY_LIST];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getRealtimeOdds:realTimeOddsType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                        
            if (output.resultCode == ERROR_SUCCESS){
                NSSet* oddsUpdateSet = nil;
                if ([output.arrayData count] > 0) {
                    NSArray* segment = [output.arrayData objectAtIndex:0];
                    
                    if ([segment count] > 0) {
                        oddsUpdateSet = [[OddsManager defaultManager] getOddsUpdateSet:segment oddsType:realTimeOddsType];
                    }
                    else {
                        NSLog(@"segment format error:%@",[segment description]);
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(getRealtimeOddsFinish::)]) {
                        [self.delegate getRealtimeOddsFinish:oddsUpdateSet oddsType:realTimeOddsType];
                    }   
                    
                }
                else {
                    NSLog(@"no odds change list updated");
                }   
           
            }

            [self startGetRealtimOddsTimer:realTimeOddsType delegate:self.delegate];
        });                        
    }];
}

#ifndef REALTIME_ODDS_TIMER_INTERVAL 
    #define REALTIME_ODDS_TIMER_INTERVAL 10
#endif

- (void)startGetRealtimOddsTimer:(ODDS_TYPE)oddsType delegate:(id<OddsServiceDelegate>)delegate
{
    self.delegate = delegate;
    self.realTimeOddsType = oddsType;
    
    NSLog(@"<startGetRealtimOddsTimerUpdate>");
    
    
    if (oddsType >= ODDS_TYPE_YAPEI && oddsType <=ODDS_TYPE_OUPEI) {
        // stop timer firstly
        [self stopGetRealtimOddsTimer];
        
        // create new timer
        self.realTimeOddsTimer = [NSTimer scheduledTimerWithTimeInterval:REALTIME_ODDS_TIMER_INTERVAL target:self selector:@selector(getRealtimeOdds) userInfo:nil repeats:NO];
    }

}
- (void)stopGetRealtimOddsTimer
{
    NSLog(@"<stopRealtimeOddsUpdate>");
    [self.realTimeOddsTimer invalidate];
    self.realTimeOddsTimer = nil;
    
    NSOperationQueue* queue = [self getOperationQueue:GET_REALTIME_ODDS];
    if ([queue operationCount] > 0){
        [queue cancelAllOperations];        
    } 
}

-(void)dealloc
{
    [realTimeOddsTimer release];
    [super dealloc];
}

@end
